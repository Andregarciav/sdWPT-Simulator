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
for i=1:100
    simulate_script_2nodes_static;
end
    %Parâmetros de análise
% instancia       = grafoInstancia    (LOG_app_list);
% packetSend      = NumberPacket      (LOG_app_list);
% PacketReceive   = NumberReceive     (LOG_app_list);
% enviados        = [enviados packetSend];
% recebidos       = [recebidos PacketReceive];
latencyTotal    = [latencyTotal mean(lat)];
desvioLatency   = [desvioLatency std(lat)];
bitTotal        = [bitTotal mean(bit)];
desvioBit       = [desvioBit std(bit)];

% figure('Name','Instancy two nodes static')
%     plot(instancia)


% %simulando instância 2
lat = [];
bit = [];

for i=1:100
    simulate_script_2nodes_move;
end
% instancia       = grafoInstancia(LOG_app_list);
% packetSend      = NumberPacket      (LOG_app_list);
% PacketReceive   = NumberReceive     (LOG_app_list);
% enviados        = [enviados packetSend];
% recebidos       = [recebidos PacketReceive];
latencyTotal    = [latencyTotal mean(lat)];
desvioLatency   = [desvioLatency std(lat)];
bitTotal        = [bitTotal mean(bit)];
desvioBit       = [desvioBit std(bit)];

% figure('Name','Instancy two nodes one move')
%     plot(instancia)


% %Simulando instância 3
lat = [];
bit = [];
for i=1:100
    simulate_script_3nodes_static;
end

latencyTotal    = [latencyTotal mean(lat)];
desvioLatency   = [desvioLatency std(lat)];
bitTotal        = [bitTotal mean(bit)];
desvioBit       = [desvioBit std(bit)];

% instancia = grafoInstancia(LOG_app_list);
% packetSend      = NumberPacket      (LOG_app_list);
% PacketReceive   = NumberReceive     (LOG_app_list);
% enviados        = [enviados packetSend];
% recebidos       = [recebidos PacketReceive];
% figure('Name','Instancy three nodes static')
%     plot(instancia)

% latencyTotal    = [latencyTotal mean(lat)];
% desvioLatency   = [desvioLatency std(lat)];
% bitTotal        = [bitTotal mean(bit)];
% desvioBit       = [desvioBit std(bit)];

% %Simulando instância 4
lat = [];
bit = [];
for i=1:100
    simulate_script_3nodes_move;
end

latencyTotal    = [latencyTotal mean(lat)];
desvioLatency   = [desvioLatency std(lat)];
bitTotal        = [bitTotal mean(bit)];
desvioBit       = [desvioBit std(bit)];
% instancia = grafoInstancia(LOG_app_list);
% packetSend      = NumberPacket      (LOG_app_list);
% PacketReceive   = NumberReceive     (LOG_app_list);
% enviados        = [enviados packetSend];
% recebidos       = [recebidos PacketReceive];
% figure('Name','Instancy three nodes one moving')
%     plot(instancia)

% latencyTotal    = [latencyTotal mean(lat)];
% desvioLatency   = [desvioLatency std(lat)];
% bitTotal        = [bitTotal mean(bit)];
% desvioBit       = [desvioBit std(bit)];

% %Simulando instância 5

lat = [];
bit = [];
for i=1:100
    simulate_script_3x3;
end

latencyTotal    = [latencyTotal mean(lat)];
desvioLatency   = [desvioLatency std(lat)];
bitTotal        = [bitTotal mean(bit)];
desvioBit       = [desvioBit std(bit)];

% %Simulando instancia 6

lat = [];
bit = [];
for i=1:100
    simulate_script_3x3_test2;
end

latencyTotal    = [latencyTotal mean(lat)];
desvioLatency   = [desvioLatency std(lat)];
bitTotal        = [bitTotal mean(bit)];
desvioBit       = [desvioBit std(bit)];
% instancia = grafoInstancia(LOG_app_list);
% packetSend      = NumberPacket      (LOG_app_list);
% PacketReceive   = NumberReceive     (LOG_app_list);
% enviados        = [enviados packetSend];
% recebidos       = [recebidos PacketReceive];

% figure('Name','Instancy nine nodes grid')
%     plot(instancia)

% latencyTotal    = [latencyTotal mean(lat)];
% desvioLatency   = [desvioLatency std(lat)];
% bitTotal        = [bitTotal mean(bit)];
% desvioBit       = [desvioBit std(bit)];

% enviadoslaten
% recebidos