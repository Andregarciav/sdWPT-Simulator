function SINR = SINR_RF(WPTManager,message,conflictList,t)

    pos = getCenterPositions(WPTManager.ENV,t);
    Fi_half = 60; %Angulo de emissão da sinal
    m = ln(0.5)/ln(cos(Fi_half));
    A = 10^(-4) % area do fotodiodo
    d = norm(pos(message.creator+1,:)-pos(message.owner+1,:))

    Trasnmissor_Angle = (z.message.creator - z.message.receive) / d);

    R_fi = ((m + 1) * (Trasnmissor_Angle)^m) / 2 * pi;

    Receive_Angle = produto_escalar(direção.message.creator,direção.message.owner) / norm