classdef VlcNode < coil
    methods
        %   criando um objeto de Nó VLC
        %   Como parâmetros recebe dois vetores, o centro do Nó e a diração
        %   da Normal
        function obj = VlcNode(Centro,Normal)
            x=[0,Normal(1)-Centro(1)];
            y=[0,Normal(2)-Centro(2)];
            z=[0,Normal(3)-Centro(3)];
            obj@coil(x,y,z,0);
            obj = translateCoil(obj,Centro(1),Centro(2),Centro(3));
        end

        function r = check(obj)
            r = true;
        end

        function plotCoil(obj)
            cor = ['r','g','b','m','y','k','c'];
            number = randi([1,length(cor)]);
            plot3(obj.X, obj.Y, obj.Z, ['o', cor(number)]);
            plot3(obj.x, obj.y, obj.z, ['-', cor(number)]);
        end
    end
end