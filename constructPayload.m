function [pkt] = constructPayload (obj,msgType,src,dst,ttl,data)
    v = neighbors(obj.g,string(obj.ID));
    if msgType == 0
        pkt = [string(msgType),string(obj.ID)];
    elseif msgType == 1
        pkt = [string(msgType),string(obj.ID),string(length(v))];
        for r=1:length(v)
            pkt = [pkt string(v(r))];
        end
    elseif msgType == 2
        pkt = [string(msgType),string(src),string(dst),string(ttl)];
        for r=1:4
            data(r) = [];
        end
        pkt = [pkt data];
    end
end