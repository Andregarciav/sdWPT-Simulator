%apagando tudo
clc;
clear all;
%%%%%%%%%%%
format long
Half = 60*pi/180;
m = log(0.5)/log(cos(Half));
fi =  (0:0.5:360)*pi/180;
cos_fi =  cos(fi).^m;
R = ((m+1)*(cos(fi)).^m)/(2*pi);
figure(1)
    hold on
    plot(fi,R)
    grid
    hold off
d = 0.10:0.1:5;
R = ((m+1)*(cos(0)).^m)/(2*pi);
dc_gain = 1:length(d);
for r=1:length(d)
    dc_gain(r) = 5*R * (1e-4/d(r)^2)*1;
end
figure(2)
    hold on
    plot(dc_gain)
    grid
    hold off