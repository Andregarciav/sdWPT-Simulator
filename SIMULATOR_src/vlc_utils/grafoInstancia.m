%Essa função gera o grafo com todos os nós da instância
function [instancia] = grafoInstancia (LOG)
    instancia = graph;
    nodes = [];
    arestas = [];

    %captura todos os nós do grafo
    for r=2:length(LOG)
        for i=1:size(LOG(r).DATA.g.Nodes.Name)
            temp = cell2mat(LOG(r).DATA.g.Nodes.Name(i));
            if isempty(nodes(nodes == str2num(temp)))
                nodes = [nodes str2num(temp)];
            end
        end
    end

    %captura as arestas do grafo
    for r=2:length(LOG)
            temp = (LOG(r).DATA.g.Edges);
            arestas = [arestas;temp];
    end

    %Add os nos e arestas no grafo
    for r=1:length(nodes)
        instancia = addnode(instancia, string(nodes(r)));
    end
    table2array(arestas);
    for r=1:height(arestas)
        temp = table2array(arestas(r,1));
        instancia = addedge(instancia, cell2mat(temp(1)), cell2mat(temp(2)));
    end

    instancia = simplify(instancia);