function  add_node(obj,src,temp)
    v = neighbors(obj.g, string(obj.ID));
    if isempty(v)
        obj.g = addnode(obj.g, string(src));
        obj.g = addedge(obj.g, string(obj.ID), string(src));
    end
    
    if (findnode(obj.g, string(src))==0)
        obj.g = addnode(obj.g, string(src));
        obj.g = addedge(obj.g, string(obj.ID), string(src));
    end

    if temp ~=0 
        if (findnode(obj.g, string(temp))==0)
            obj.g = addnode(obj.g, string(temp));
            obj.g = addedge(obj.g, string(src), string(temp));
        end
        if (findedge(obj.g, string(src), string(temp)) == 0)
            obj.g = addedge(obj.g, string(src), string(temp));
        end
    end
end