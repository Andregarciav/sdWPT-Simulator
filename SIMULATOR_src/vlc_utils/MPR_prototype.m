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

v = neighbors(g, string(ID))
lista = zeros(numnodes(g)) %Cria a Lista independente de vizinhos
M_AD = full(adjacency(g))
lMPR = [];
V_vn = [];
vizinho = false
%Obtendo um vetor de numeros ao invez de um vetor de strings
m = [];
for h=1:length(v)
    m = [m str2num(v(h))];
end
m;
mv = 0*[1:length(v)];
if (length(v)>1) %caso tenha mais de um vizinho, constroi a lista de vizinhos
    for r=1:length(v) %Para cada vizinho, verifica os vizinhos
        t=1;
        for s=1:length(M_AD)
            if(M_AD(m(r),s)==1 && s ~= ID)
                if isempty(m(m==s))
                    lista(m(r),t) = s;
                    t = t+1;
                end
            end
        end
    end
    %Listas de vizinhos de vizinhos pronta
    for r=1:length(v)
        mv(r) = sum ( lista(str2num(v(r)),:)~=0);
    end
    %m = [m;mv] não é bom concatenar, fica mais fácil manipular
    while ~(isempty(m))
        mpr = find (mv==max(mv), 1, 'last') % acha a posição do nó que tem mais visinhos
        if isempty(V_vn) && mv(mpr)~=0
            lMPR = [lMPR m(mpr)]; %Add a lista de MPR
            for r=1:length(M_AD)
                if (lista(m(mpr),r)~=0)
                    V_vn = [V_vn lista(m(mpr),r)]
                end
            end
        elseif ~isempty(V_vn) && mv(mpr)~=0
            for r=1:length(M_AD)
                if (lista(m(mpr),r)~=0 && isempty(find (V_vn == lista(m(mpr),r),1)))
                    V_vn = [V_vn lista(m(mpr),r)];
                    vizinho = true;
                end
            end
            if vizinho == true
                lMPR = [lMPR m(mpr)]; %Add a lista de MPR
                vizinho = false;
            end
        end
        m(mpr) = [];
        mv(mpr) = [];
    end
elseif(length(v)==1)
    lMPR = [v]; %transformar em lista de MPR
elseif(length(v)==0)
    lMPR = []; %transformar em lista de MPR
end



    
    
    
