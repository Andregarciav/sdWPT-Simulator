%baseado no modelo apresentado em "Analysis and parameters optimization of 
%a contactless IPT system for EV charger" de Chen et al.

classdef genericDeviceWithBattery < Device
    properties(SetAccess = private, GetAccess = public)
        power_m %m�dia de pot�ncia consumida (W)
        power_sd %desvio padr�o da pot�ncia consumida
        minV %tens�o m�nima necess�ria para o dispositivo operar
        minVTO %tens�o m�nima necess�ria para o dispositivo ligar
        err %erro percentual admitiss�vel para os c�lculos (entre 0 e 1)
    end

    methods
        function obj = genericDeviceWithBattery(battery, power_m, power_sd,...
        minV, minVTO, err, efficiency)
	        obj@Device(false,battery.constantCurrent_max,efficiency);%se inicia desligado
            obj.bat = battery;
            obj.power_m = power_m;
            obj.power_sd = power_sd;
            obj.minV = minV;
            obj.minVTO = minVTO;
            obj.err = err;

            obj.chargeCurrent = 0;
            obj.dischargeCurrent = 0;
            obj.Vbatt = getVBatt(obj.bat,0);

            if ~check(obj)
                error('genericDeviceWithBattery: parameter error');
            end
        end

        %verifica se os par�metros est�o em ordem
        function r=check(obj)
            r=(obj.power_m>=0)&&(obj.power_sd>=0)&&(obj.minV>=0)&&...
                (obj.minVTO>=obj.minV)&&(obj.err>0)&&(obj.err<1)&&check(obj.bat)&&...
                (obj.efficiency>=0)&&(obj.efficiency<=1);
        end

        %retorna a corrente esperada de acordo com o procedimento de
        %carregamento da bateria
        function [obj,Ie] = expectedCurrent(obj)
            [obj.bat,Ie] = expectedCurrent(obj.bat);
			Ie = Ie/obj.efficiency;
        end
        
        %rerturns the static value for the actual load resistance.
        %if -1, calculateRL will estimate it.
        function RL = getRL(obj)
        	RL = getRL(obj.bat);
        end

        %-avgChargeCurrent_ac (A, phasor): m�dia da corrente de entrada no intervalo de tempo
        %-timeVariation (s): intervalo de tempo
        function [obj,DEVICE_DATA] = updateDeviceState(obj, avgChargeCurrent_ac, timeVariation, DEVICE_DATA, time)
            
            %converte a corrente para DC
            avgChargeCurrent_dc = obj.efficiency * abs(avgChargeCurrent_ac);
            
            %limita a corrente para n�o danificar a bateria
            if(avgChargeCurrent_dc>obj.bat.constantCurrent_max)
                avgChargeCurrent_dc = obj.bat.constantCurrent_max;
                warningMsg('Very high current');
            end
            
            %gera uma pot�ncia dentro da distribui��o especificada
            if(obj.power_sd>0)
            	P = normrnd(obj.power_m,obj.power_sd);
            else
            	%if you don't want to intall statistics package, set power_ds=0
            	P = obj.power_m;
            end

            V=0;
            if obj.working %de o dispositivo est� ligado
                V = getVBattWithDischarge(obj.bat,avgChargeCurrent_dc,P,obj.err);
                if(V>=obj.minV)
                    discharge_current = P/V;%pot�ncia/tens�o=corrente
                else
                discharge_current = 0;
                obj.working = false;%se a tens�o estiver baixa, desligue
                end
            else
                V = getVBatt(obj.bat,avgChargeCurrent_dc);
                if(V>=obj.minVTO)%verifica se � poss�vel ligar
                    V = getVBattWithDischarge(obj.bat,avgChargeCurrent_dc,P,obj.err);
                    if(V>=obj.minV)%verifica se ainda � poss�vel ficar ligado
                        discharge_current = P/V;%pot�ncia/tens�o=corrente
                        obj.working = true;%se a tens�o estiver boa, ligue
                    else %o dispositivo n�o consegue se manter ligado com a configura��o atual
                        discharge_current = 0;
                        warningMsg('mintVTO is very small compared to minV');
                    end
                else
                    discharge_current = 0;
                end
            end
            [obj.bat,DEVICE_DATA] = updateCharge(obj.bat,avgChargeCurrent_dc,discharge_current,timeVariation,DEVICE_DATA,time);
            %Log--------------------------------------
            DEVICE_DATA = logCCData(DEVICE_DATA,avgChargeCurrent_dc,time);
            DEVICE_DATA = logDCData(DEVICE_DATA,discharge_current,time);
            DEVICE_DATA = logVBData(DEVICE_DATA,V,time);
            %Log--------------------------------------
            obj.chargeCurrent = avgChargeCurrent_dc;
            obj.dischargeCurrent = discharge_current;
            obj.Vbatt = V;
        end
    end
end
