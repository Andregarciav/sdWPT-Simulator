%Mostra a anima��o da movimenta��o das bobinas em uma ambiente ao longo do
%tempo
function animation(eList,dtime,ds)
    h = scatter3(NaN,NaN,NaN,'filled'); %initiallize plot. Get a handle to graphic object
    
    X = [];Y = [];Z = [];
    for i=1:length(eList)
        for j=1:length(eList(i).Coils)
            X = [X eList(i).Coils(j).obj.x];
            Y = [Y eList(i).Coils(j).obj.y];
            Z = [Z eList(i).Coils(j).obj.z];
        end
    end
    
    axis([min(X)-ds max(X)+ds min(Y)-ds max(Y)+ds min(Z)-ds max(Z)+ds]); %freeze axes
    %to their final size, to prevent Matlab from rescaling them1 dynamically
    quit = false;
    while ~quit
        for i = 1:length(eList)
            pause(dtime)
            px = [];
            py = [];
            pz = [];
            for j=1:length(eList(i).Coils)
                px = [px eList(i).Coils(j).obj.x];
                py = [py eList(i).Coils(j).obj.y];
                pz = [pz eList(i).Coils(j).obj.z];
            end
			try
                set(h, 'XData', px, 'YData', py, 'ZData', pz);
                %patch([px nan],[py nan],[pz nan],[pz nan],'EdgeColor','interp','FaceColor','none')
				drawnow %you can probably remove this line, as pause already calls drawnow
			catch
				quit = true;
				break;
			end
        end
    end
end
