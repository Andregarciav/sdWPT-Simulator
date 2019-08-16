clear all;
clc;

matfiles_10 = dir('/home/andre/Rep/sdWPT-Simulator/SIMULATOR_main/cenario_1/Results_separed_instancies/simulate_2nodes10_*.mat');
matfiles_50 = dir('/home/andre/Rep/sdWPT-Simulator/SIMULATOR_main/cenario_1/Results_separed_instancies/simulate_2nodes50_*.mat');
matfiles_100 = dir('/home/andre/Rep/sdWPT-Simulator/SIMULATOR_main/cenario_1/Results_separed_instancies/simulate_2nodes100_*.mat');
matfiles_200 = dir('/home/andre/Rep/sdWPT-Simulator/SIMULATOR_main/cenario_1/Results_separed_instancies/simulate_2nodes200_*.mat');
matfiles_300 = dir('/home/andre/Rep/sdWPT-Simulator/SIMULATOR_main/cenario_1/Results_separed_instancies/simulate_2nodes300_*.mat');
matfiles_400 = dir('/home/andre/Rep/sdWPT-Simulator/SIMULATOR_main/cenario_1/Results_separed_instancies/simulate_2nodes400_*.mat');



atraso10 = [];
atraso50 = [];
atraso100 = [];
atraso200 = [];
atraso300 = [];
atraso400 = [];

for file=1:length(matfiles_10)
    load(matfiles_10(file).name);
    atraso10 = [atraso10 lat];
    load(matfiles_50(file).name);
    atraso50 = [atraso50 lat];
    load(matfiles_100(file).name);
    atraso100 = [atraso100 lat];
    load(matfiles_200(file).name);
    atraso200 = [atraso200 lat];
    load(matfiles_300(file).name);
    atraso300 = [atraso300 lat];
    load(matfiles_400(file).name);
    atraso400 = [atraso400 lat];
end

latencyMean = [mean(atraso10) mean(atraso50) mean(atraso100) mean(atraso200) mean(atraso300) mean(atraso400)];
latencyDesvio = [std(atraso10) std(atraso50) std(atraso100) std(atraso200) std(atraso300) std(atraso400)];

margemErro = [1:6];

margemErro(1) = 1.96*latencyDesvio(1)/sqrt(length(atraso10));
margemErro(2) = 1.96*latencyDesvio(2)/sqrt(length(atraso50));
margemErro(3) = 1.96*latencyDesvio(3)/sqrt(length(atraso100));
margemErro(4) = 1.96*latencyDesvio(4)/sqrt(length(atraso200));
margemErro(5) = 1.96*latencyDesvio(5)/sqrt(length(atraso300));
margemErro(6) = 1.96*latencyDesvio(6)/sqrt(length(atraso400));

intervalosup = ones(1,6);
intervaloinf = ones(1,6);
for j=1:6
    intervalosup(j) = latencyMean(j) + margemErro(j);
    intervaloinf(j) = latencyMean(j) - margemErro(j);
end


x = [0.1 0.5 1 2 3 4];

y = latencyMean;

neg = intervaloinf;
pos = intervalosup;
yneg = y - neg;
ypos = pos - y;


figure(1)
    hold on
    grid
    bar(x,latencyMean);
    errorbar(x, latencyMean, yneg, ypos, '-s', 'MarkerEdgeColor','red','MarkerFaceColor','red');
    xlabel('Nodes distance (m)');
    ylabel('Latency (ms)');
    hold off