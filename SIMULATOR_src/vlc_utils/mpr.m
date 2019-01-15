function [lMPR] = mpr (g,ID)
    lMPR = [];
    %   Lista de vizinhos do ID
    v = neighbors(g, string(ID));
    %   Obtendo um vetor de numeros ao invez de um vetor de strings
    if length(v) == 0
        lMPR = [] % Se não tem vizinhos, não tem MPR
    elseif length(v) == 1
        if length(neighbors(g,v(1))) > 1 %  Se os vizinhos dos vizinho é maior que 1, ele é mpr
            lMPR = [str2num(v(1))];
        else    %   Se o vizinho não tem vizinhos, lista MPR é vazia
            lMPR = [];
        end
    elseif length(v) > 1 %lista de vizinhos é maior do que 1
        grafo = g; %gerando um grafo para ser manipulado
        listaDoisSaltos = [];
        while ~(isempty(neighbors(grafo, string(ID)))) %
            vizinhosTemp  = neighbors(grafo, string(ID));
            listaVizinhos = [];
            for h=1:length(vizinhosTemp)
                listaVizinhos = [listaVizinhos [str2num(vizinhosTemp(h));degree(grafo,vizinhosTemp(h))]];
            end
            indexVizinhos = find(listaVizinhos == max (listaVizinhos(2,:)),1,'last')/2;
            vizinhoAtual = listaVizinhos(1,indexVizinhos);
            V_Vn = neighbors(grafo,string(vizinhoAtual));
            if (length(V_Vn) ~= 1)
                for r=1:length(V_Vn) %remove todos os vizinhos do Vizinho atual, exceto o ID
                    if (ID ~= str2num(V_Vn(r)) && isempty(listaDoisSaltos(listaDoisSaltos == str2num(V_Vn(r)))))
                        listaDoisSaltos = [listaDoisSaltos str2num(V_Vn(r))];
                        grafo = rmnode (grafo,V_Vn(r));
                        if isempty(lMPR(lMPR==vizinhoAtual))
                            lMPR = [lMPR vizinhoAtual];
                        end
                    end
                end
            end
            grafo = rmnode(grafo,string(vizinhoAtual)); %   Remove o vizinho atual do grafo temporário 
            %lMPR = [lMPR vizinhoAtual];
        end
    end
end
