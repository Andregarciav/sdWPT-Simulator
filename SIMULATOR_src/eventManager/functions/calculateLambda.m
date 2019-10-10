function lambda = calculeLambda(c,n,a)
    %   Função Retorna 1 caso o
    %   emissor e receptor não
    %   estejam de costas um para o outro
    temp;
    temp = ((n*c.') - (n*a.')) / ((n*(n+c).') - (n*a.'));
    if (temp < 0 || temp > 1)
        lambda = 1;
    else 
        lambda = 0;
    end

end