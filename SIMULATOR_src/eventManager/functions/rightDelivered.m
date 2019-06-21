function r = rightDelivered(message,messageLists,WPTManager,...
    B_SWIPT,B_RF,A_RF,N_SWIPT,N_RF,Z)
	
    %TODO: descontar a energia gasta
    r = true;
    out = false;
    nSamples = 10;

    step = (message.time1-message.time0)/nSamples;
    
    t = message.time0 + step;
    
    while((t<message.time1)&&(~out))
        
        %encontra a lista de eventos que conflitam com message no
        %momento t
        conflictList = [];
        for i=1:length(messageLists)
            %para cada agente potencialmente conflitante
            while(true)
                if(isempty(messageLists(i).events))
                    %se não há mais eventos desse agente
                    break
                end
                if(t>messageLists(i).events(1).time0)
                    %se o momento em destaque está após o início o 
                    %evento que encabeça a lista desse agente
                    if(t<messageLists(i).events(1).time1)
                        %se está dentro desse evento, adicione na 
                        %lista de conflitos instantâneos
                        conflictList = [conflictList,...
                            messageLists(i).events(1)];
                        break;
                    else
                        %passe para o próximo evento
                        messageLists(i).events = messageLists(i).events(2:end);
                    end
                else
                    %esse momento é anterior ao início do evento
                    %que encabeça a lista desse agente
                    break;
                end
            end
        end
        switch(message.options.type)
            case 0 %vlc
                SINR = SINR_VLC(WPTManager,message,...
                    conflictList,t,nSamples);
                if(SINR<B_SWIPT)
                    r = false;
                    out = true;
                end
            otherwise %RF
                SINR = SINR_RF(WPTManager,message,conflictList,...
                    A_RF,N_RF,t);
                if(SINR<B_RF)
                    r = false;
                    out = true;
                end
        end
        t = t + step;
    end
    % if r
    %     disp(['Entregue: from ',num2str(message.creator),' to ',num2str(message.owner)])
    % else
    %     disp(['Nao entregue: from ',num2str(message.creator),' to ',num2str(message.owner)])
    % end
end
