clear
[y,fs]=audioread('alone hero.MP3');
y1=y(:,1);%取单列
N=length(y1);%求信号长度
Y=fft(y1,N);%傅里叶变换
t=(0:(N-1))/fs;%时间
f=0:fs/N:fs*(N-1)/N;%频率
w=2*f/fs;%归一化
%原信号时域波形和频谱图
figure(1);
subplot(2,1,1);
plot(t,y1);
axis([0,15,-1.5,1.5]);
xlabel('时间t');
ylabel('幅度');
title('原信号时域波形');

subplot(2,1,2);
plot(w,abs(Y));
xlabel('w');
ylabel('幅度');
title('原信号频谱图');

%加三sin混合噪声
A0=0.05;%噪声幅度
d1=A0*sin(2*pi*3000*t);%3kHz的余弦噪音
d2=A0*sin(2*pi*5000*t);%5kHz的余弦噪音
d3=A0*sin(2*pi*10000*t);%10kHz的余弦噪音
x1=d1+d2+d3;%噪声叠加
X1=fft(x1);%噪声傅里叶变换
y2=y1+(x1)';%加三余弦混合噪声后信号
Y1=fft(y2);%加噪信号傅里叶变换
figure(2);
subplot(3,2,1);
plot(w,abs(X1));

xlabel('w');
ylabel('幅度');
title('三正弦噪声频谱');
subplot(3,2,3);
plot(t,y2);
axis([0,15,-1.5,1.5]);
xlabel('时间t');
ylabel('幅度');
title('加三余弦噪声信号时域波形');
subplot(3,2,5);
plot(w,abs(Y1));
xlabel('w');
ylabel('幅度');
title('加三余弦噪声信号频谱图');

%加随机白噪声

x2=0.3*randn(N,1);%噪声
X2=fft(x2);%噪声傅里叶变换
y3=y1+x2;%加随机噪声后信号
Y2=fft(y3);%加噪信号傅里叶变换
y4=y1+x2+(x1)';
subplot(3,2,2);
plot(w,abs(X2));
xlabel('w');
ylabel('幅度');
title('随机白噪声频谱图');
subplot(3,2,4);
plot(t,y3);
axis([0,15,-2,2]);
xlabel('时间t');
ylabel('幅度');
title('加随机噪声信号时域波形');
subplot(3,2,6);
plot(w,abs(Y2));
xlabel('w');
ylabel('幅度');
title('加随机噪声信号频谱图');

% %巴特沃斯滤波器去噪
wp=0.1;ws=0.16;Rp=1;Rs=15;
[n1,Wn1]=buttord(wp,ws,Rp,Rs,'s');%求低通滤波器的阶数和截止频率
[b1,a1]=butter(n1,Wn1,'s');%求s域的频率响应的参数
[b2,a2]=bilinear(b1,a1,1);%利用双线性变换实现频率响应s域到z域的变换
z1=filter(b2,a2,y2);%求滤三余弦混合噪声后的信号
z2=filter(b2,a2,y3);%求滤随机噪声后的信号
z3=filter(b2,a2,y4);%求滤随机噪声和三余弦混合噪声后的信号
  %画滤噪后的图
m1=fft(z1);
m2=fft(z2);
figure(3);
subplot(2,2,1);
plot(t,z1);
axis([0,15,-1.5,1.5]);
xlabel('时间t');
ylabel('幅度');
title('滤三余弦噪声后信号时域波形');
subplot(2,2,3);
plot(w,abs(m1));
xlabel('w');
ylabel('幅度');
title('滤三余弦噪声后信号频谱');
subplot(2,2,2);
plot(t,z2);
axis([0,15,-1.5,1.5]);
xlabel('时间t');
ylabel('幅度');
title('滤随机噪声后信号时域波形');
subplot(2,2,4);
plot(w,abs(m2));
xlabel('w');
ylabel('幅度');
title('滤随机噪声后信号频谱');
% 
% sound(y1,fs);%原音乐
% pause(5);
% sound(y2,fs);%加三余弦噪声
% pause(5);
% sound(y3,fs);%加随机噪声
% pause(5);
% 
% sound(z1,fs);%滤三正弦噪声
% pause(5);
% sound(z2,fs);%滤随机噪声
% pause(5);
% sound(z3,fs);%滤波三余弦和随机噪声
