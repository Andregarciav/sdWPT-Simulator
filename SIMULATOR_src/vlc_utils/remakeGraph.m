function obj = remakeGraph(obj)
    if length(obj.oneHope(1,:)) == 1
        obj.oneHope(2,1) = obj.oneHope(2,1) - 1;
    else
        for r=1:length(obj.oneHope)
            obj.oneHope(2,r) = obj.oneHope(2,r) - 1;
        end
    end
    %Caso após duas rodas não tenha recebido msg do vizinho o nó é retirado
    while isempty(find(obj.oneHope==0)) == 0
        %remove vizinho do grafo
        obj.g = rmedge(obj.g,string(obj.ID),string(obj.oneHope(find(obj.oneHope==0,1,'first')/2)));
        obj.g = rmnode(obj.g,string(obj.oneHope(find(obj.oneHope==0,1,'first')/2)));
        %remove da lista de controle dos vizinhos
        obj.oneHope(:,find(obj.oneHope==0,1,'first')/2) = [];
    end
end