%Objeto retornado pela fun��o Simulate e que recolhe informa��es de cada
%dispositivo

classdef simulationResults
    
    properties(SetAccess = private, GetAccess = public)
        running
        device_index %�ndice do dispositivo ao qual pertencem os dados
        BC %corrente bruta (que passa pela bobina)
        CC %corrente de recarga (dc, apenas RX)
        IE %corrente esperada pelo carregador (para uma recarga ideal, apenas RX)
        DC %corrente de descarga consumida pelo dispositivo (apenas RX)
        %(Corrente de transmiss�o no caso do TX)
        VB %tens�o da bateria (apenas RX)
        SOC %state of charge da bateria (apenas RX)
        RL %resist�ncia equivalente do dispositivo (RS no caso do TX)
    end

    methods(Access=public)
        function obj = simulationResults(device_index)
            if (length(device_index)~=1) || (device_index<0)
                error('simulationResults: parameter error');
            end
            %obj.running = true;
            obj.running = false;
            obj.device_index = device_index;

            obj.BC = [];
            obj.CC = zeros(2,0);
            obj.IE = zeros(2,0);
            obj.DC = zeros(2,0);
            obj.VB = zeros(2,0);
            obj.SOC = zeros(2,0);
        end

        function obj = logBCData(obj,BC,time)
            if obj.running
                aux = [BC;time];
                if(isempty(obj.BC))
                    obj.BC = aux;
                else
                    if(time>obj.BC(end,end))
                        %caso esperado
                        obj.BC = [obj.BC,aux];
                    else
                    	if(time<obj.BC(end,end))
		                    %tratamento de excess�o
		                    i = find(obj, obj.BC, time);
		                    %os casos em que l log est� vazio e em que
		                    %a inser��o � no final j� s�o tratados
		                    %individualmente. No caso em que a inser��o
		                    %� no in�cio o tratamento ocorre naturalmente
		                    obj.BC = [obj.BC(:,1:i),aux,obj.BC(:,i+1:end)];
		                else
		                	%se time for repetido, apenas substitua
		                	s = size(obj.BC);
		                	if(s(2)==1)
		                		obj.BC = aux;
		                	else
		                		obj.BC = [obj.BC(:,1:s(2)-1),aux];
		                	end
		                end
                    end
                end
            end
        end

        function obj = logCCData(obj,CC,time)
            if obj.running
                aux = [CC;time];
                obj.CC = [obj.CC aux];
            end
        end

        function obj = logIEData(obj,IE,time)
            if obj.running
                aux = [IE;time];
                obj.IE = [obj.IE aux];
            end
        end

        function obj = logDCData(obj,DC,time)
            if obj.running
                aux = [DC;time];
                obj.DC = [obj.DC aux];
            end
        end

        function obj = logVBData(obj,VB,time)
            if obj.running
                aux = [VB;time];
                obj.VB = [obj.VB aux];
            end
        end

        function obj = logSOCData(obj,SOC,time)
            if obj.running
                aux = [SOC;time];
                obj.SOC = [obj.SOC aux];
            end
        end

        function obj = logRLData(obj,RL,time)
            if obj.running
                aux = [RL;time];
                if(isempty(obj.RL))
                    obj.RL = aux;
                else
                    if(time>=obj.RL(end,end))
                        %caso esperado
                        obj.RL = [obj.RL,aux];
                    else
                        %tratamento de excess�o
                        i = find(obj, obj.RL, time);
                        %os casos em que o log est� vazio e em que a inser��o �
                        %no final j� s�o tratados individualmente. No caso em que
                        %a inser��o � no in�cio o tratamento ocorre naturalmente
                        obj.RL = [obj.RL(:,1:i),aux,obj.RL(:,i+1:end)];
                    end
                end
            end
        end

        function obj = endDataAquisition(obj)
            if length(obj)~=1
                error('endDataAquisition works with objects, not lists');
            end
            obj.running = false;
        end

        function plotBatteryChart(obj)
            if ~obj.running && obj.device_index~=0
                figure;
                hold on;
                yyaxis left
                plot(obj.VB(2,:)/60,obj.VB(1,:));
                ylabel('(V)');
                yyaxis right
                plot(obj.CC(2,:)/60,obj.CC(1,:)*0.52/1.3);
                plot(obj.IE(2,:)/60,obj.IE(1,:));
                plot(obj.DC(2,:)/60,obj.DC(1,:));
                plot(obj.SOC(2,:)/60,obj.SOC(1,:));
                legend('Battery Voltage','Charge Current','Expected Current',...
                'Discharge Current','SOC');
                xlabel('Time (min)')
                ylabel('(A)/(0-1)')
                title(['Battery Chart for device ', num2str(obj.device_index)]);
            end
        end

        function plotBatteryChart2010(obj)
            if ~obj.running && obj.device_index~=0
                figure;
                hold on;
                plot(obj.CC(2,:)/3600,obj.CC(1,:),'r');
                plot(obj.IE(2,:)/3600,obj.IE(1,:),'b');
                plot(obj.DC(2,:)/3600,obj.DC(1,:),'g');
                plot(obj.VB(2,:)/3600,obj.VB(1,:),'m');
                xlabel('Time (h)')
                ylabel('(A) / (V)')
                legend('Charge Current','Expected Current',...
                'Discharge Current','Battery Voltage');
                title(['Battery Chart for device ', num2str(obj.device_index)]);

                figure;
                plot(obj.SOC(2,:)/3600,obj.SOC(1,:)*100);
                xlabel('Time (h)')
                ylabel('(%)')
                title(['SOC Chart for device ', num2str(obj.device_index)]);
            end
        end
		
		function plotRLChart(obj)
            if ~obj.running
				if  obj.device_index~=0 && length(obj.RL)==length(obj.SOC)
					figure;
					plot(obj.SOC(1,:)*100,obj.RL(1,:));
					xlabel('SOC (%)')
					ylabel('Resistance (ohms)')
					title(['Load Resistance Chart for device ', num2str(obj.device_index)]);
				end
				
				figure;
                plot(obj.RL(end,:)/3600,obj.RL(1:end-1,:)');
                xlabel('Time (h)')
                ylabel('Resistance (ohms)')
                title(['Load Resistance Chart for device ', num2str(obj.device_index)]);
            end
        end
        
        function I = getCurrentEstimate(obj,time)
            I = estimate(obj, obj.BC, time);
        end
        
        function r = getRLEstimate(obj,time)
            r = estimate(obj, obj.RL, time);
        end
    end
    
    methods(Access=private)
        %retorna o maior �ndice i de um elemento de um momento menor ou igual a time
        %se n�o existir, o valor 0 � retornado
        function i = find(obj, log, time)
            if(isempty(log))
                %valor default
                i = 0;
            else
                if(time<log(end,1))
                    %o momento foi anterior ao primeiro que se tem registro
                    i = 0;
                else
                    if(time>=log(end,end))
                        %o momento � posterior ao �ltimo que se tem registro
                        s = size(log);
                        i = s(2);
                    else
                        %i0 e i1 delimitam o espa�o de busca (e fazem parte dele inclusive)
                        i0 = 1;
                        s = size(log);
                        i1 = s(2)-1;%i=end j� foi tratado
                        while(true)
                            i = floor((i1+i0)/2);
                            if(time>=log(end,i))
                                if(time<log(end,i+1))
                                    %encontrado o registro mais tardio que precede time
                                    break;
                                else
                                    %o sucessor ainda n�o supera o time. o espa�o de busca agora come�a nele
                                    i0 = i+1;
                                end
                            else
                                %esse registro n�o pode ser um antecessor de time.
                                %o espa�o de busca deve terminar em seu antecessor.
                                i1 = i-1;
                            end
                        end
                    end
                end
            end
        end
        
        %interpola linearmente o valor do momento time com base nos dados de log
        function v = estimate(obj, log, time)
            s = size(log);
            nLines = s(1);
            nCols = s(2);
            if(nCols==0)
                warningMsg('(SimulationResults) estimation may be inaccurate (not enough data)');
                v = 0;
            else
                i = find(obj, log, time);
                if(i==0)
                    %se o momento for anterior ao mais antigo j� registrado
                    if(time<log(end,1))
                        warningMsg('(SimulationResults) estimation may be inaccurate (past)');
                    end
                    v = log(1:nLines-1,1);
                else
                    if(i==nCols)
                        if(time>log(end,end))
                            warningMsg('(SimulationResults) estimation may be inaccurate (future)');
                        end
                        v = log(1:nLines-1,i);
                    else
                        v0 = log(1:nLines-1,i);
                        t0 = log(end,i);
                        
                        v1 = log(1:nLines-1,i+1);
                        t1 = log(end,i+1);
                        
                        if(t1==t0)
                            warningMsg('(SimulationResults) race condition');
                            v = (v0+v1)/2;
                        else
                            lambda = (time-t0)/(t1-t0);
                            v = lambda*v1 + (1-lambda)*v0;
                        end
                    end 
                end
            end
        end
    end
end
