clear all;
clc;

matfiles = dir('/home/andre/Rep/sdWPT-Simulator/SIMULATOR_main/cenario_2/Results/test_3/inst/*.mat');

atraso = [];

for file=1:length(matfiles)
    load(matfiles(file).name);
    atraso = [atraso lat];
end