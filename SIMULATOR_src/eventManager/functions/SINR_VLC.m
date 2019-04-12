%PARAMETROS:
%nSamples: qtd de vezes que essa função é chamada para uma mensagem
function SINR = SINR_RF(WPTManager,message,conflictList,t,nSamples)
% Adquirindo posição e orientação de troca de msg
    %centro do Objeto
    pos = getCenterPositions(WPTManager.ENV,t);
    % Orientação da normal
    Ori = getOrientations(WPTManager.ENV,t);

    % Atenção aos nomes
    Vs = Ori(message.creator+1,:); %Normal ao Plano do emissor
    Vr = Ori(message.owner+1,:); %Normal ao plano do Receptor
    Cs = pos(message.creator+1,:); %Centro do Emissor
    Cr = pos(message.owner+1,:); %Centro do Receptor
    Vrs = Cs - Cr; % Vetor em Cr que aponta para Cs, ou seja vetor que aponta do receptor para o emissor
    Vsr = Cr - Cs; % Vetor em Cs que aponta para Cr, ou seja vetor que aponta do emissor para o receptor
    %Lambda do receptor e do emissor
    Lambda_recieve = calculateLambda(Cr,Vr,Cs);
    Lambda_transmissor = calculateLambda(Cs,Vs,Cr);
    if ((Lambda_recieve < 0  ||  Lambda_recieve > 1) && (Lambda_transmissor < 0  ||  Lambda_transmissor > 1))     % Caso os valores os lambdas fiquem entre 0 e 1,
    % Distância entre os nós                                                                                      % significa que o raio luminoso de sinal cruzou
        d = norm(Cs-Cr);                                                                                          % o plano do receptor.
    %Calculando parametros cossenos
        %cos_FI = (Cs(3) - Cr(3)) / d
        cos_FI =  dot(Vs,Vsr)/(norm(Vs) * norm(Vsr));
        cos_teta = dot(Vr,Vrs)/(norm(Vr) * norm(Vrs));
    % Parametros adquiridos de artigo
        half_power_angle = 60 * (pi/180); % Ângulo de meia potência
        detector_surface = 1e-4; % area do fotodiodo
    %calculando a radiação
        m = log(0.5)/log(cos(half_power_angle)); %Constante de emissão de Lambert ~1.
        radiation = ((m+1) * (cos_FI)^m) / 2*pi %Radiação dependente do angulo do emissor
    %Ganho DC
        dc_gain = radiation * (detector_surface/d^2)*cos_teta;  % Ganho do foto receptor deve ser acima de 0.00063662
        
        if (dc_gain < 0.00063662)
            SINR = 0;
        else
            prob = ([88.53 80 60 40 20 0]/100).^(1/nSamples); % Probabilidade do pacote ser entregue
            dista = [0 10 354 425 462 500]; % Distância de  transmissão em cm

            p = interp1 (dista, prob, norm(Cs-Cr), 'pchip'); %interpolação entre os dados probabilisticos recolhidos empiricamente
            
            if (rand < p)
                SINR = 1;
            else
                SINR = 0;
            end
        end
    else
        SINR = 0;
    end


    Receive_Angle = dot(Ori(message.owner+1,:),pos(message.creator+1,:)-pos(message.owner+1,:))...
                    / norm(Ori(message.owner+1,:)) * norm(pos(message.creator+1,:)-pos(message.owner+1,:));
    
    Vr = calculateLambda(pos(message.owner+1,:), Ori(message.owner+1,:), pos(message.creator+1,:));
    if (Vr < 0) && (Vr > 1)
        disp(['VR',Vr])
    end

    

    if (rand < p) && ((Lambda_recieve < 0  ||   Lambda_recieve > 1) && (Lambda_transmissor < 0  ||   Lambda_transmissor > 1))
        SINR = 1;
    else
        SINR = 0;
    end

end


% pos(message.creator+1,:) -> Todas as posições
% pos(message.creator+1,1) -> Coordenada x
% pos(message.creator+1,2) -> Coordenada y
% pos(message.creator+1,3) -> Coordenada z


%Probabilidades de acordo com a distancia

% Probabilidade 88.53%  para 10 cm -- Análise do impacto de diferentes cores na transmissão de
    % dados por luz visível em dispositivos embarcados baseados em LEDs

