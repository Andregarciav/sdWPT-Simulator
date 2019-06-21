%This script is a simple demonstration of the network aspects of the simulator

% clear all;

noWarnings();%comente se quiser warnings

%MANTENHA ISSO ATUALIZADO!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
NRX = 33; %n�mero de dispositivos transmissores
TOTAL_TIME = 60;%segundos de simula��o (em tempo virtual)

%ASPECTOS GERAIS (DUMMIE)-------------------------------------------------------
W = 1e6;
R = 0.5*ones(1+NRX,1);%resist�ncia dos RLCs
C = -1*ones(1+NRX,1);%capacit�ncia dos RLCs (usar a do arquivo .mat)
MAX_ACT_POWER = 200;%W
MAX_APP_POWER = 200;%W

%BATERIA
fase1Limit = 0.7;          % (70%)
limitToBegin = 0.93;       % (93%)
constantCurrent_min = 0.5; % (A)
constantCurrent_max = 3.4;   % (A)
constantVoltage = 4.2;     % (V)
Rc = -1;      % (ohm. -1=calcular automaticamente)
Rd = -1;       % (ohm. -1=calcular automaticamente)
R_MAX = 1e7;   % (ohm)
Q0 = 0;       % (As)
Qmax = 4320;  % (As), que equivale a 1200 mAh

bat = linearBattery('test_data.txt',Rc,Rd,Q0,Qmax,R_MAX,fase1Limit,...
              constantCurrent_min,constantCurrent_max,constantVoltage,...
              limitToBegin,false);

power_m = 0.5; % (W)
power_sd = 0;
minV = 2.3;     % (V)
minVTO = 3.3;   % (V)
err = 0.05;     % (5%)
efficiency = 0.95; % (95% de efici�ncia de convers�o AC/DC)
%--------------------------------------------------------------------------------

STEP=0.2;     % (s)
interval = 2; % intervalo entre chamadas de atividade

dev = genericDeviceWithBattery(bat,power_m,power_sd,minV,minVTO,err,efficiency);
DEVICE_LIST = [];
for i=1:NRX
	DEVICE_LIST = [DEVICE_LIST,struct('obj',dev)];
end
%
powerTX = powerTXApplication_dummieCoils();
powerRX = [];

for i=1:NRX
    powerRX = [powerRX struct('obj',powerRXApplication_dummieCoils(i, interval))];
end

%SIMULADOR (DUMMIE)----------------------------------------------------
IFACTOR=1.5;
DFACTOR=2;
INIT_VEL=0.01;
MAX_ERR = 0.005;
%-----------------------------------------------------------------------

SHOW_PROGRESS = true;

B_SWIPT = 0.5;%minimum SINR for the message to be undertood
B_RF = 0.5;%minimum SINR for the message to be undertood
A_RF = 2;%expoent for free-space path loss (RF only)
N_SWIPT = 0.1;%Noise for SWIPT (W)
N_RF = 0.1;%Noise for RF (W)

[~,LOG_dev_list,LOG_app_list] = Simulate('DUMMIE_COIL_ENV.mat',1,R,C,W,TOTAL_TIME,MAX_ERR,R_MAX,...
    IFACTOR,DFACTOR,INIT_VEL,MAX_ACT_POWER,MAX_APP_POWER,DEVICE_LIST,STEP,SHOW_PROGRESS,...
	powerTX,powerRX,B_SWIPT,B_RF,A_RF,N_SWIPT,N_RF);

%LOG

for i=2:length(LOG_app_list)
    %v = neighbors(LOG_app_list(i).DATA.g,string(i-1));
    disp(' ');
    disp(['For RX ',num2str(i-1),':']);
    disp('--------------------------------------');
    %disp(LOG_app_list(i).DATA);
    % figure(i-1)
    %     p = plot(LOG_app_list(i).DATA.g);
    %     highlight(p,string(i-1),'NodeColor', [0 0.75 0]);
    %     %highlight(p,v,'NodeColor', 'red');
    %     highlight(p,string(i-1),neighbors(LOG_app_list(i).DATA.g,string(i-1)),'EdgeColor', 'red');
    %     highlight(p,string(LOG_app_list(i).DATA.lmpr),'NodeColor', 'red');


      
end