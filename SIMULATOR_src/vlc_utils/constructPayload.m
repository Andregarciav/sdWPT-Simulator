function [pkt] = constructPayload (obj,msgType,src,dst,ttl,data)
    v = neighbors(obj.g,string(obj.ID));
    if msgType == 0
        if isempty(v)
            pkt = [string(msgType),string(0),string(obj.ID)];
        else
            pkt = [string(msgType),string(length(v)),string(obj.ID)];
            for r=1:length(v)
                pkt = [pkt string(v(r))];
            end
        end
    elseif msgType == 1
            pkt = [string(msgType),string(length(data)),string(obj.ID),...
            string(src),string(dst),string(ttl),data];
    elseif msgType == 2
        pkt = [string(msgType),string(length(v)),string(obj.ID)];
        for r=1:length(obj.lmpr)
            pkt = [pkt string(obj.lmpr(r))];
        end
    elseif msgType == 3
        pkt = [string(msgType),string(length(data)),string(obj.ID)...
            string(src),string(dst),data];            
    end
end