classdef powerRXApplicatio_VLC < powerRXApplication
    properties
        interval
        One_hope = [];
        two_hope = [];
        g = graph
        seqNumber
    end
    methods
        function obj = powerRXApplicatio_VLC(id)
            obj@powerRXApplication(id);%construindo a estrutura referente �superclasse
            %obj.g = addnode(obj.g,20);
            obj.seqNumber = dec2hex(randi(1000))
        end

        function [obj,netManager,WPTManager] = init(obj,netManager,WPTManager)
        	GlobalTime = 0;
        	obj.interval = 20+rand*80;%random interval between 20s and 100s
            netManager = setTimer(obj,netManager,GlobalTime,obj.interval);
        end

        function [obj,netManager,WPTManager] = handleMessage(obj,data,GlobalTime,netManager,WPTManager)
            data
            src = data(1);%remetente
            disp(['I have ID = ',num2str(obj.ID),' and I detected the device with ID = ',num2str(src)]);
            %data
            
        end

        function [obj,netManager,WPTManager] = handleTimer(obj,GlobalTime,netManager,WPTManager)
            %payload = obj.ID;
            %payloadLen = 32;%bits
            %canal 0 de (vlc sobre) swipt, 1000bps, 5W
            %obj = setSendOptions(obj,0,1000,5);
            %netManager = broadcast(obj,netManager,payload,payloadLen,GlobalTime);%faz um broadcast com seu id (0, 32 bits)
            %disp(['I have ID = ',num2str(obj.ID),' and I send a broadcast']);
            %netManager = setTimer(obj,netManager,GlobalTime,obj.interval);
            %disp(['(Simulation progress: ',num2str((GlobalTime*100)/(6000)),'% of virtual time)']);
            %	disp(['Expected finishing time: ',num2str(6000/(3600)),'h']);
            payload = creatPacket(obj,00,data,GlobalTime,dst);
            payloadLen = length(payload);
            obj = setSendOptions(obj, 0, 25000,5);
            netManager = broadcast(obj,netManager,payload,payloadLen,GlobalTime);
            disp(['I have ID = ',num2str(obj.ID),' and I send a broadcast']);
        end

    end
    
    methods(Access=protected)
    
        function packet = creatPacket(obj,msgType,data,GlobalTime,dst)
            if msgType == 00 %significa hello
                msg_len = 00
                if isempty(obj.One_hope)
                    payload = [num2str(msgType),num2str(msg_len),obj.ID]
                else
                    payload = [num2str(msgType),num2str(msg_len),obj.ID,string(obj.One_hope)]
                end
            end
        end

        function header = headerConstruct(obj)
            
        end
    
    end
end
