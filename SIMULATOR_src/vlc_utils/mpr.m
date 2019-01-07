function [lMPR] = mpr (obj)
    teste = true;
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
    if teste == true
        lMPR = m;
    else
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
            lista;
            %Listas de vizinhos de vizinhos pronta
            for r=1:length(v)
                mv(r) = sum ( lista(findnode(obj.g,v(r)),:)~=0);
            end
            %m = [m;mv] não é bom concatenar, fica mais fácil manipular
            while (isempty(m) == 0)
                mpr1 = find (mv==max(mv), 1, 'last'); % acha a posição do nó que tem mais visinhos
                if mv(mpr1)~=0 % && isempty(find(lMPR, m(mpr1)))
                    %if isempty(V_vn)
                    %    lMPR = [lMPR m(mpr1)]; %Add a lista de MPR
                    %    for r=1:length(M_AD)
                    %        if (lista(m(mpr1),r)~=0)
                    %            V_vn = [V_vn lista(m(mpr1),r)];
                    %        end
                    %    end
                    %else
                        for r=1:length(M_AD)
                            if (lista(m(mpr1),r)~=0)
                                if isempty(V_vn == lista(m(mpr1),r))
                                    V_vn = [V_vn lista(m(mpr1),r)];
                                    vizinho = true;
                                end
                            end
                        end
                        if vizinho == true
                            if isempty(find(lMPR, m(mpr1)))
                                lMPR = [lMPR m(mpr1)]; %Add a lista de MPR
                            end
                            vizinho = false;
                        end
                    %end
                end
                m(mpr1) = [];
                mv(mpr1) = [];
            end
        end
    end
    if(length(v)==1)
        h = neighbors(obj.g,v(1)); 
        if length(h) > 1
            lMPR = [str2num(v(1))]; %transformar em lista de MPR
        end
    end
    if(length(v)==0)
        lMPR = []; %transformar em lista de MPR
    end

end