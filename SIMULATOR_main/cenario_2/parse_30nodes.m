latInst1 = [];
bitInst1 = [];

disp('Opening file 1 of 4 ...')
disp('Loading data from file ...')
load('simulate_40_1.mat');

latInst1 = [latInst1 lat1];
bitInst1 = [bitInst1 bit1];



disp('Opening file 2 of 4 ...')
disp('Loading data from file ...')
load('simulate_40_2.mat');

latInst1 = [latInst1 lat1];
bitInst1 = [bitInst1 bit1];


disp('Opening file 3 of 4 ...')
disp('Loading data from file ...')
load('simulate_40_3.mat');

latInst1 = [latInst1 lat1];
bitInst1 = [bitInst1 bit1];


disp('Opening file 4 of 4 ...')
disp('Loading data from file ...')
load('simulate_40_4.mat');


latInst1 = [latInst1 lat1];
bitInst1 = [bitInst1 bit1];


disp('All data imported!')
disp('Calculating...')

latencyTotal = [mean(latInst1)];

bitTotal = [mean(bitInst1)];

desvioLatency = [std(latInst1)];

desvioBit = [std(bitInst1)];

margemErroLat = [];
margemErroBit = [];

elements = [length(latInst1)];

for i=1:1
    margemErroLat(i) = 1.96*desvioLatency(i)/sqrt(elements(i));
    margemErroBit(i) = 1.96*desvioBit(i)/sqrt(elements(i));
end

intervaloSupLat = margemErroLat;
intervaloinfLat = (-1) * margemErroLat;
intervaloSupBit = margemErroBit;
intervaloinfBit =  (-1) * margemErroBit;

x = [30];

figure(1)
    hold on
        title('Latency X Distance')
        grid
        plot(x,latencyTotal)
        errorbar(x,latencyTotal,intervaloinfLat,intervaloSupLat,'s', 'MarkerEdgeColor','red','MarkerFaceColor','red');
        xlabel('Distance (m)');
        ylabel('Latency (ms)');
    hold off

figure(2)
    hold on
        title('Bit Rate X Distance')
        plot(x,bitTotal)
        grid
        errorbar(x,bitTotal,intervaloinfBit,intervaloSupBit,'s', 'MarkerEdgeColor','red','MarkerFaceColor','red');
        xlabel('Distance (m)');
        ylabel('Bit Rate (KBps)');
    hold off