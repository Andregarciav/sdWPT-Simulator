classdef powerRXApplication_dummieCoils < powerRXApplication
    properties
        interval = 2;
        mpr_ant = [];
        %two_hope = [];
        g = graph
        wantAck = false;
        cont = 0;
        seqNumber = 0;
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
            obj.seqNumber = randi(65536);%numero de sequência
        end

        function [obj,netManager,WPTManager] = handleMessage(obj,data,GlobalTime,netManager,WPTManager)
            data;
            %%%%%%%%%%%%%%%%%%%%%% Decodificando cabeçalho
            msgType = str2num(data(1)); %tipo de msg recebida
            Number = str2num(data(2));
            msg_len = str2num(data(3));
            noAnterior = str2num(data(4));
            src = str2num(data(5));
            dst = str2num(data(6));
            ttl = str2num(data(7));
            %%%%%%%%%%%%%%%%%%%%%% Atualizando parâmetros
            data; %debug
            
            data = data(8:end);
            ttl = ttl - 1;
            %%%%%%%%%%%%%%%%%%%% Tratando a mensagem
            
            
            %Mensagem do tipo 0, é uma mensagem de construção da topologia da rede
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
                
                if msg_len > 1
                    for r = 1:msg_len
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
                
            %mensagem do tipo 1 é mensagem de broadcast trafegando pela rede
            elseif msgType == 1
                %disp(['MSG type 1 rcv! ',string(obj.ID)]); %%%%% Debug
                %disp(['TTL:  ',string(ttl)]);  %%%%% Debug
                if (isempty(obj.mpr_ant == src) == 0) && (ttl > 1)
                    data;
                    if (findnode(obj.g, string(dst)) == 0) %se eu não conheço reencaminha a msg
                        data = [data string(obj.ID)];
                        obj.payload = constructPayload (obj,1,src,dst,ttl,data);
                    elseif (findnode(obj.g, string(dst)) ~= 0)
                        obj.payload = constructPayload (obj,3,src,dst,ttl,data);
                        disp(['Sou o no, ',string(obj.ID),' e conheço o no',string(dst),'.'])
                    end
                        obj = setSendOptions(obj, 0, 25000,5);
                        netManager = broadcast(obj,netManager,obj.payload,length(obj.payload)*32,GlobalTime);
                end
                if ttl == 1
                    disp('Drop MSG!!!')
                end
            %mensagem do tipo 2 é mensagem informando aos vizinhos quais são seu mpr
            elseif msgType == 2
                
                if ~(isempty(strcmp(data, string(obj.ID))))
                    if isempty(obj.mpr_ant == src)
                        obj.mpr_ant = [obj.mpr_ant src];
                    end
                end
            %msg do tipo 3 é a mensagem quando
            elseif msgType == 3
                
                if dst == obj.ID
                    disp(data)
                elseif (isempty(obj.mpr_ant == src) == 0) && (findnode(obj.g, string(src)) ~= 0) && (ttl > 0)
                    obj.payload = constructPayload (obj,3,src,dst,0,data);
                    obj = setSendOptions(obj, 0, 25000,5);
                    netManager = broadcast(obj,netManager,obj.payload,length(obj.payload)*32,GlobalTime);
                end

            end

            obj.APPLICATION_LOG.DATA = obj;        
            
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
            
            %%%%%% FUNÇÃO DE TESTE  %%%%%%%%%
            if (obj.ID == 4) && (GlobalTime > 8) && (GlobalTime < 9)
                data = ['Oi eu sou o 4.'];
                            % ConstructPayload(obj,msgType,ID_origem,ID_dst,ttl,data) 
                obj.payload = constructPayload(obj, 1, obj.ID, 19, 16, data);
                obj = setSendOptions(obj, 0, 25000,5);
                netManager = broadcast(obj,netManager,obj.payload,length(obj.payload)*32,GlobalTime);
            end

            netManager = setTimer(obj,netManager,GlobalTime,obj.interval); %realimenta a simulação com novo evento de tempo
            
            
        end

    end

end
