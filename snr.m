%apagando tudo
clc;
clear all;
%%%%%%%%%%%
Half = 60*pi/180;
m = log(0.5)/log(cos(Half));
fi =  (0:0.5:360)*pi/180;
cos_fi =  cos(fi).^m;
R = ((m+1)*(cos(fi)).^m)/(2*pi);
figure(1)
    hold on
    plot(fi,R)
    hold off