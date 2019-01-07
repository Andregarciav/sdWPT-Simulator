function [obj] = vizinhos(obj,data)
    v = neighbors(obj.g, string(obj.ID));
    src = str2num(data(3));

    if isempty(v)
        obj.g = addnode(obj.g, string(src));
        obj.g = addedge(obj.g, string(obj.ID), string(src));
    end
    
    if (findnode(obj.g, string(src))==0)
        obj.g = addnode(obj.g, string(src));
        obj.g = addedge(obj.g, string(obj.ID), string(src));
    end
    
    if length(data) > 3
        for r = 4:(length(data))
            temp = str2num(data(r));
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