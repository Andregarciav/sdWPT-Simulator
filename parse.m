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
disp('Opening file 1 of 4 ...')
disp('Loading data from file ...')
load('simulate1.mat');

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
latInst6 = [latInst6 lat6];
bitInst6 = [bitInst6 bit6];

disp('Opening file 2 of 4 ...')
disp('Loading data from file ...')
load('simulate2.mat');

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
latInst6 = [latInst6 lat6];
bitInst6 = [bitInst6 bit6];

disp('Opening file 3 of 4 ...')
disp('Loading data from file ...')
load('simulate3.mat');

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
latInst6 = [latInst6 lat6];
bitInst6 = [bitInst6 bit6];

disp('Opening file 4 of 4 ...')
disp('Loading data from file ...')
load('simulate4.mat');
disp('All data imported!')
disp('Calculating...')

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
latInst6 = [latInst6 lat6];
bitInst6 = [bitInst6 bit6];

latencyTotal = [mean(latInst1) ...
                mean(latInst2) ...
                mean(latInst3) ...
                mean(latInst4) ...
                mean(latInst5)];

bitTotal = [mean(bitInst1) ...
            mean(bitInst2) ...
            mean(bitInst3) ...
            mean(bitInst4) ...
            mean(bitInst5)];

desvioLatency = [std(latInst1) ...
                 std(latInst2) ...
                 std(latInst3) ...
                 std(latInst4) ...
                 std(latInst5)];

desvioBit = [std(bitInst1) ...
             std(bitInst2) ...
             std(bitInst3) ...
             std(bitInst4) ...
             std(bitInst5)];

margemErroLat = [1:5];
margemErroBit = [1:5];

for i=1:5
    margemErroLat(i) = 1.96*desvioLatency(i)/sqrt(100);
    margemErroBit(i) = 1.96*desvioBit(i)/sqrt(100);
end

intervaloSupLat = margemErroLat;
intervaloinfLat = (-1) * margemErroLat;
intervaloSupBit = margemErroBit;
intervaloinfBit =  (-1) * margemErroBit;

x = 1:5;

figure(1)
    hold on
        title('Latêncy')
        bar(latencyTotal)
        errorbar(x,latencyTotal,intervaloinfLat,intervaloSupLat,'s', 'MarkerEdgeColor','red','MarkerFaceColor','red');
        xlabel('Instancy');
        ylabel('Latency (ms)');
    hold off

figure(2)
    hold on
        title('Bit Rate')
        bar(bitTotal)
        errorbar(x,bitTotal,intervaloinfBit,intervaloSupBit,'s', 'MarkerEdgeColor','red','MarkerFaceColor','red');
        xlabel('Instancy');
        ylabel('Bit Rate (KBps)');
    hold off