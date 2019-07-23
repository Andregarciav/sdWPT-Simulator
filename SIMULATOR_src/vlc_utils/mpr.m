%   Essa função recebe uma topologia e retorna
%   A lista de nós MPR a partir do nó origem

function [lMPR] = mpr (g,ID)
    lMPR = [];
    v = neighbors(g, string(ID));
    if length(v) == 0
        lMPR = [];
    elseif length(v) == 1
        if length(neighbors(g,v(1))) > 1
            lMPR = [str2num(v(1))];
        else
            lMPR = [];
        end
    elseif length(v) > 1
        grafo = g;
        listaDoisSaltos = [];
        while ~(isempty(neighbors(grafo, string(ID))))
            vizinhosTemp  = neighbors(grafo, string(ID));
            listaVizinhos = [];
            for h=1:length(vizinhosTemp)
                listaVizinhos = [listaVizinhos [str2num(vizinhosTemp(h));degree(grafo,vizinhosTemp(h))]];
            end
            ListaArestas = listaVizinhos(2,:);
            indexVizinhos = find(ListaArestas == max (ListaArestas),1,'last');
            if ~isempty(indexVizinhos)
                vizinhoAtual = listaVizinhos(1,indexVizinhos);
                V_Vn = neighbors(grafo,string(vizinhoAtual));
                if (length(V_Vn) ~= 1)
                    for r=1:length(V_Vn)
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
            grafo = rmnode(grafo,string(vizinhoAtual));
        end
    end
end
