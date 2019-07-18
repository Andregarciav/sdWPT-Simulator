function [pkt] = constructPayload (obj)%,msgType,src,dst,ttl,data)
    v = neighbors(obj.g,string(obj.ID));
    pkt = [];
    % if msgType == 0
    %     v = neighbors(obj.g,string(obj.ID));
    %     %Construindo o cabeçalho
    %     pkt = header(obj,msgType,obj.ID,0,ttl,length(v));
    %     %add payload
        if ~isempty(v)
            for r=1:length(v)
                pkt = [pkt string(v(r))];
            end
        else
            pkt = [];
        end
    % elseif msgType == 1
    %     %Construindo o cabeçalho
    %     pkt = header(obj,msgType,src,dst,ttl,length(data));
    %     %add payload
    %     pkt = [pkt data];
    % elseif msgType == 2
    %     %Construindo o cabeçalho
    %     pkt = header(obj,msgType,obj.ID,0,ttl,length(obj.lmpr));
    %     %add payload
    %     for r=1:length(obj.lmpr)
    %         pkt = [pkt string(obj.lmpr(r))];
    %     end
    % elseif msgType == 3
    %     %Construindo o cabeçalho
    %     pkt = header(obj,msgType,src,dst,1,length(data));
    %     %add payload
    %     pkt = [pkt data];            
    % end
end