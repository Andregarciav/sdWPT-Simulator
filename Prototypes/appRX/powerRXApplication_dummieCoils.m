classdef powerRXApplication_dummieCoils < powerRXApplication
    properties
        interval = 2;
        mpr_ant = [];
        %two_hope = [];
        g = graph
        wantAck = false;
        cont = 0;
        payload = [];
        listControl = 4;
        lmpr = [];
    end
    methods
        function obj = powerRXApplication_dummieCoils(id)
            obj@powerRXApplication(id);%construindo a estrutura referente �superclasse
            obj.g = addnode(obj.g,string(obj.ID));
        end

        function [obj,netManager,WPTManager] = init(obj,netManager,WPTManager)
        	GlobalTime = 0;
        	intervalo = rand;%20+rand*80;%random interval between 20s and 100s
        	netManager = setTimer(obj,netManager,GlobalTime,intervalo);
        end

        function [obj,netManager,WPTManager] = handleMessage(obj,data,GlobalTime,netManager,WPTManager)
            data;
            msgType = str2num(data(1)); %tipo de msg recebida
            msg_len = str2num(data(2));
            src = str2num(data(3));
            
            if msgType == 0
                
                v = neighbors(obj.g, string(obj.ID));
                if isempty(v)
                    obj.g = addnode(obj.g, string(src));
                    obj.g = addedge(obj.g, string(obj.ID), string(src));
                end
                
                if (findnode(obj.g, string(src))==0)
                    obj.g = addnode(obj.g, string(src));
                    obj.g = addedge(obj.g, string(obj.ID), string(src));
                end
                
                if length(data) > 3
                    for r = 4:(length(data))
                        temp = str2num(data(r));
                        if (findnode(obj.g, string(temp))==0)
                            obj.g = addnode(obj.g, string(temp));
                            obj.g = addedge(obj.g, string(src), string(temp));
                        end
                        if (findedge(obj.g, string(src), string(temp)) == 0)
                            obj.g = addedge(obj.g, string(src), string(temp));
                        end
                    end
                end


                %obj.lmpr = mpr(obj,obj.lmpr);
                %obj.payload = constructPayload (obj,0,0,0,0,0);
                %obj = setSendOptions(obj, 0, 25000,5);
                %netManager = send(obj, netManager, src, obj.payload,length(obj.payload)*32, GlobalTime);
            
            elseif msgType == 1
                if ~(isempty(obj.mpr_ant == src)) && (str2num(data(6) > 1))
                    origem = str2num(data(4));
                    dst = str2num(data(5));
                    ttl = str2num(data(6)) - 1;
                    for r=1:6
                        data(r) = [];
                    end
                    if (findnode(obj.g, data(5)) == 0) %se eu não conheço reencaminha a msg
                        obj.payload = constructPayload (obj,1,origem,dst,ttl,data);
                    elseif (findnode(obj.g, data(5)) ~= 0)
                        obj.payload = constructPayload (obj,3,origem,dst,ttl,data);
                    end
                        obj = setSendOptions(obj, 0, 25000,5);
                        netManager = broadcast(obj,netManager,obj.payload,length(obj.payload)*32,GlobalTime);
                end

            elseif msgType == 2
                
                if ~(isempty(strcmp(data, string(obj.ID))))
                    if isempty(obj.mpr_ant == src)
                        obj.mpr_ant = [obj.mpr_ant src];
                    end
                end

            elseif msgType == 3
                origem = str2num(data(4));
                dst = str2num(data(5));
                
                for r=1:5
                    data(r) = [];
                end
                
                if str2num(dst == obj.ID)
                    disp('MSG RECEBIDA')
                    disp(['Origem :', origem])
                    disp(data)
                elseif ~(isempty(obj.mpr_ant == src)) && findnode(obj.g, string(src) ~= 0)
                    obj.payload = constructPayload (obj,3,origem,dst,0,data);
                    obj = setSendOptions(obj, 0, 25000,5);
                    netManager = broadcast(obj,netManager,obj.payload,length(obj.payload)*32,GlobalTime);
                end

            end

            obj.APPLICATION_LOG.DATA = obj;
            %obj.APPLICATION_LOG.DATA = ['One Hope list = ', string(obj.One_hope),...
             %                       'Two Hope list = ', string(obj.two_hope),...
              %                      'MPR list = ', string(obj.lmpr)];%'Exemplo de log';
            
            
        end

        function [obj,netManager,WPTManager] = handleTimer(obj,GlobalTime,netManager,WPTManager)

            
            
            v = neighbors(obj.g, string(obj.ID)); %Verifica se exite vizinho
            
            obj.payload = constructPayload(obj,0,0,0,0,0);
            obj = setSendOptions(obj, 0, 25000,5);
            netManager = broadcast(obj,netManager,obj.payload,length(obj.payload)*32,GlobalTime);

            obj.lmpr = mpr(obj);
        
            if (isempty(obj.lmpr) == 0)
                obj.payload = constructPayload(obj,2,0,0,0,0);
                obj = setSendOptions(obj, 0, 25000,5);
                netManager = broadcast(obj,netManager,obj.payload,length(obj.payload)*32,GlobalTime);
            end
            
            

            %figure(obj.ID);
            %    plot (obj.g);
            %    highlight(plot (obj.g),string(obj.ID),'NodeColor', [0 0.75 0]);
                %highlight(plot (obj.g),v,'NodeColor', 'red');
                %highlight(plot (obj.g),string(obj.ID),v,'EdgeColor', 'red');
                %highlight(plot (obj.g),string(obj.lmpr),'NodeColor', [0 0 1]);
            
            netManager = setTimer(obj,netManager,GlobalTime,obj.interval); %realimenta a simulação com novo evento de tempo
            
            
        end

    end

end
