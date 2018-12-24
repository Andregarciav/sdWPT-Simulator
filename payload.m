function [pkt] = payload (obj,msgType,dst)
    v = neighbors(obj.g,string(obj.ID))
    ttl = 16
    if msgType == 0
        pkt = [string(msgType),string(obj.ID)]
    elseif msgType == 1
        pkt = [string(msgType),string(obj.ID),string(length(v))]
        for r=1:length(v)
            pkt = [pkt string(v(r))]
        end
    elseif msgType == 2
        pkt = [string(msgType),string(obj.ID),string(dst)]
    end