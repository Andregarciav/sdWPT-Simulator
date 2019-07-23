classdef quadro
    properties (SetAccess = private, GetAccess = public)
        msgType;    % 16 bits - 2 bytes\
        number;     % 16 bits - 2 bytes \
        msg_len;    % 16 bits - 2 bytes  \
        noAnterior; % 32 bits - 4 bytes   > 20 bytes
        src;        % 32 bits - 4 bytes  /
        dst;        % 32 bits - 4 bytes /
        ttl;        % 16 bits - 2 bytes/
        payload;    % Tamanho variável
        TimeInit;   % Não é usado no tamanho, somente usado para calculo da vazão.
    end

    methods

        function obj = quadro()
            
        end

        function  obj = construct(obj, msgType, number, noAnterior, src, dst, ttl, payload, Time)
            obj.msgType = msgType;
            obj.number = number;
            obj.noAnterior = noAnterior;
            obj.src = src;
            obj.dst = dst;
            obj.ttl = ttl;
            obj.payload = [payload];
            obj.msg_len = obj.getLen() - 20;
            obj.TimeInit = Time;
        end

        function len = getLen (obj)
            headerLen = 20;
            len_payload = obj.lenPayload();
            len = headerLen + len_payload;
        end

        function obj = modifyPayload(obj, newData)
            obj.payload = [newData];
            obj.msg_len = lenPayload(newData);
        end

        function obj = addData(obj, newData)
            obj.payload = [obj.payload,newData];
            obj.msg_len = obj.msg_len + lenPayload(newData);
        end

        function obj = decreaseTTL(obj)
            obj.ttl = obj.ttl-1;
        end
        
        function obj = TimeSend (obj, Time)
            obj.TimeInit = Time;
        end

        function payloadLen = lenPayload(obj)
            p = obj.payload; % Não aceita parte do obj para o whos
            if ~isempty(p)
                prop = whos('p');
                if strcmp(prop.class,'string')
                    payloadLen = length(p)*4;
                else
                    payloadLen = prop.bytes/2;
                end
            else
                payloadLen = 0;
            end
        end

    end
end