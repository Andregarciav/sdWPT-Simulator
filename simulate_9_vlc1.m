clear all;
clc;

recebidos       =   [];
enviados        =   [];
latencyTotal    =   [];
bitTotal        =   [];
desvioLatency   =   [];
desvioBit       =   [];
lat = [];
bit = [];



%simulando instância 1
for inst=1:25
    simulate_script_3x3;
    save(['simulate_3x3_1,5_1_',num2str(inst),'.mat']);
end

save('simulate_9_scenery1.mat');