classdef quadro
    properties (SetAccess = private, GetAccess = public)
        msgType;    % 16 bits - 2 bytes\
        number;     % 16 bits - 2 bytes \
        msg_len;    % 16 bits - 2 bytes  \
        noAnterior; % 32 bits - 4 bytes   > 20 bytes
        src;        % 32 bits - 4 bytes  /
        dst;        % 32 bits - 4 bytes /
        ttl;        % 16 bits - 2 bytes/
        payload;    %tamanho variável
        TimeInit;
    end

    methods

        function obj = quadro()
            
        end

        function  obj = construct(obj, msgType, number, noAnterior, src, dst, ttl, payload)
            prop = whos('payload');
            
            obj.msgType = msgType;
            obj.number = number;
            obj.msg_len = prop.bytes;
            obj.noAnterior = noAnterior;
            obj.src = src;
            obj.dst = dst;
            obj.ttl = ttl;
            obj.payload = [payload];
        end

        function len = getLen (obj)
            headerLen = 20;
            p = obj.payload
            prop = whos('p')
            len = headerLen + prop.bytes;
        end

        function obj = modifyPayload(obj, newData)
            obj.payload = [newData];
        end

        function obj = addData(obj, newData)
            obj.payload = [obj.payload,newData];
        end

        function obj = decreaseTTL(obj)
            obj.ttl = obj.ttl-1;
        end
        
        function obj = TimeSend (obj, Time)
            obj.TimeInit = Time;
        end

    end
end