%This algorithm is centralized to the transmitting part and is constituted by two stages.
%The first one is responsible for obtaining the magnectic channel between the receiver and
%each transmitting coil. The second one, in turn, calculates the beamforming currents and 
%charges the receiver in fact.

classdef powerTXApplication_MagMIMO < powerTXApplication
    properties
		interval1 %time interval used to measure the channel for one coil (stage 1)
		interval2 %time that a beamform value is assumed to keep valid (stage 2)
		
		rV %reference voltage, used for channel estimation
		
		m %vector used for the estimation of each magnetic channel
		
		%coil which channel will be individually measured
		%(stage 1->target=1..nt,stage2->target=nt+1)
		target
		
		RL %load resistance, got from messages form the power receiver
		
		ZT %impedance sub-matrix for the transmitting elements
		
		P_active %maximum active power to be spent
		P_apparent %maximum apparent power (limits the maximum current)
    end
    methods
        function obj = powerTXApplication_MagMIMO(referenceVoltage, interval1, interval2, P_active, P_apparent)
            obj@powerTXApplication();%construindo a estrutura referente � superclasse
			obj.interval1 = interval1;
			obj.interval2 = interval2;
			obj.rV = referenceVoltage;
			obj.RL = 0;%dummie
			obj.m = [];%magnetic channel
			obj.ZT = [];
			obj.P_active = P_active;
			obj.P_apparent = P_apparent;
        end

        function [obj,netManager,WPTManager] = init(obj,netManager,WPTManager)
			%SWIPT configurations, 300bps (fig 8 of the paper), 5W (dummie)
            obj = setSendOptions(obj,0,2048,5);
			%getting the ZT sub-matrix (for a real life implementation, these values have to be
			%pre-parametrized)
			Z = getCompleteLastZMatrix(WPTManager);
			obj.ZT = Z(1:WPTManager.nt,1:WPTManager.nt);
			%setting a dummie first magnetic channel vector
			obj.m = zeros(WPTManager.nt,1);
        	%appy the reference voltage for the next measurements
			WPTManager = setSourceVoltages(obj,WPTManager,[obj.rV;zeros(WPTManager.nt-1,1)],0);
			%keep the voltage to measure the results next round
			netManager = setTimer(obj,netManager,0,obj.interval1);
			target = 2;
        end

        function [obj,netManager,WPTManager] = handleMessage(obj,data,GlobalTime,netManager,WPTManager)
			%the resistance of the load is sent by the power receiver periodically
			obj.RL = data;
        end

        function [obj,netManager,WPTManager] = handleTimer(obj,GlobalTime,netManager,WPTManager)
			if obj.RL>0
				%measure current for target-1
				if obj.target>1
					[It,WPTManager] = getCurrents(obj,WPTManager,GlobalTime);
					Isi = It(obj.target-1);
					%equation of the paper
					signal = -1;%CUIDADO!!!!!!!!!!!!!!!!!!!
					%equation 12 of the paper
					obj.m = (1i)*signal*sqrt((obj.rV/Isi-obj.Rt)/obj.RL);
				end
				%set voltage for the measurement of target
				if target==WPTManager.nt+1
					%no more target, next is simply stage 2
					%calculate the optimum values
					I = calculateBeamformingCurrents(obj);
					V = voltagesFromCurrents(obj,I);
					%appy the calculated voltages
					WPTManager = setSourceVoltages(obj,WPTManager,V,GlobalTime);
					%keep the calculated voltage to charge the device
					netManager = setTimer(obj,netManager,GlobalTime,obj.interval2);
					%next stage will be 1 again
					target = 1;
				else
					%appy the reference voltage for the next measurements
					WPTManager = setSourceVoltages(obj,WPTManager,[zeros(target-1,1);obj.rV;zeros(WPTManager.nt-target,1)],GlobalTime);
					%keep the voltage to measure the results next round
					netManager = setTimer(obj,netManager,GlobalTime,obj.interval1);
					target = target + 1;
				end
			else
				warningMsg('Inconsistant data about the load resistance. Nothing to be done.');
			end
        end
		
		%utils---------------------------------------
		function I = calculateBeamformingCurrents(obj)
			%equation 8 of the paper
			beta = obj.m'./sum(abs(obj.m).^2);
			%obtaining complete Z matriz (assuming that the inner impedance of the receiver is purely resistive (resonance state)
			Z = [ZT				obj.m*obj.RL;
				obj.m.'*obj.RL	obj.RL];
			%limiting the active power spent
			k1 = sqrt(obj.P_active/real(beta'*Z'*beta));
			%limiting the applarent power
			k2 = sqrt(obj.P_apparent/abs(beta'*Z'*beta));
			%using the most limiting constant
			if k1<k2
				I = k1*beta;
			else
				I = k2*beta;
			end
		end
		
		function V = voltagesFromCurrents(obj,I)
			%equation 13 of the paper
			V = [ZT, obj.m*obj.RL]*I;
		end
    end
end