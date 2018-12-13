function SINR = SINR_RF(WPTManager,message,conflictList,t)
% Adquirindo posição e orientação de troca de msg
    pos = getCenterPositions(WPTManager.ENV,t);
    Ori = getOrientations(WPTManager.ENV,t);

% Parametros adquiridos de artigo
    Fi_half = 60; %Angulo de emissão da sinal
    m = log(0.5)/log(cos(Fi_half * pi / 180));
    A = 1e-4; % area do fotodiodo

% Distância entre os nós
    d = norm(pos(message.creator+1,:)-pos(message.owner+1,:));
% Ângulo entre transmissor e receptor
    Trasnmissor_Angle = (pos(message.creator+1,3)-pos(message.owner+1,3) / d);
% Parâmetro R de fi
    R_fi = ((m + 1) * (Trasnmissor_Angle)^m) / 2 * pi;

    Receive_Angle = dot(Ori(message.owner+1,:),pos(message.creator+1,:)-pos(message.owner+1,:))...
                    / norm(Ori(message.owner+1,:)) * norm(pos(message.creator+1,:)-pos(message.owner+1,:));
 

    H_0 = R_fi * (A/d^2) * Receive_Angle;

    prob = [88.53 80 60 40 20 0]/100;
    dista = [0 10 354 425 462 500];

    p = interp1 (dista, prob, d);

    if (rand < p) && (Receive_Angle < 0.5)
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

