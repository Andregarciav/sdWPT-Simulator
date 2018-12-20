function Packet = creatPacket(obj,msgType,data,GlobalTime,dst)
%myFun - Description
%
% Syntax: Packet = myFun(input)
%
% Long description
    if msgType == 00 %significa hello
        msg_len = '00';
        if isempty(obj.One_hope)
            disp('Aqui')
            payload = ['00',msg_len,'00',string(obj.ID)]
        end
        %else
        %    payload = [num2str(msgType),num2str(msg_len),obj.ID,string(obj.One_hope)]
        %end
    end    
end

 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|       Reserved                |   Htime       |   Willingness |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| Link Code    |    Reserved    |        Link Message Size      |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                   Neighbor Interface Address                  |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                   Neighbor Interface Address                  |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+





 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|           MSG_type            |   Htime       |   Willingness |





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




function mudaPesoAdj(graph,quant)
    for r = 1:(length(b(1,:)))
        for i = 1:(length(b(:,1)))
            if b(r,i) ~= 0
                b(r,i) = b(r,i) + quant;
            end
        end
    end
end







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
                %    obj.g = addnode(obj.g, string(src));
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
                v = neighbors(obj.g, string(obj.ID));
                for r = 1:length(v)
                    obj.payload = [obj.payload v(r)];
                end
                obj.payload = ['1',msg_len,string(obj.ID) obj.payload];
                obj = setSendOptions(obj, 0, 25000,5);
                netManager = send(obj, netManager, src, obj.payload,length(obj.payload)*32, GlobalTime);
                obj.wantAck = false;
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
                %            if obj.wantAck == false 
                obj.payload = ['0','0',string(obj.ID)];
                payloadLen = length(obj.payload)*32;
                %canal 0 de (vlc sobre) swipt, 1000bps, 5W
                obj = setSendOptions(obj, 0, 25000,5);
                netManager = broadcast(obj,netManager,obj.payload,payloadLen,GlobalTime);
             %               obj.wantAck = true;
                %disp(['I have ID = ',num2str(obj.ID),' and I send a broadcast']);
                %            elseif (obj.wantAck == true) && (isemptyneighbors(obj.g, string(obj.ID)())
                %              if obj.cont < 2
                %                    netManager = broadcast(obj,netManager,obj.payload,length(obj.payload),GlobalTime);
                %                    obj.cont = obj.cont + 1;
                %                    %disp('Resend msg!')
                %                else
                %                    obj.cont = 0;
                %                    obj.wantAck = false;
                %                    %disp('Msg Drop!!')
                %                    obj.listControl = obj.listControl - 1;
                %                    if obj.listControl == 0
                %                        obj.One_hope = [];
                %                        obj.two_hope = [];
                %                        obj.listControl = 4;
                %                        %disp(['Lista zerada!!! :',string(obj.ID)])
                %                    end
                %                end
            %end
            
            v = neighbors(obj.g, string(obj.ID));
            if (isempty(v) == 0) %se obj.ID tem vizinho
                peso = [];
                for r = 1:length(v)
                    peso = [peso 4];
                end
                
                for r = 1:length(v)
                    obj.payload = ['2','0',string(obj.ID)];
                    netManager = send(obj, netManager, str2num(v(r)), obj.payload,length(obj.payload)*32, GlobalTime);
                    obj.wantAck = true;
                    netManager = setTimer(obj,netManager,GlobalTime,obj.interval);
                    if obj.wantAck == true
                        %obj.g = rmedge(obj.g, string(obj.ID), v(r));
                        obj.g = rmnode(obj.g, v(r));
                    end
                end

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




%%%%%%%%%%%%%%%%%%%%%%%%%MPR%%%%%%%%%%%%%%%%%%%%%%%%


clear;
clc;

g = graph;

for r=1:8
    g = addnode(g, string(r));
end

for r=1:randi([5 20])
    a = num2str(randi([1 8]));
    b = num2str(randi([1 8]));
    
    if((findedge(g,a,b)==0) && findedge(g,b,a)==0 && a~=b)
        g = addedge(g, a, b);
    end
end
figure(1)
    plot(g)

ID = 5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Aqui começa o MPR     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

v = neighbors(g, string(ID));
lista = zeros(numnodes(g)); %Cria a Lista independente de vizinhos
M_AD = full(adjacency(g));
lMPR = [];
%Obtendo um vetor de numeros ao invez de um vetor de strings
m = [];
for h=1:length(v)
    m = [m str2num(v(h))];
end
m;
mv = 0*[1:length(v)];
if (length(v)>1) %caso tenha mais de um vizinho, constroi a lista de vizinhos
    %for r=1:length(M_AD)
    %    if(M_AD(ID,r)) == 1
    %        for s=1:length(M_AD)
    %            if(M_AD(r,s)) == 1 && (M_AD(ID,r) || M_AD(r,ID) ~= 1)
    %                lista(r,1) = r;
    %            end
    %        end
    %    end
    %end
    for r=1:length(v) %Para cada vizinho, verifica os vizinhos
        %if(lista(r,1) ~= 0)
            t=1;
            for s=1:length(M_AD)
                if(M_AD(m(r),s)==1 && s ~= ID)
                    if isempty(m(m==s))
                        lista(m(r),t) = s;
                        t = t+1;
                    end
                end
            end
            %end
        %end
    end
    %Listas de vizinhos de vizinhos pronta
    for r=1:length(v)
        mv(r) = sum ( lista(str2num(v(r)),:)~=0);
    end
    m = [m;mv]
    lMPR = [lMPR m(1,max(m(2,:)))
    lista
elseif(length(v)==1)
    lMPR = [v]; %transformar em lista de MPR
elseif(length(v)==0)
    lMPR = []; %transformar em lista de MPR
end


%for r=1:length(v)
    
    
    
