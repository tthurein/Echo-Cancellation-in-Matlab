clc
 clear
 close all
 
 fs = 8000; 
  %Original signal 
  mySig = audioread('sp02.wav');
  disp('Original speech Signal') 
  p8 = audioplayer(mySig,fs);
  t = mySig/fs;
  figure(1)
  subplot(2,1,1);
  playblocking(p8);
  plot(mySig);
 xlabel('Time [sec]');
  ylabel('Amplitude');
  title('Speech Signal');
  set(gcf, 'Color', [1 1 1])
  
  %CREATE ECHO FOR THE ORIGINAL SIGNAL. 
 pause                        %wait for key press
 disp('Echoed speech Signal')
 
%echo_vector=[1 zeros(1,2*fs) 0.7*exp(1i*pi/3.5) zeros(1,2*fs) 0.5*exp(1i*1.2*pi)];
echo_vector=[1 zeros(1,0.25*fs) 0.5*exp(1i*pi/3.5)];
%echo_vector=[1 zeros(1,0.25*fs)];
my_echoed     = real(conv(mySig, echo_vector));
p8 = audioplayer(my_echoed,fs);
  playblocking(p8);
  subplot(2,1,2);
 plot(my_echoed,'g');
 ylabel('Amplitude');
 title('Echo Speech Signal');
 
 %_______________Filtering out the echo. 
 %Step 1: get room impluse response
 M = 4001;
 %Already defined the sampling rate (Voice frequency ranges from 300-3400Hs)
 [B,A] = cheby2(4,20,[0.1 0.7]);
 Hd = dfilt.df2t([zeros(1,6) B], A);
 hFVT = fvtool(Hd);
 set(hFVT, 'color', [1 1 1])
 H = filter(Hd,log(0.99*rand(1,M)+0.01).* ...
     sign(randn(1,M)).*exp(-0.002*(1:M)));
 H = H/norm(H)*4;    % Room Impulse Response
 figure(3)
 plot(0:1/fs:0.5,H)
 
xlabel('Time [sec]');
ylabel('Amplitude');
title('Room Impulse Response');
set(gcf, 'Color', [1 1 1])
%=============step 2: filter far-end(echoed signal) using room impulse
%The echoed signal is already loaded. 
my_echoed = my_echoed(1:length(my_echoed));
 dhat = filter(H, 1,my_echoed); % fILTER W/ room responce.
 %dhat represents the far-end signal. 
 d=dhat;
 
 %================step 3: pass the echoed signal to LMS filter
 mu = 0.002; 
 W0 = zeros(1,2048);
 del = 0.01;
 lam = 0.98;
 x = my_echoed;
 x = x(1:length(W0)*floor(length(x)/length(W0)));
d = d(1:length(W0)*floor(length(d)/length(W0)));
 
 %FDAF filter, useful for identifying long impulse response. 
 %Here we construct the Freequency-Domain Adaptive Filter. 
 hFDAF = adaptfilt.fdaf(2048,mu,1,del,lam);   %e is after the filter
[y,e] = filter(hFDAF,x,d);
n = 1:length(e);
t = n/fs;

%PLOT AND playing the signal after filtering. 
figure
pos = get(gcf, 'Position'); %gcf=current figure handle 

set(gcf,'Position',[pos(1), pos(2)-100,pos(3),(pos(4)+85)])

subplot(3,1,1);
plot(mySig);
ylabel('Amplitude');
title('Speech Signal');
subplot(3,1,2);
plot(my_echoed,'r');
ylabel('Amplitude');
title('Echoed Signal');
set(gcf, 'Color', [1 1 1])
subplot(3,1,3);
plot(t,e(n),'g');
axis([0 3 -1 1]);
xlabel('Time [sec]');
ylabel('Amplitude');
title('Output of Acoustic Echo Canceller \mu =0.025');
set(gcf, 'Color', [1 1 1])
pause                                        %wait for key press
disp('Playing mixed Speech Signal after filter mu =0.002')
p8 = audioplayer(e/max(abs(e)),fs);
playblocking(p8);
