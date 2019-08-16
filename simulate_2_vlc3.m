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

lat1 = [];
bit1 = [];
lat2 = [];
bit2 = [];
lat3 = [];
bit3 = [];
lat4 = [];
bit4 = [];
lat5 = [];
bit5 = [];
lat6 = [];
bit6 = [];

%simulando instância 1
for itera=1:25
    simulate_script_2nodes_10;
    save(['simulate_2nodes10_3_',num2str(itera),'.mat']);
end

lat1 = lat;
bit1 = bit;

% %simulando instância 2
lat = [];
bit = [];

for itera=1:25
    simulate_script_2nodes_50;
    save(['simulate_2nodes50_3_',num2str(itera),'.mat']);
end

lat2 = lat;
bit2 = bit;


% %Simulando instância 3
lat = [];
bit = [];

for itera=1:25
    simulate_script_2nodes_100;
    save(['simulate_2nodes100_3_',num2str(itera),'.mat']);
end

lat3 = lat;
bit3 = bit;

% %Simulando instância 4
lat = [];
bit = [];

for itera=1:25
    simulate_script_2nodes_200;
    save(['simulate_2nodes200_3_',num2str(itera),'.mat']);
end

lat4 = lat;
bit4 = bit;

% %Simulando instância 5

lat = [];
bit = [];

for itera=1:25
    simulate_script_2nodes_300;
    save(['simulate_2nodes300_3_',num2str(itera),'.mat']);
end

lat5 = lat;
bit5 = bit;


% %Simulando instância 6

lat = [];
bit = [];

for itera=1:25
    simulate_script_2nodes_400;
    save(['simulate_2nodes400_3_',num2str(itera),'.mat']);
end

lat5 = lat;
bit5 = bit;

save('simulate_scenery3.mat');