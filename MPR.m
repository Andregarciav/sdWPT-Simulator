function [lMPR] = mpr (obj)
    v = neighbors(obj.g, string(obj.ID));
    lista = zeros(numnodes(obj.g)); %Cria a Lista independente de vizinhos
    M_AD = full(adjacency(obj.g));
    lMPR = [];
    V_vn = [];
    vizinho = false;
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
                if(M_AD(findnode(obj.g,string(m(r))),s)==1 && s ~= obj.ID)
                    if isempty(m(m==s))
                        lista(m(r),t) = s;
                        t = t+1;
                    end
                end
            end
        end
        %Listas de vizinhos de vizinhos pronta
        for r=1:length(v)
            mv(r) = sum ( lista(findnode(obj.g,v(r)),:)~=0);
        end
        %m = [m;mv] não é bom concatenar, fica mais fácil manipular
        while ~(isempty(m))
            mpr1 = find (mv==max(mv), 1, 'last'); % acha a posição do nó que tem mais visinhos
            if isempty(V_vn) && mv(mpr1)~=0
                lMPR = [lMPR m(mpr1)]; %Add a lista de MPR
                for r=1:length(M_AD)
                    if (lista(m(mpr1),r)~=0)
                        V_vn = [V_vn lista(m(mpr1),r)];
                    end
                end
            elseif ~isempty(V_vn) && mv(mpr1)~=0
                for r=1:length(M_AD)
                    if (lista(m(mpr1),r)~=0 && isempty(find (V_vn == lista(m(mpr1),r),1)))
                        V_vn = [V_vn lista(m(mpr1),r)];
                        vizinho = true;
                    end
                end
                if vizinho == true
                    lMPR = [lMPR m(mpr1)]; %Add a lista de MPR
                    vizinho = false;
                end
            end
            m(mpr1) = [];
            mv(mpr1) = [];
        end
    elseif(length(v)==1)
        lMPR = [v]; %transformar em lista de MPR
    elseif(length(v)==0)
        lMPR = []; %transformar em lista de MPR
    end

end