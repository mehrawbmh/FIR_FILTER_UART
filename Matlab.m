clc
close all
clear all;
%*****************Defining serial port*************************************
obj1 = instrfind('Type', 'serial', 'Port', 'COM7', 'Tag', '');
if isempty(obj1)
    obj1 = serial('COM7');
else
    fclose(obj1);
    obj1 = obj1(1);
end
set(obj1, 'InputBufferSize', 500000,'OutputBufferSize', 500000, 'baudrate',115200, 'Timeout', 2);
fopen(obj1);
flushinput(obj1);
fprintf('Port Opened \n');
%*******************load sound file****************************************
[inputs,Fs] = audioread('input.wav',[1 110000], 'native');
fprintf('finished loading file \n')
output = zeros(size(inputs,1),1);
inputs = double(inputs);

%*******************send bytes to serial***********************************
%fwrite(obj1, inputs);
for i=1:size(inputs,1)
    if (inputs(i) < 0)
        inputs(i) = 65536 + inputs(i);
    end
    fwrite(obj1, floor(inputs(i)/256));
    fwrite(obj1, mod(inputs(i),256));
    if ( mod(i, 358) == 0)
        fprintf('%d\n',i)
    end
end
fprintf('all data sent successfully \n')
%************************read received data**************************************
raw_data = fread(obj1);
%***********************append all data************************************
for i=1:size(inputs,1)
    output(i) = raw_data(2*i-1)*256 + raw_data(2*i);
end
fprintf('all data received successfully \n')
%fclose(obj1);

idx = output > (2^15-1);
output(idx) = output(idx) - 2^16;
output = output/(2^10);

sound(output, Fs);
audiowrite('Filtered_signal.wav',output ,Fs);
fprintf('Filtered sound saved successfully \n');

