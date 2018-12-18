classdef powerRXApplication_dummieCoils < powerRXApplication
    properties
        interval = 2;
        One_hope = [];
        two_hope = [];
        g = graph
        wantAck = false;
        cont = 0;
        payload = [];
        listControl = 4;
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
            msg_len = data(2);
            src = str2num(data(3));
            
            if msgType == 0
                %disp('msgType = 0')
                if isempty(obj.One_hope(obj.One_hope == src))
                    obj.One_hope = [obj.One_hope src];
                    %disp('Adicionado Objeto One_hope')
                end
                %%%%%%%%%%%%%%%%%%%%%% ADD NODES AND EDGES IN GRAPH %%%%%%%%%%
                v = neighbors(obj.g, string(obj.ID));
                if isempty(v)
                    obj.g = addnode(obj.g, string(src));
                    obj.g = addedge(obj.g, string(obj.ID), string(src));
                end
                
                if (findnode(obj.g, string(src))==0)
                    obj.g = addnode(obj.g, string(src));
                    obj.g = addedge(obj.g, string(obj.ID), string(src));
                end
                    %%%%%%%%%%%%%%%%%%%%%%% END %%%%%%%%%%%%%%%%%%%%%%


                msg_len = length(obj.One_hope);
                obj.payload = ['1',msg_len,string(obj.ID),string(obj.One_hope)];
                obj = setSendOptions(obj, 0, 25000,5);
                netManager = send(obj, netManager, src, obj.payload,length(obj.payload)*32, GlobalTime);
            
            elseif msgType == 1
                %disp('msgType = 1')
                %disp(['Tamanho da msg: ',string(length(data))])
                if isempty(obj.One_hope(obj.One_hope == src))
                    if isempty(obj.two_hope(obj.two_hope == src)) == 0
                        obj.two_hope(obj.two_hope == src) = [];
                    end
                    obj.One_hope = [obj.One_hope src];
                    %disp('Adicionado Objeto One_hope')
                end
                
                 %%%%%%%%%%%%%%%%%%%%%% ADD NODES AND EDGES IN GRAPH %%%%%%%%%%
                
                 if (findnode(obj.g, string(src))==0)
                     obj.g = addnode(obj.g, string(src));
                     obj.g = addedge(obj.g, string(obj.ID), string(src));
                 end
                 %%%%%%%%%%%%%%%%%%%%%%% END %%%%%%%%%%%%%%%%%%%%%%
                if length(data) > 3
                    for r = 4:(length(data))
                        temp = str2num(data(r));
                        if (isempty(obj.One_hope(obj.One_hope==temp))) && (obj.ID~=temp) % se obj não existir na lista de um salto e for vizinho
                            if isempty(obj.two_hope(obj.two_hope==temp))
                                obj.two_hope = [obj.two_hope temp];
                            end
                        end
                        %%%%%%%%%%%%%%%%%%%%%% ADD NODES AND EDGES IN GRAPH %%%%%%%%%%
                        if (findnode(obj.g, string(temp))==0)
                            obj.g = addnode(obj.g, string(temp));
                            obj.g = addedge(obj.g, string(src), string(temp));
                        end
                        if (findedge(obj.g, string(src), string(temp)) == 0)
                            obj.g = addedge(obj.g, string(src), string(temp));
                        end
                        %%%%%%%%%%%%%%%%%%%%%%% END %%%%%%%%%%%%%%%%%%%%%%
                    end
                end
                obj.wantAck = false;
                obj.cont = 0;
            elseif msgType == 2
                
            end
            for r = 1:length(obj.One_hope)
                obj.two_hope(obj.two_hope == obj.One_hope(r)) = [];
            end
            %disp(['I have ID = ',num2str(obj.ID),' and I detected the device with ID = ',num2str(src)]);
            obj.APPLICATION_LOG.DATA = ['One Hope list = ', string(obj.One_hope),...
                                    'Two Hope list = ', string(obj.two_hope)];%'Exemplo de log';
            
        end

        function [obj,netManager,WPTManager] = handleTimer(obj,GlobalTime,netManager,WPTManager)
            %teste();
            if obj.wantAck == false
                obj.payload = ['0','0',string(obj.ID)];
                payloadLen = length(obj.payload)*32;
                %canal 0 de (vlc sobre) swipt, 1000bps, 5W
                obj = setSendOptions(obj, 0, 25000,5);
                netManager = broadcast(obj,netManager,obj.payload,payloadLen,GlobalTime);
                obj.wantAck = true;
                %disp(['I have ID = ',num2str(obj.ID),' and I send a broadcast']);
            else
                if obj.cont < 2
                    netManager = broadcast(obj,netManager,obj.payload,length(obj.payload),GlobalTime);
                    obj.cont = obj.cont + 1;
                    %disp('Resend msg!')
                else
                    obj.cont = 0;
                    obj.wantAck = false;
                    %disp('Msg Drop!!')
                    obj.listControl = obj.listControl - 1;
                    if obj.listControl == 0
                        obj.One_hope = [];
                        obj.two_hope = [];
                        obj.listControl = 4;
                        %disp(['Lista zerada!!! :',string(obj.ID)])
                    end
                end
            end
            
            v = neighbors(obj.g, string(obj.ID));
            peso = [];
            for r = 1:length(v)
                peso = [peso 4];
            end
            
            for r = 1:length(v)
                obj.payload = ['2','0',string(obj.ID)];
                netManager = send(obj, netManager, str2num(v(r)), obj.payload,length(obj.payload)*32, GlobalTime);
            end
            
            netManager = setTimer(obj,netManager,GlobalTime,obj.interval); %realimenta a simulação com novo evento de tempo
            figure(obj.ID);
                plot (obj.g);
        end

        %function teste(a)
        %    disp([' hahahaha 1'])
       % end
    end
end
