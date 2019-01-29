clear all;

for r=1:2000000
    ori = [5*rand 5*rand 5*rand];
    center = [0 0 0];
    Ponto = [5*rand 5*rand (-11*rand+0.1)];

    lam = calculateLambda(ori, center, Ponto);

    disp (lam)
    if (lam > 0) && (lam < 1)
        disp('Se fu')
    else
        error('lillilil');
    end
end