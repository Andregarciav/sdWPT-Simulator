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
d = 0.0:0.01:5;
R = ((m+1)*(cos(0)).^m)/(2*pi)
dc_gain = 1:length(d);
for r=1:length(d)
    dc_gain(r) = 5*R * (1e-4/d(r)^2)*1;
end
figure(2)
    hold on
    plot(d,dc_gain)
    grid
    hold off

prob = ([88.53 80 60 40 20 0]/100);
dista = [0 10 354 425 462 500]/100;
% d = 0:0.01:5;
p = interp1 (dista, prob,d, 'pchip');

figure(3)
    hold on
    grid;
    plot(dista,prob, 'o')
    plot(d,p)
    legend('Probability points','Interpolation function')
    xlabel('Distance (m)');
    ylabel('Probability');
        
figure (4)
    plot(dc_gain,p)

regre = polyfit (dista, prob, 5);

x = 1:length(dc_gain);

for r=1:length(dc_gain);
    x(r) = sqrt(5*R*1e-4/dc_gain(r));
end

pro = regre(1)*x.^5 + regre(2)*x.^4 + regre(3)*x.^3 + regre(4)*x.^2 + regre(5)*x +regre(6)

figure (5)
    plot (dc_gain, pro);

figure ('lele')
    plot (p)