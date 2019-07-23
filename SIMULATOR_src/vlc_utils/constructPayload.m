% Esta função constroi o payload a ser enviado com todos
% os vizinhos do nó atual. 

function [pkt] = constructPayload (obj)
    v = neighbors(obj.g,string(obj.ID));
    pkt = [];
        if ~isempty(v)
            for r=1:length(v)
                pkt = [pkt string(v(r))];
            end
        else
            pkt = [''];
        end
end