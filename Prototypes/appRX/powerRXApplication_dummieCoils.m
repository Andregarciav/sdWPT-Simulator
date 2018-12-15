classdef powerRXApplication_dummieCoils < powerRXApplication
    properties
        interval
        One_hope = [];
        two_hope = [];
        g = graph
    end
    methods
        function obj = powerRXApplication_dummieCoils(id)
            obj@powerRXApplication(id);%construindo a estrutura referente �superclasse
            obj.g = addnode(obj.g,20);
        end

        function [obj,netManager,WPTManager] = init(obj,netManager,WPTManager)
        	GlobalTime = 0;
        	obj.interval = 20+rand*80;%random interval between 20s and 100s
        	netManager = setTimer(obj,netManager,GlobalTime,obj.interval);
        end

        function [obj,netManager,WPTManager] = handleMessage(obj,data,GlobalTime,netManager,WPTManager)
            src = data(1);%remetente
           % disp(['I have ID = ',num2str(obj.ID),' and I detected the device with ID = ',num2str(src)]);
            %data
            if (length(data) == 1)
                if isempty(obj.One_hope(obj.One_hope==src))
                    obj.One_hope = [obj.One_hope src];
                    v = neighbors(obj.g, obj.ID);
                    for r=1:length(obj.One_hope)
                        if(isempty(v(v==obj.One_hope(r))))
                            obj.g = addedge(obj.g, obj.ID, obj.One_hope(r));
                        end
                    end
                    
                    obj.APPLICATION_LOG.DATA = ['One Hope list = ', string(obj.One_hope),...
                                                'Two Hope list = ', string(obj.two_hope)];%'Exemplo de log';
                end
                payload = [obj.ID,string(obj.One_hope)];
                netManager = send(obj, netManager, src, payload,length(payload)*32, GlobalTime);
            else
                for r = 2:length(data)
                    temp = str2num(data(r));
                    if isempty(obj.two_hope(obj.two_hope==temp))
                        obj.two_hope = [obj.two_hope temp];
                    end
                end
                v = neighbors(obj.g, str2num(src));
                for r=1:length(obj.two_hope)
                    if(isempty(v(v==obj.two_hope(r))))    
                        obj.g = addedge(obj.g, str2num(src), obj.two_hope(r));
                    end
                end
                figure(obj.ID);
                    plot (obj.g);
                
            end
        end

        function [obj,netManager,WPTManager] = handleTimer(obj,GlobalTime,netManager,WPTManager)
            payload = obj.ID;
            payloadLen = 32;%bits
            %canal 0 de (vlc sobre) swipt, 1000bps, 5W
            obj = setSendOptions(obj,0,1000,5);
            netManager = broadcast(obj,netManager,payload,payloadLen,GlobalTime);%faz um broadcast com seu id (0, 32 bits)
            %disp(['I have ID = ',num2str(obj.ID),' and I send a broadcast']);
            netManager = setTimer(obj,netManager,GlobalTime,obj.interval);
            disp(['(Simulation progress: ',num2str((GlobalTime*100)/(6000)),'% of virtual time)']);
				disp(['Expected finishing time: ',num2str(6000/(3600)),'h']);
        end
    end
end
