clear;
clc;

g = graph;

for r=1:8
    g = addnode(g, string(r));
end

for r=1:randi([5 20])
    a = num2str(randi([1 8]));
    b = num2str(randi([1 8]));
    
    if((findedge(g,a,b)==0) && findedge(g,b,a)==0 && a~=b)
        g = addedge(g, a, b);
    end
end
figure(1)
    plot(g)

ID = 5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Aqui começa o MPR     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

v = neighbors(g, string(ID));
lista = zeros(numnodes(g)); %Cria a Lista independente de vizinhos
M_AD = full(adjacency(g));
lMPR = [];

if (length(v)>1) %caso tenha mais de um vizinho, constroi a lista de vizinhos
    for r=1:length(M_AD)
        if(M_AD(ID,r)) == 1
            for s=1:length(M_AD)
                if(M_AD(r,s)) == 1 && (M_AD(ID,r) || M_AD(r,ID) ~= 1)
                    lista(r,1) = r;
                end
            end
        end
    end
    for r=1:length(M_AD) %Para cada vizinho, verifica os vizinhos
        if(lista(r,1) ~= 0)
            t=2;
            for s=1:length(M_AD)
                if(M_AD(r,s)==1 && s ~= ID)
                    lista(r,t) = s;
                    t = t+1;
                end
            end
            %end
        end
    end
    for r=1:length(v)
        if(lista(v(r),1) ~= 0)

        end
    end
    lista
elseif(length(v)==1)
    lMPR = [v]; %transformar em lista de MPR
elseif(length(v)==0)
    lMPR = []; %transformar em lista de MPR
end


%for r=1:length(v)
    
    
    
