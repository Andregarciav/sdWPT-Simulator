clear all;
clc;

recebidos       =   [];
enviados        =   [];
latencyTotal    =   [];
bitTotal        =   [];
desvioLatency   =   [];
desvioBit       =   [];

%simulando instância 1
simulate_script_2nodes_static;

    %Parâmetros de análise
instancia       = grafoInstancia    (LOG_app_list);
packetSend      = NumberPacket      (LOG_app_list);
PacketReceive   = NumberReceive     (LOG_app_list);
enviados        = [enviados packetSend];
recebidos       = [recebidos PacketReceive];
latencyTotal    = [latencyTotal mean(lat)];
desvioLatency   = [desvioLatency std(lat)];
bitTotal        = [bitTotal mean(bit)];
desvioBit       = [desvioBit std(bit)];

figure('Name','Instancy two nodes static')
    plot(instancia)


%simulando instância 2
simulate_script_2nodes_move;

instancia       = grafoInstancia(LOG_app_list);
packetSend      = NumberPacket      (LOG_app_list);
PacketReceive   = NumberReceive     (LOG_app_list);
enviados        = [enviados packetSend];
recebidos       = [recebidos PacketReceive];
latencyTotal    = [latencyTotal mean(lat)];
desvioLatency   = [desvioLatency std(lat)];
bitTotal        = [bitTotal mean(bit)];
desvioBit       = [desvioBit std(bit)];

figure('Name','Instancy two nodes one move')
    plot(instancia)


%Simulando instância 3
simulate_script_3nodes_static;

instancia = grafoInstancia(LOG_app_list);
packetSend      = NumberPacket      (LOG_app_list);
PacketReceive   = NumberReceive     (LOG_app_list);
enviados        = [enviados packetSend];
recebidos       = [recebidos PacketReceive];
figure('Name','Instancy three nodes static')
    plot(instancia)

latencyTotal    = [latencyTotal mean(lat)];
desvioLatency   = [desvioLatency std(lat)];
bitTotal        = [bitTotal mean(bit)];
desvioBit       = [desvioBit std(bit)];

%Simulando instância 4
simulate_script_3nodes_move;

instancia = grafoInstancia(LOG_app_list);
packetSend      = NumberPacket      (LOG_app_list);
PacketReceive   = NumberReceive     (LOG_app_list);
enviados        = [enviados packetSend];
recebidos       = [recebidos PacketReceive];
figure('Name','Instancy three nodes one moving')
    plot(instancia)

latencyTotal    = [latencyTotal mean(lat)];
desvioLatency   = [desvioLatency std(lat)];
bitTotal        = [bitTotal mean(bit)];
desvioBit       = [desvioBit std(bit)];

%Simulando instância 5
simulate_script_3x3;

instancia = grafoInstancia(LOG_app_list);
packetSend      = NumberPacket      (LOG_app_list);
PacketReceive   = NumberReceive     (LOG_app_list);
enviados        = [enviados packetSend];
recebidos       = [recebidos PacketReceive];

figure('Name','Instancy nine nodes grid')
    plot(instancia)

latencyTotal    = [latencyTotal mean(lat)];
desvioLatency   = [desvioLatency std(lat)];
bitTotal        = [bitTotal mean(bit)];
desvioBit       = [desvioBit std(bit)];

enviados
recebidos