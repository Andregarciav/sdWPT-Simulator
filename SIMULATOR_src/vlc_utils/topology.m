%   Essa função atualiza a topologia dos nós que estão até 2
%   saltos do nó atual.

function obj = topology(obj, carga, msg_len, src)
    if (findnode(obj.g, string(src))==0)
        if isempty (obj.oneHope(obj.oneHope==src))
            obj.oneHope = [obj.oneHope [src;2]];
        else
            obj.oneHope(2,find(obj.oneHope(1,:) == src)) = 2;   
        end
        obj.g = addnode(obj.g, string(src));
        obj.g = addedge(obj.g, string(obj.ID), string(src));
    end
    
    if (~isempty(carga)) && strcmp(class(carga),'string') 
        i = msg_len/4;
    elseif isempty(carga)
        i = 0;
    else
        i = msg_len;
    end

    if i > 1
        for r = 1:i
            temp = str2num(carga(r));
            if (findnode(obj.g, string(temp))==0)
                obj.g = addnode(obj.g, string(temp));
                obj.g = addedge(obj.g, string(src), string(temp));
            end
            if (findedge(obj.g, string(src), string(temp)) == 0)
                obj.g = addedge(obj.g, string(src), string(temp));
            end
        end
    end
end