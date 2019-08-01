%(THIS IS AN EXAMPLE FOR THE ONES WHO WANT TO USE THIS SIMULATOR AS A SIMPLE NETWORK SIMULATOR.)
clear all;

savefile = true;%salvar depois da execução?
plotAnimation = true;%mostrar a animação?

file = 'env_vlc_2_100.mat';%arquivo para onde irão os ambientes

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
group_list_inicio = [];

%definindo um nó (esse é o powerTX, não altere, pois não será usado)
x = 0;
y = 0;
z = 0;
group.coils.obj = translateCoil(SolenoidCoil(R,N,pitch,...
    wire_radius,pts,mi),x,y,z);
group.R = -1;group.C = -1;
group_list_inicio = [group_list_inicio;group];

%definindo nó 1
center = [0.25,0,0];
normal = [0.26,0,0];
group.coils.obj = VlcNode(center, normal);
group.R = -1;group.C = -1;
group_list_inicio = [group_list_inicio;group];

%definindo nó 2
center = [1.25,0,0];
normal = [1.24,0,0];
group.coils.obj = VlcNode(center, normal);
group.R = -1;group.C = -1;
group_list_inicio = [group_list_inicio;group];

% group_list_fim = group_list_inicio;
% group_list_fim(3).coils.obj = translateCoil(group_list_fim(3).coils.obj,0,5.25,0);

%FIM DA SUA ÁREA DE ATUAÇÃO!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

%w = 1e+5 é apenas um valor default. A frequência é de fato definida a posteriori   
env_inicio = Environment(group_list_inicio,w,mi);
ok_inicio = check(env_inicio);

% env_fim = Environment(group_list_fim,w,mi);
% ok_fim = check(env_fim);

envList = [env_inicio,env_inicio];

if(ok_inicio)
    
    envList(1) = evalM(envList(1), zeros(length(group_list_inicio)));
    envList(2) = evalM(envList(2), zeros(length(group_list_inicio)));

    if savefile
        save(file,'envList');
    end

    if plotAnimation
        animation(envList,0.05,0.2);
    end
else
    error('Something is wrong with the environments.')
end
