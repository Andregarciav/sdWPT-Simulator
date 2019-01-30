clear all;

for r=1:2000000
    ori = [0 0 1];
    center = [0 0 0];
    Ponto = [5*rand 5*rand (11*rand+0.1)];

    lam = calculateLambda(center, ori, Ponto);

    disp (lam)
    if (lam > 0) && (lam < 1)
        disp('Corta o plano')
    else
        error('Não corta o plano');
    end
end