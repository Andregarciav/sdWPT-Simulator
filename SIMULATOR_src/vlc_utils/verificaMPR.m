function verificaMPR(g,ID,lMPR)
    v = neighbors(g, string(ID));
    list_twoHop = [];
    listaVizinhos = [];
    if ~(isempty(v)) %verica se a lista de visinhos está vazia
        for r=1:length(v)
            listaVizinhos = [listaVizinhos str2num(v(r))]
        end
        for r=1:length(v) %visita todos os vizinhos de ID
            twoHop = neighbors (g, v(r)); %cria uma lista de todos os vizinhos do vizinho atual de ID
            for s=1:length(twoHop)
                if isempty(list_twoHop(list_twoHop == str2num(twoHop(s)))) &&...
                    isempty(find(listaVizinhos, str2num(twoHop(s))))
                    list_twoHop = [list_twoHop str2num(twoHop(s))];
                end
            end
        end
        for r=1:length(lMPR)
            v = neighbors(g, string(lMPR(r)));
            for s=1:length(v)
                list_twoHop(list_twoHop == str2num(v(s))) = [];
            end
        end
        if isempty(list_twoHop)
            disp('FunFou');
        else
            error('Se fudeu');
        end
    end
end