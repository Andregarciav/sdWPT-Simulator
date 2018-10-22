%version: 2010a ou 2017a
function simulate_MagMIMO(version,envFile)
    %SIMULATION SCRIPT FOR MAGMIMO (SEE DOCS)
    disp('Reminding: Please be sure that the workspace is clean (use clear all)');

    %ASPECTOS GERAIS
    NTX = 6; %number of transmitting coils
    NRX = 1; %number of receiving devices
    W = 2*pi*1e6; %fixed operational frequency
    R = 0.5*ones(NTX+NRX,1);%internal resistance of the RLC rings (obtained via fitting)
    C = -1*ones(NTX+NRX,1);%resonance (because the values of .mat are also -1)
    MAX_ACT_POWER = 20;%W, considering active power
	MAX_APP_POWER = 2000;%W, considering apparent power
    TOTAL_TIME = 10000;%max seconds of simulation (virtual time)

    %BATTERY (iPhone 4s battery. We didn't find some values, so LIR18650 was used
    %as refernce for these)
    fase1Limit = 0.7;          % (70%)
    limitToBegin = 0.93;       % (93%)
    constantCurrent_min = 0.1; % (A)
    constantCurrent_max = 1.2;   % (A)
    constantVoltage = 4.2;     % (V)
    Rc = -1;      % (ohm. -1=calculate automatically)
    Rd = -1;       % (ohm. -1=calculate automatically)
    R_MAX = 1e7;   % (ohm. Used in oder to make matrix inversion easier)
    Q0 = 0;       % initial charge (As)
    Qmax = 5148;  % (As), equivalent to 1430 mAH (iPhone 4s battery)

    bat = linearBattery('Li_Ion_Battery_LIR18650.txt',Rc,Rd,Q0,Qmax,R_MAX,fase1Limit,...
                  constantCurrent_min,constantCurrent_max,constantVoltage,...
                  limitToBegin,false);

    %DEVICE (revisar)
    power_m = 0.5; % (W)
    power_sd = 0.001;
    minV = 2.3;     % (V)
    minVTO = 3.3;   % (V)
    err = 0.05;     % (5%)
    efficiency = 0.95; % (95% de eficiência de conversão AC/DC)

    STEP=0.2;     % (s)

    dev = genericDeviceWithBattery(bat,power_m,power_sd,minV,minVTO,err,efficiency);
    DEVICE_LIST = struct('obj',dev);

    %APPLICATIONS
	referenceVoltage = 5;
	interval1 = 1;
	interval2 = 10;
	interval3 = 10;
    powerTX = powerTXApplication_MagMIMO(referenceVoltage, interval1, interval2, ...
		MAX_ACT_POWER, MAX_APP_POWER);
    powerRX = [];

    for i=1:NRX
        powerRX = [powerRX struct('obj',powerRXApplication_MagMIMO(i,interval3))];
    end

    %SIMULADOR

    IFACTOR=1.5;
    DFACTOR=2;
    INIT_VEL=0.01;
    MAX_ERR = 0.005;

    SHOW_PROGRESS = true;

    B_SWIPT = 0.5;%minimum SINR for the message to be undertood
    B_RF = 0.5;%minimum SINR for the message to be undertood
    A_RF = 2;%expoent for free-space path loss (RF only)
    N_SWIPT = 0.1;%Noise for SWIPT (W)
    N_RF = 0.1;%Noise for RF (W)

    [~,LOG_dev_list,LOG_app_list] = Simulate(envFile,NTX,R,C,W,TOTAL_TIME,MAX_ERR,R_MAX,...
        IFACTOR,DFACTOR,INIT_VEL,MAX_ACT_POWER,MAX_APP_POWER,DEVICE_LIST,STEP,SHOW_PROGRESS,...
		powerTX,powerRX,B_SWIPT,B_RF,A_RF,N_SWIPT,N_RF);

    %VISUALIZATION
        
    for i=1:length(LOG_dev_list)
        LOG = endDataAquisition(LOG_dev_list(i));
        if(strcmp(version, '2010a'))
            plotBatteryChart2010(LOG);
        else
            plotBatteryChart(LOG);
        end
		plotRLChart(LOG);
    end
end
