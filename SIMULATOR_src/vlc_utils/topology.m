function obj = topology(obj, carga, msg_len, src)
    if (findnode(obj.g, string(src))==0)
        %   Verifica lista de controle atualiza 
        if isempty (obj.oneHope(obj.oneHope==src))
            obj.oneHope = [obj.oneHope [src;2]];
        else
            obj.oneHope(2,find(obj.oneHope(1,:) == src)) = 2;   
        end
        %Adicionando os nós no grafo e adicionando as arestas
        obj.g = addnode(obj.g, string(src));
        obj.g = addedge(obj.g, string(obj.ID), string(src));
    end
    
    % Aqui trata o tipo de variável do payload se o payload tem string ou char
    if (~isempty(carga)) && strcmp(class(carga),'string') 
        i = msg_len/4;
    else
        i = msg_len;
    end
    
    % Atualiza lista de nós alcansáveis com dois saltos
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