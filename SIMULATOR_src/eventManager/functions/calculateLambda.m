function lambda = calculeLambda(c,n,a)
    

%    gamaX = Transmissor(1)*Center(1) - Center(1)*Position(1)...
%            - Position(1)*Transmissor(1) + Position(1)^2;

%    gamaY = Transmissor(2)*Center(2) - Center(2)*Position(2)...
%            - Position(2)*Transmissor(2) + Position(2)^2;

%    gamaZ = Transmissor(3)*Center(3) - Center(3)*Position(3)...
%            - Position(3)*Transmissor(3) + Position(3)^2;

%    BetaX = Center(1)^2 - Transmissor(1)*Center(1)...
%            - Center(1)*Position(1) - Position(1)*Transmissor(1);
    
%    BetaY = Center(2)^2 - Transmissor(2)*Center(2)...
%            - Center(2)*Position(2) - Position(2)*Transmissor(2);

%   BetaZ = Center(3)^2 - Transmissor(3)*Center(3)...
%            - Center(3)*Position(3) - Position(3)*Transmissor(3);
    
%    lambda =  - (gamaX + gamaY + gamaZ) / BetaX + BetaY + BetaZ;
    lambda = ((n*c.') - (n*a.')) / ((n*(n+c).') - (n*a.'));
end