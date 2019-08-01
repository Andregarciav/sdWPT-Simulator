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

%simulando instância 1
for i=1:20
    simulate_script_40rand_static;
end

lat1 = lat;
bit1 = bit;

save('simulate_40_5.mat');