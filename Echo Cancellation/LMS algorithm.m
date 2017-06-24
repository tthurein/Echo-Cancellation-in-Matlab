d = 100; %echo delay
%gsig = randn(16000,1);
gsig = audioread ('Hello_Echoe.wav');
sound(gsig);
%pause(0.1);
x = gsig (d+1:end);
y = gsig (d+1:end) + 0.4*gsig(1:end-d);


 subplot (4,1,1); plot(gsig); title ('OG Signal');

M=3*d;
delta = 0.0001;
h = zeros(M,1);
ev = [];

for i = M+1:length(x)
    xn = x(i); %Desired sample value
    yn = y(i-M+1:i);
    xnhat = h'*yn;  %Filter output. 
    en = xn- xnhat;
    h = h+ delta*yn*en;
    
    
    ev = [ev abs(en)];
    sub = xn - ev;
    if rem (i,100) ==0;
        subplot (4,1,2); plot (h) ; title ('Impluse Response');
        subplot (4,1,3); plot (ev); title ('|error|');
        subplot (4,1,4); plot (sub); title ('"No Echo"');
        pause (0.001);
    end
end

