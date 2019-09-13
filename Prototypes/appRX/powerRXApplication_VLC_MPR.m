classdef powerRXApplication_VLC_MPR < powerRXApplication
    properties
        numberNodes;        %   Usado somente para saber quais nós existem para enviar msg
        interval;           %   Intervalo entre as rodadas
        mpr_ant = [];       %   Lista de nós que sou MPR
        oneHope = [];       %   Nós a um salto, usado como controle para retirar um nó da lista de vizinhos
        g = graph;          %   grafo do nó, vizinhos e vizinhos de vizinhos
        seqNumber = 0;      %   Usado para numero de sequencia
        payload = [];       %   Carga útil a ser enviado, pode vir das camadas superiores ou para construir a topologia
        lmpr = [];          %   lista de nós MPR para o nó
        lmsgReceive = [];   %   lista numero de msg recebidas de nós
        Position;
        pktReceive = [];
        log_msgtype = [];
        latencia = [];
        bitRate = [];
        timeArrival = [];
        wantAck = false;
        temp = quadro;
        retransmit = 4;
    end
    methods
        function obj = powerRXApplication_VLC_MPR(id,interval, numberNodes)
            obj@powerRXApplication(id);%construindo a estrutura referente �superclasse
            obj.g = addnode(obj.g,string(obj.ID));
            obj.interval = interval;
            obj.numberNodes = numberNodes;
            obj.pktReceive = {obj.ID};
            obj.log_msgtype = [0 0 0 0 0];
            
        end

        function [obj,netManager,WPTManager] = init(obj,netManager,WPTManager)
        	GlobalTime = 0;
        	intervalo = rand*5;%random interval to begin the object
            netManager = setTimer(obj,netManager,GlobalTime,intervalo);
            p = getCenterPositions (WPTManager.ENV,GlobalTime);
            obj.Position = p(obj.ID+1);
            obj = setSendOptions(obj, 0, 25000,5);
        end

        function [obj,netManager,WPTManager] = handleMessage(obj,data,GlobalTime,netManager,WPTManager)

            msg = quadro; %instanciando um novo obj msg

            timeInit = data.TimeInit;
            timeArrival = GlobalTime;
            %%%%%%%%%%%%%%%%%%%%%% Obtendo dados do cabeçalho                       
            msgType = data.msgType;         %   Tipo de msg recebida
            Number = data.number;           %   Número de sequência da msg
            msg_len = data.msg_len;         %   Tamanho da msg, desconsiderando cabeçalho
            noAnterior = data.noAnterior;   %   Nó por qual a msg chegou
            src = data.src;                 %   Nó que originou a msg
            dst = data.dst;                 %   Qual é o destino da msg
            ttl = data.ttl;                 %   Time to live da msg
            %%%%%%%%%%%%%%%%%%%%%% Atualizando parâmetros
            carga = data.payload;           %   Retirando cabeçalho
            ttl = ttl - 1;                  %   Decrementando o TTL
            %%%%%%%%%%%%%%%%%%%% Tratando a mensagem

            obj.log_msgtype(msgType+1) = obj.log_msgtype(msgType+1)+1; 
            
            if isempty(obj.lmsgReceive(obj.lmsgReceive == noAnterior))
                obj.lmsgReceive = [obj.lmsgReceive [noAnterior;1]];
            else
                obj.lmsgReceive(2,find(obj.lmsgReceive(1,:) == noAnterior)) = obj.lmsgReceive(2,find(obj.lmsgReceive(1,:) == noAnterior))+1; 
            end

            % Mensagem do tipo 0, é uma mensagem de construção da topologia da rede
            if msgType == 0
                obj = topology(obj, carga, msg_len, src);

            % Mensagem do tipo 1 é mensagem de broadcast trafegando pela rede
            elseif msgType == 1
                %testa se faz parte da lista MPR e se ainda existem saltos no TTL
                if (isempty(obj.mpr_ant == src) == 0) && (ttl > 1)
                    if (findnode(obj.g, string(dst)) == 0) %se não conheço reencaminha a msg
                        carga = [carga string(obj.ID)]; % Não faz parte do protocolo, só pra saber o caminho
                        msg = msg.construct(msgType, Number, obj.ID, src, dst, ttl, carga, TimeInit);
                    elseif (findnode(obj.g, string(dst)) ~= 0 && dst ~= obj.ID) %%se conheço transformo a msg tipo 1 em tipo 3 e encaminho
                        msg = msg.construct(3, Number, obj.ID, src, dst, ttl, carga, timeInit);
                    elseif dst == obj.ID
                        % latency =  timeArrival - timeInit;
                        % bitRate = msg_len/latency;
                        % obj.latencia = [obj.latencia latency*1000];
                        % obj.bitRate = [obj.bitRate bitRate/1024];
                        % obj.timeArrival = [obj.timeArrival timeArrival];
                        %aqui construir ACK
                        carga = constructPayload(obj);
                        msg = msg.construct(4,Number, obj.ID, obj.ID, dst, 16, carga);
                    end
                        netManager = broadcast(obj,netManager,msg,msg.getLen(),GlobalTime);
                end
                if ttl == 1
                    disp('Drop MSG!!!')
                end
            %mensagem do tipo 2 é mensagem informando aos vizinhos quais são seu mpr
            elseif msgType == 2
                obj = obj.msgType2(carga, src);
            %msg do tipo 3 é a mensagem quando está a no máximo dois saltos do destinatário
            elseif msgType == 3
                % disp('MSG TYPE: 3')
                novamsg = quadro;
                if dst == obj.ID
                    carga = constructPayload(obj);
                    novamsg = novamsg.construct(4,Number, obj.ID, obj.ID, src, 16, carga, timeInit);
                    netManager = broadcast(obj,netManager,novamsg,novamsg.getLen(),GlobalTime);
                    % disp('ACK send!!!')
                elseif (isempty(obj.mpr_ant == src) == 0) && (findnode(obj.g, string(src)) ~= 0) && (ttl > 0)
                    msg = msg.construct(3,Number,noAnterior,src,dst,ttl,carga, timeInit);
                    netManager = broadcast(obj,netManager,msg,msg.getLen(),GlobalTime);
                end
                
            elseif msgType == 4
                % disp('MSG TYPE: 4')
                if dst == obj.ID
                    obj.wantAck = false;
                    latency =  timeArrival - timeInit;
                    bitRate = msg_len/latency;
                    obj.latencia = [obj.latencia latency*1000];
                    obj.bitRate = [obj.bitRate bitRate/1024];
                    obj.timeArrival = [obj.timeArrival timeArrival];
                    carga = constructPayload(obj);
                    msg = msg.construct(4,Number, obj.ID, obj.ID, dst, 16, carga, timeInit);
                end
                % obj = topology(obj, carga, msg_len, src);
    
            end
            obj = LOG(obj);         
        end

        function [obj,netManager,WPTManager] = handleTimer(obj,GlobalTime,netManager,WPTManager)
            %reconfigurarando a lista de vizinhos
            if isempty(obj.oneHope)==0
                obj = remakeGraph(obj);
            end

            obj.seqNumber = obj.seqNumber+1;
            msg = quadro;
            pkt = constructPayload(obj);
            msg = msg.construct(0,obj.seqNumber, obj.ID, obj.ID, 0, 16, pkt, GlobalTime);
            netManager = broadcast(obj,netManager,msg,msg.getLen(),GlobalTime);
            %   Obtem a lista de MPR
            obj.lmpr = mpr(obj.g,obj.ID);

            %   Envia a lista MPR, caso ela não esteja vazia
            if ~(isempty(obj.lmpr))
                msgType = 2;
                obj.seqNumber = obj.seqNumber+1;
                msg = msg.construct(msgType,obj.seqNumber, obj.ID, obj.ID, 0, 16, [], GlobalTime);
                msg = msg.TimeSend(GlobalTime);
                netManager = broadcast(obj,netManager,msg,msg.getLen,GlobalTime);
            end
            
            %%%%%% FUNÇÃO DE TESTE  %%%%%%%%%
            if (obj.ID == 1)...
                && ( ((GlobalTime > 8) && (GlobalTime < 50)) || ((GlobalTime > 200) && (GlobalTime < 350)) )...
                && obj.wantAck == false 
                data = ['Oi eu sou o ',num2str(obj.ID),'.'];
                sendto =  randi([1, obj.numberNodes]);
                obj.seqNumber = obj.seqNumber+1;
                while sendto == obj.ID
                    sendto = randi([1, obj.numberNodes]);
                end
                %se conhece msg tipo 3, se não msg tipo 1
                if (isempty(findnode(obj.g,string(sendto)))) 
                    msgType = 1;
                    ttl = 16;
                    noAnterior = 0;
                else
                    msgType = 3;
                    ttl = 2;
                    noAnterior = obj.ID;
                end
                msg = msg.construct(msgType,obj.seqNumber, obj.ID, obj.ID, sendto, ttl, data, GlobalTime);
                temp = msg;
                netManager = broadcast(obj,netManager,msg,msg.getLen,GlobalTime);
            elseif obj.wantAck == true && obj.retransmit > 0
                netManager = broadcast(obj,netManager,temp,temp.getLen,GlobalTime);
                obj.retrasmit = obj.retransmit - 1;
                if obj.retransmit == 0
                    obj.wantAck = false;
                end
            end

            netManager = setTimer(obj,netManager,GlobalTime,obj.interval); %realimenta a simulação com novo evento de tempo
            
            obj = LOG(obj); 
        end

        function obj = msgType2(obj, carga, src)
            if ~(isempty(strcmp(carga, string(obj.ID))))
                if isempty(obj.mpr_ant == src)
                    obj.mpr_ant = [obj.mpr_ant src];
                end
            end
            if ~isempty(obj.mpr_ant == src)
                if isempty(strcmp(carga, string(obj.ID)))
                    obj.mpr_ant(obj.mpr_ant == src) = [];
                end
            end
        end

        function obj = LOG(obj)
            d.mpr_ant = obj.mpr_ant;
            d.oneHope = obj.oneHope;
            d.g = obj.g;
            d.seqNumber = obj.seqNumber;
            d.payload = obj.payload;
            d.lmpr = obj.lmpr;
            d.lmsgReceive = obj.lmsgReceive;
            d.Position = obj.Position;
            d.pktReceive = obj.pktReceive;
            d.log_msgtype = obj.log_msgtype;
            d.latencia = obj.latencia;
            d.bitRate = obj.bitRate;
            obj.APPLICATION_LOG.DATA = d; 
        end

    end

end
