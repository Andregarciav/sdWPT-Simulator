prob = ([88.53 80 60 40 20 0]/100);
dista = [0 10 354 425 462 500]/100;
d = 0:0.01:5;
p = interp1 (dista, prob,d, 'pchip');

figure(1)
    hold on
    grid;
    plot(dista,prob, 'o')
    plot(d,p)
    legend('Probability points','Interpolation function')
    xlabel('Distance (m)');
    ylabel('Probability');
    