clear
clc
close all
 blms = dsp.BlockLMSFilter(10,5);
 blms.StepSize = 0.01;
 blms.BlockSize = 13;
 blms.WeightsOutputPort = false;
 filt = dsp.FIRFilter;
 filt.Numerator = fir1(10,[.5, .75]);
 x = randn(22529,1); % Noise
 %x = randn(1000,1); % Noise
 my_signal = audioread('sp01_train_sn0.wav');
 figure
plot(my_signal); title('My train signal');
 my_signal = reshape(my_signal , [1,22529]);
 %d = filt(x) + sin(0:.05:49.95)'; % Noise + Signal
 %d = filt(x) + my_signal'; % Noise + Signal
 d = filt(x); % Noise + Signal
 [y, err] = blms(x, d);
 
 figure
 subplot(2,1,1);
 plot(d);
 title('Noise + Signal');
 subplot(2,1,2);
 plot(err);
 title('Signal');
 
 figure
 plot(err);
 title('Signal');
 axis ([0 25000 -0.4 0.5])
