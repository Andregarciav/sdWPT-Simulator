classdef powerRXApplication_dummieCoils < powerRXApplication
    properties
        interval = 2;
        One_hope = [];
        two_hope = [];
        g = graph
        wantAck = false;
        cont = 0;
        payload = [];
    end
    methods
        function obj = powerRXApplication_dummieCoils(id)
            obj@powerRXApplication(id);%construindo a estrutura referente �superclasse
            obj.g = addnode(obj.g,20);
        end

        function [obj,netManager,WPTManager] = init(obj,netManager,WPTManager)
        	GlobalTime = 0;
        	intervalo = rand;%20+rand*80;%random interval between 20s and 100s
        	netManager = setTimer(obj,netManager,GlobalTime,intervalo);
        end

        function [obj,netManager,WPTManager] = handleMessage(obj,data,GlobalTime,netManager,WPTManager)
            data;
            msgType = str2num(data(1)); %tipo de msg recebida
            msg_len = data(2);
            src = str2num(data(3));
            
            if msgType == 0
                disp('msgType = 0')
                if isempty(obj.One_hope(obj.One_hope == src))
                    obj.One_hope = [obj.One_hope src];
                    disp('Adicionado Objeto One_hope')
                end
                msg_len = length(obj.One_hope);
                obj.payload = ['1',msg_len,string(obj.ID),string(obj.One_hope)];
                obj = setSendOptions(obj, 0, 25000,5);
                netManager = send(obj, netManager, src, obj.payload,length(obj.payload)*32, GlobalTime);
            elseif msgType == 1
                disp('msgType = 1')
                if isempty(obj.One_hope(obj.One_hope == src))
                    obj.One_hope = [obj.One_hope src];
                    disp('Adicionado Objeto One_hope')
                end
                obj.wantAck = false;
                obj.cont = 0;
            end
            disp(['I have ID = ',num2str(obj.ID),' and I detected the device with ID = ',num2str(src)]);
            obj.APPLICATION_LOG.DATA = ['One Hope list = ', string(obj.One_hope),...
                                    'Two Hope list = ', string(obj.two_hope)];%'Exemplo de log';
            
        end

        function [obj,netManager,WPTManager] = handleTimer(obj,GlobalTime,netManager,WPTManager)
            
            if obj.wantAck == false
                obj.payload = ['0','0',string(obj.ID)];
                payloadLen = length(obj.payload)*32;
                %canal 0 de (vlc sobre) swipt, 1000bps, 5W
                obj = setSendOptions(obj, 0, 25000,5);
                netManager = broadcast(obj,netManager,obj.payload,payloadLen,GlobalTime);
                obj.wantAck = true;
                disp(['I have ID = ',num2str(obj.ID),' and I send a broadcast']);
            else
                if obj.cont < 2
                    netManager = broadcast(obj,netManager,obj.payload,length(obj.payload),GlobalTime);
                    obj.cont = obj.cont + 1;
                    disp('Resend msg!')
                else
                    obj.cont = 0;
                    obj.wantAck = false;
                    disp('Msg Drop!!')
                end
            end
           
            netManager = setTimer(obj,netManager,GlobalTime,obj.interval); %realimenta a simulação com novo evento de tempo
            
        end
    end
end
