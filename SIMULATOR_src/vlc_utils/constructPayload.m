function [pkt] = constructPayload (obj,msgType,src,dst,ttl,data)
    if msgType == 0
        v = neighbors(obj.g,string(obj.ID));
        pkt = header(obj,msgType,obj.ID,0,ttl,length(v));
        
        if ~isempty(v)
            for r=1:length(v)
                pkt = [pkt string(v(r))];
            end
        else
            pkt = [pkt string(0)];
        end
    elseif msgType == 1
        pkt = header(obj,msgType,src,dst,ttl,length(data));
        pkt = [pkt data];
    elseif msgType == 2
        pkt = header(obj,msgType,obj.ID,0,ttl,length(obj.lmpr));
        for r=1:length(obj.lmpr)
            pkt = [pkt string(obj.lmpr(r))];
        end
    elseif msgType == 3
        pkt = header(obj,msgType,src,dst,1,length(data));
        pkt = [pkt data];            
    end
end