%   Arquivo para testar a função MPR gerando um grafo aleatório
clear;
clc;
%   Cria um grafo
g = graph;
tamGrafo = 10;   %   Controla o tamanho do grafo
ID = 5;         %   Nó Raiz
%   Adicionando vértices ao grafo
%   Para ficar mais real cada vértice recebe um nome = ao seu ID
for r=1:tamGrafo
    if rand > 0 %   Controla a probabilidade
        g = addnode(g, string(r));
    end
end
%   Testa de o nó raiz existe no grafo, caso não exita cria
if findnode(g,string(ID)) == 0
    g = addnode(g, string(ID));
end
%   Adicionando Arestas aleatórias ao grafo
for r=1:randi([5 tamGrafo*2.5])
    a = num2str(randi([1 tamGrafo]));
    b = num2str(randi([1 tamGrafo]));
    if (str2num(a)~=str2num(b))
        if  findnode (g,a)~=0 && findnode(g,b) ~= 0
            if((findedge(g,a,b)==0) && (findedge(g,b,a)==0)) %testa se aresta já existe para não duplicar aresta
                g = addedge(g, a, b);
            end
        end
    end
end

figure(1)
    plot(g)

%   Chama função MPR
lMPR = mpr(g,ID)
%   Verifica se todos os vizinhos a dois saltos, estão cobertos pela lista de mpr
verificaMPR(g,ID,lMPR)

    
    
    
