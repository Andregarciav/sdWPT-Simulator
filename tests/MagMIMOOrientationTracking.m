%cria um conjunto de bobinas sobre um sistema magmimo e mantem a distância
%constante, rotacionando a receptora de 0 a 90 graus (eixo x)

%savefile = salvar depois da execução?
%plotAnimation = mostrar a animação?
%evalMutualCoupling = calcular as interações das bobinas? (operação custosa)
%file = arquivo .mat para onde irão os ambientes
%d = distância
%M0 = matriz de indutância pré-processada
%nFrames = quantidade de frames a serem calculados

function M = MagMIMOOrientationTracking(savefile, plotAnimation, evalMutualCoupling,...
	file,d,M0,nFrames,nthreads)
	
	M = [];

	w = 1e+5;%frequência angular padrão (dummie)
	mi = pi*4e-7;
	
	ntx = 6;
	
	%Dimensões das bobinas transmissoras
	R2_tx = 0.1262;%raio externo, de forma a gerar uma area de 0.05m2
	N_tx = 17;%número de espiras
	wire_radius_tx = 0.0015875;%espessura do fio (m) diam = 1/8''
	R1_tx = R2_tx-4*N_tx*wire_radius_tx;%raio interno

	%Dimensões das bobinas receptoras
	R2_rx = 0.04;%raio externo, de forma a gerar uma area de 0.005m2
	N_rx = 25;%número de espiras (chute, apenas por gerar um disco quase completo)
	wire_radius_rx = 0.00079375;%espessura do fio (m) diam = 1/16''
	R1_rx = R2_rx-2*N_rx*wire_radius_rx;%raio interno

	pts = 750;%resolução de cada bobina

	stx = 0.04;%espaçamento entre os transmissores (aproximadamente, de acordo com
	%a ilustração do artigo. Para gerar uma área de 0.3822m2 deve ser 0.0

	coilPrototypeRX = SpiralPlanarCoil(R2_rx,R1_rx,N_rx,wire_radius_rx,pts);
	coilPrototypeTX = SpiralPlanarCoil(R2_tx,R1_tx,N_tx,wire_radius_tx,pts);

	group1.coils.obj = translateCoil(coilPrototypeTX,-R2_tx-stx/2,+2*R2_tx+stx,0);
	group1.R = -1;group1.C = -1;

	group2.coils.obj = translateCoil(coilPrototypeTX,-R2_tx-stx/2,0,0);
	group2.R = -1;group2.C = -1;

	group3.coils.obj = translateCoil(coilPrototypeTX,-R2_tx-stx/2,-2*R2_tx-stx,0);
	group3.R = -1;group3.C = -1;

	group4.coils.obj = translateCoil(coilPrototypeTX,+R2_tx+stx/2,+2*R2_tx+stx,0);
	group4.R = -1;group4.C = -1;

	group5.coils.obj = translateCoil(coilPrototypeTX,+R2_tx+stx/2,0,0);
	group5.R = -1;group5.C = -1;

	group6.coils.obj = translateCoil(coilPrototypeTX,+R2_tx+stx/2,-2*R2_tx-stx,0);
	group6.R = -1;group6.C = -1;                

	group7.coils.obj = translateCoil(coilPrototypeRX,0,0,d);
	group7.R = -1;group7.C = -1;

	groupList = [group1;group2;group3;group4;group5;group6;group7];

	envPrototype = Environment(groupList,w,mi);

	envList = envPrototype;
	
	for i=2:nFrames
		aux = [];
		for j=ntx+1:length(groupList)
			teta = (pi/2)*(i-1)/(nFrames-1);
			dz = abs(sin(teta)*R2_rx);
			c = translateCoil(envList(1).Coils(j).obj,0,0,dz);
		    group.coils.obj = rotateCoilX(c,teta);
		    group.R = -1;group.C = -1;
		    aux = [aux group];
		end
		envList = [envList Environment([groupList(1:ntx).' aux],w,mi)];
	end

	ok = true;
	for i=1:length(envList)
		ok = ok && check(envList(i));
	end

	if(ok)
		if evalMutualCoupling
			%first frame
			disp('Starting first frame');
		    envList(1) = evalM(envList(1),M0);
		    M = envList(1).M;
		    
		    M1 = [	M(1:6,1:6),	-ones(6,1);
					-ones(1,6),	-1			];
			%be sure that unchanged values will not be recalculated
			%(both tx submatrix and values from M0)
			M0 = M1 + (M0~=-1).*(M0-M1);
			
			%calculate the rest of the frames
		    disp('Starting the rest of the frames');
		    parfor(i=2:length(envList),nthreads)
		        envList(i) = evalM(envList(i),M0);
		        disp(['Frame ',num2str(i),' concluido'])
		    end
		end

		if savefile
		    save(file,'envList');
		end

		if plotAnimation
		    plotCoil(coilPrototypeTX);
		    figure;
		    plotCoil(coilPrototypeRX);
		    figure;
		    animation(envList,0.05,0.2);
		end
		
		disp('Calculations finished');
	else
		error('Something is wrong with the environments.')
	end
end
