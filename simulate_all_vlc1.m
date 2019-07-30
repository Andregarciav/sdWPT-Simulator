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
for i=1:25
    simulate_script_2nodes_static;
end

lat1 = lat;
bit1 = bit;

% %simulando instância 2
lat = [];
bit = [];

for i=1:25
    simulate_script_2nodes_move;
end

lat2 = lat;
bit2 = bit;


% %Simulando instância 3
lat = [];
bit = [];

for i=1:25
    simulate_script_3nodes_static;
end

lat3 = lat;
bit3 = bit;

% %Simulando instância 4
lat = [];
bit = [];

for i=1:25
    simulate_script_3nodes_move;
end

lat4 = lat;
bit4 = bit;

% %Simulando instância 5

lat = [];
bit = [];

for i=1:25
    simulate_script_3x3;
end

lat5 = lat;
bit5 = bit;

% %Simulando instancia 6

lat = [];
bit = [];
for i=1:25
    simulate_script_3x3_test2;
end

lat6 = lat;
bit6 = bit;

save('simulate1.mat');