latInst1 = [];
bitInst1 = [];
latInst2 = [];
bitInst2 = [];
latInst3 = [];
bitInst3 = [];
latInst4 = [];
bitInst4 = [];
latInst5 = [];
bitInst5 = [];
latInst6 = [];
bitInst6 = [];

disp('Opening file 1 of 8 ...')
disp('Loading data from file ...')
load('simulate_scenery1.mat');

latInst1 = [latInst1 lat1];
bitInst1 = [bitInst1 bit1];
latInst2 = [latInst2 lat2];
bitInst2 = [bitInst2 bit2];
latInst3 = [latInst3 lat3];
bitInst3 = [bitInst3 bit3];
latInst4 = [latInst4 lat4];
bitInst4 = [bitInst4 bit4];
latInst5 = [latInst5 lat5];
bitInst5 = [bitInst5 bit5];


disp('Opening file 2 of 8 ...')
disp('Loading data from file ...')
load('simulate_scenery2.mat');

latInst1 = [latInst1 lat1];
bitInst1 = [bitInst1 bit1];
latInst2 = [latInst2 lat2];
bitInst2 = [bitInst2 bit2];
latInst3 = [latInst3 lat3];
bitInst3 = [bitInst3 bit3];
latInst4 = [latInst4 lat4];
bitInst4 = [bitInst4 bit4];
latInst5 = [latInst5 lat5];
bitInst5 = [bitInst5 bit5];


disp('Opening file 3 of 8 ...')
disp('Loading data from file ...')
load('simulate_scenery3.mat');

latInst1 = [latInst1 lat1];
bitInst1 = [bitInst1 bit1];
latInst2 = [latInst2 lat2];
bitInst2 = [bitInst2 bit2];
latInst3 = [latInst3 lat3];
bitInst3 = [bitInst3 bit3];
latInst4 = [latInst4 lat4];
bitInst4 = [bitInst4 bit4];
latInst5 = [latInst5 lat5];
bitInst5 = [bitInst5 bit5];


disp('Opening file 4 of 8 ...')
disp('Loading data from file ...')
load('simulate_scenery4.mat');


latInst1 = [latInst1 lat1];
bitInst1 = [bitInst1 bit1];
latInst2 = [latInst2 lat2];
bitInst2 = [bitInst2 bit2];
latInst3 = [latInst3 lat3];
bitInst3 = [bitInst3 bit3];
latInst4 = [latInst4 lat4];
bitInst4 = [bitInst4 bit4];
latInst5 = [latInst5 lat5];
bitInst5 = [bitInst5 bit5];

disp('Opening file 5 of 8 ...')
disp('Loading data from file ...')
load('simulate_scenery1(4).mat');

latInst6 = [latInst6 lat6];
bitInst6 = [bitInst6 bit6];

disp('Opening file 6 of 8 ...')
disp('Loading data from file ...')
load('simulate_scenery2(4).mat');

latInst6 = [latInst6 lat6];
bitInst6 = [bitInst6 bit6];

disp('Opening file 7 of 8 ...')
disp('Loading data from file ...')
load('simulate_scenery3(4).mat');

latInst6 = [latInst6 lat6];
bitInst6 = [bitInst6 bit6];

disp('Opening file 8 of 8 ...')
disp('Loading data from file ...')
load('simulate_scenery4(4).mat');

latInst6 = [latInst6 lat6];
bitInst6 = [bitInst6 bit6];

disp('All data imported!')
disp('Calculating...')

latencyTotal = [mean(latInst1) ...
                mean(latInst2) ...
                mean(latInst3) ...
                mean(latInst4) ...
                mean(latInst5) ...
                mean(latInst6)];

bitTotal = [mean(bitInst1) ...
            mean(bitInst2) ...
            mean(bitInst3) ...
            mean(bitInst4) ...
            mean(bitInst5) ...
            mean(bitInst6)];

desvioLatency = [std(latInst1) ...
                 std(latInst2) ...
                 std(latInst3) ...
                 std(latInst4) ...
                 std(latInst5) ...
                 std(latInst6)];

desvioBit = [std(bitInst1) ...
             std(bitInst2) ...
             std(bitInst3) ...
             std(bitInst4) ...
             std(bitInst5) ...
             std(bitInst6)];

margemErroLat = [1:6];
margemErroBit = [1:6];

elements = [length(latInst1) length(latInst2) length(latInst3) ...
            length(latInst4) length(latInst5) length(latInst6)];

for i=1:6
    margemErroLat(i) = 1.96*desvioLatency(i)/sqrt(elements(i));
    margemErroBit(i) = 1.96*desvioBit(i)/sqrt(elements(i));
end

intervaloSupLat = margemErroLat;
intervaloinfLat = (-1) * margemErroLat;
intervaloSupBit = margemErroBit;
intervaloinfBit =  (-1) * margemErroBit;

x = [0.1 0.5 1 2 3 4];

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