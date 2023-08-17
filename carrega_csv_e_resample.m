clear all; close all; clc;

Npontos = 1.4e6;
planilha = dlmread ('vinicius.csv', ',', 3, 1);
y = planilha(:,1); 
Fs= 100e3;
y = y(3*Fs:13*Fs);

Ts = 1/Fs;
t = 0:Ts:(length(y)-1)*Ts;
plot(t,y)


p = 44100; % Freq. de amostrag
q = 100000;
yr = resample(y,p,q);
Tsr = 1/p;
tr = 0:Tsr:(length(yr)-1)*Tsr;
figure;
plot(tr, yr)

save Rx_csv.mat yr