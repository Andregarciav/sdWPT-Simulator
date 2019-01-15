function verificaMPR(g,ID,lMPR)
    v = neighbors(g, string(ID));
    list_twoHop = [];
    listaVizinhos = [];
    if ~(isempty(v)) %verica se a lista de visinhos está vazia
        for r=1:length(v)
            listaVizinhos = [listaVizinhos str2num(v(r))];
        end
        for r=1:length(listaVizinhos) %visita todos os vizinhos de ID
            twoHop = neighbors (g, v(r)); %cria uma lista de todos os vizinhos do vizinho atual de ID
            for s=1:length(twoHop)
                if isempty(list_twoHop(list_twoHop == str2num(twoHop(s)))) &&...
                           isempty(listaVizinhos(listaVizinhos == str2num(twoHop(s)))) &&...
                           str2num(twoHop(s)) ~= ID  
                    list_twoHop = [list_twoHop str2num(twoHop(s))];
                end
            end
        end
        %   Retira todos os vizinhos dos MPR da lista de dois saltos
        for r=1:length(lMPR)
            v = neighbors(g, string(lMPR(r)));
            for s=1:length(v)
                if str2num(v(s)) ~= ID
                    list_twoHop(list_twoHop == str2num(v(s))) = [];
                end
            end
        end
    end
    %   Caso a lista de dois saltos fique vazia verificação bem sucedida
    if isempty(list_twoHop)
        disp('---------------------------------------')
        disp('Verificacao de MPR: FunFou.')
        disp('---------------------------------------')
    else
        disp('---------------------------------------')
        disp('Verificacao de MPR: Foi mal.')
        disp('---------------------------------------')
        error('Se fudeu!!!!');
    end
end