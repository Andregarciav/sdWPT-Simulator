function [lMPR] = mpr (g,ID)
    lMPR = [];
    %   Lista de vizinhos do ID
    v = neighbors(g, string(ID));
    %   Obtendo um vetor de numeros ao invez de um vetor de strings
    if length(v) == 0
        lMPR = []; % Se não tem vizinhos, não tem MPR
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
            listaVizinhos; %DEBUG
            ListaArestas = listaVizinhos(2,:);
            indexVizinhos = find(ListaArestas == max (ListaArestas),1,'last');
            if ~isempty(indexVizinhos)
                vizinhoAtual = listaVizinhos(1,indexVizinhos);
                V_Vn = neighbors(grafo,string(vizinhoAtual));
                if (length(V_Vn) ~= 1)
                    for r=1:length(V_Vn) %remove todos os vizinhos do Vizinho atual, exceto o ID
                        if (ID ~= str2num(V_Vn(r)))
                            if isempty(listaDoisSaltos(listaDoisSaltos == str2num(V_Vn(r))))
                                listaDoisSaltos = [listaDoisSaltos str2num(V_Vn(r))];
                                if isempty(listaVizinhos(listaVizinhos == str2num(V_Vn(r))))
                                    grafo = rmnode (grafo,V_Vn(r));
                                end
                                if isempty(lMPR(lMPR==vizinhoAtual))
                                    lMPR = [lMPR vizinhoAtual];
                                end
                            end
                        end
                    end
                end
            else
                lMPR = [];
            end
            grafo = rmnode(grafo,string(vizinhoAtual)); %   Remove o vizinho atual do grafo temporário 
        end
    end
end
