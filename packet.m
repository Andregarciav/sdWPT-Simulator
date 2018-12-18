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