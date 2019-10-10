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
    %teste se emissor e receptor não estão de costas
    if (Lambda_recieve && Lambda_transmissor)                                                                                      
        d = norm(Cs-Cr);                                                                                          % 
        %Calculando parametros cossenos
        %cos_FI = (Cs(3) - Cr(3)) / d
        cos_FI =  dot(Vs,Vsr)/(norm(Vs) * norm(Vsr));
        cos_teta = dot(Vr,Vrs)/(norm(Vr) * norm(Vrs));
        % Parametros adquiridos de artigo
        half_power_angle = 60 * (pi/180); % Ângulo de meia potência
        detector_surface = 1e-4; % area do fotodiodo
        %calculando a radiação
        m = log(0.5)/log(cos(half_power_angle)); %Constante de emissão de Lambert ~1.
        radiation = ((m+1) * (cos_FI)^m) / 2*pi; %Radiação dependente do angulo do emissor
        %Ganho DC
        dc_gain = radiation * (detector_surface/d^2)*cos_teta; % Ganho do foto receptor deve ser acima de 0.00063662
        
        % if (dc_gain < 0.00063662)
        %     SINR = 0;
        % else
            prob = ([88.53 80 60 40 20 0]/100).^(1/nSamples); % Probabilidade do pacote ser entregue
            dista = [0 10 354 425 462 500]/100; % Distância de  transmissão em cm

            regre = polyfit (dista, prob, 5);% Gera os coeficientes da regressão polinomial

            x = sqrt(radiation* detector_surface / dc_gain);
            %p = interp1 (dista, prob, d, 'pchip'); %interpolação entre os dados probabilisticos recolhidos empiricamente
            pro = regre(1)*x.^5 + regre(2)*x.^4 + regre(3)*x.^3 + regre(4)*x.^2 + regre(5)*x +regre(6);

            if (rand <= pro)
                SINR = 1;
            else
                SINR = 0;
            end
        % end
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

