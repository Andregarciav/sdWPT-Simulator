 %(THIS IS AN EXAMPLE FOR THE ONES WHO WANT TO USE THIS SIMULATOR AS A SIMPLE NETWORK SIMULATOR.)
% clear all;

savefile = true;%salvar depois da execução?
plotAnimation = true;%mostrar a animação?

file = 'env_vlc_40nodes_rand.mat';%arquivo para onde irão os ambientes

%Parâmetros DUMMIE------------------------------------------------------------------------------------------------
w = 1e+5;%frequência angular padrão (dummie)
mi = pi*4e-7; %(dummie)

%Criação de bobinas dummie

R = 0.01;%raio
N = 2;%número de espiras
pitch= 0.001;%espaçamento entre as espiras
wire_radius = 0.0004;%espessura do fio (raio)
pts = 2; %resolução do caminho


%-------------------------------------------------------------------------------------------------------------------

%AQUI É ONDE VOCÊ VAI MEXER DE FATO!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%coordenadas da posição em metros
group_list = [];

%definindo um nó (esse é o powerTX, não altere, pois não será usado)
x = 0;
y = 0;
z = 0;
group.coils.obj = translateCoil(SolenoidCoil(R,N,pitch,...
    wire_radius,pts,mi),x,y,z);
group.R = -1;group.C = -1;
group_list = [group_list;group];


for i=1:40
    center = [5*rand, 5*rand, 5*rand];
    normal = [5*rand, 5*rand, 5*rand];
    group.coils.obj = VlcNode(center, normal);
    group.R = -1;group.C = -1;
    group_list = [group_list;group];
end


%FIM DA SUA ÁREA DE ATUAÇÃO!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

%w = 1e+5 é apenas um valor default. A frequência é de fato definida a posteriori   
envPrototype = Environment(group_list,w,mi);

envList = [envPrototype,envPrototype];

ok = check(envPrototype);

if(ok)
    
    envList(1) = evalM(envList(1), zeros(length(group_list)));
    envList(2) = evalM(envList(2), zeros(length(group_list)));

    if savefile
        save(file,'envList');
    end

    if plotAnimation
        %animation(envList,0.05,0.2);
        figure()
            hold on
            for i=2:length(group_list)
                plotCoil(group_list(i).coils.obj)
            end
    end
else
    error('Something is wrong with the environments.')
end