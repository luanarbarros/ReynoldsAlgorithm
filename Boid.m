classdef Boid < handle
    properties
        Position;
        Direction;
        Speed;
        
        % Vari�veis para armazenar corre��es
        DistToBoids; % dist�ncia at� os outros boids
        DispFromBoids; % vetor "s" (separa�ao)
        DispFromObstacle; % dist�ncia do obst�culo
        AlignmentCorrection; % vetor "m" (alinhamento)
        AttractionCorrection; % vetor "k" (coes�o)
        
        % Vari�veis para atualiza��o das sprites (gr�fico)
        Sprite;
        SpriteType;
        H;
    end
    
    methods
    % Constructor
        function obj = Boid()
            obj.Position = floor(rand(1, 2).*Config.Area);
            initialDirection = rand(1, 2).*2 - 1;
            obj.Direction = initialDirection/norm(initialDirection);
            obj.Speed = 10*(2 - rand);
            obj.DistToBoids = zeros(Config.BoidsQty,1);
            obj.DispFromBoids = [0 0];
            obj.DispFromObstacle = [0 0];
            obj.AlignmentCorrection = [0 0];
            obj.AttractionCorrection = [0 0];
            initSprite = randi([0 1]);
            obj.SpriteType = initSprite;
        end
        
        % Atualiza a posi��o e a dire��o do boid
        function updateBoids(obj, boids, obstacles)
            obj.updateRepultion(boids);
            obj.updateDistanceToObstacle(obstacles);
            obj.updateAlignment(boids);
            obj.updateAttraction(boids);
            
            obj.Direction = obj.Direction() ...
                            + obj.DispFromBoids*Config.kSeparation ...
                            + obj.AlignmentCorrection*Config.kAlignment ...
                            + obj.AttractionCorrection*Config.kCohesion ...
                            + 10*obj.DispFromObstacle;
            obj.Direction = obj.Direction/norm(obj.Direction);
            
            obj.Position = round(obj.Position ...
                                + obj.Direction.*obj.Speed ...
                                + randn(1,2).*obj.Speed*0.1);
                            
            obj.Position = mod(obj.Position, Config.Area(2));
        end
        
        % Calcula o vetor de separa��o (vetor "s")
        function updateRepultion(obj, boids)
            
            for i=1:Config.BoidsQty
                obj.DistToBoids(i) = norm(obj.Position - boids(i).Position); 
            end
            
            repulsionIndex = find(obj.DistToBoids>0 & obj.DistToBoids<=Config.RepulsionRadius);
            repulsionQty = length(repulsionIndex);
            
            obj.DispFromBoids = [0 0];
            
            if repulsionQty > 0
                position = zeros(1, 2);
                for i = 1 : repulsionQty
                    position = position + boids(repulsionIndex(i)).Position;
                end
                position = (position ./ repulsionQty);  
                obj.DispFromBoids = obj.Position - position;
            end
        end
        
        % Calcula o deslocamento de acordo com a posi��o do obst�culo
        function updateDistanceToObstacle(obj, obstacle)
            obj.DispFromObstacle = obj.Position - obstacle.Position;
            distToObstacle = norm(obj.DispFromObstacle);
            if distToObstacle < obstacle.ActDistance
                if obj.Position(2) > obstacle.Position(2)
                    obj.DispFromObstacle = obj.DispFromObstacle + [50 50];
                else
                    obj.DispFromObstacle = obj.DispFromObstacle + [50 -50];
                end
            else
                obj.DispFromObstacle = [0 0];
            end
            
        end
        
        % Calcula o vetor de alinhamento (vetor "m")
        function updateAlignment(obj, boids)
            alignmentIndex = find(obj.DistToBoids>0 & obj.DistToBoids<=Config.AlignmentRadius);
            alignmentQty = length(alignmentIndex);
            tempDirection = 0;
            
            obj.AlignmentCorrection = [0 0];
            
            if alignmentQty > 0
                for i=1:alignmentQty
                    tempDirection = tempDirection + boids(alignmentIndex(i)).Direction;
                end
                obj.AlignmentCorrection = tempDirection/alignmentQty;
            end
        end
        
        % Calcula o vetor de coes�o (vetor "k")
        function updateAttraction (obj, boids)
            attractionIndex = find(obj.DistToBoids>0 & obj.DistToBoids<=Config.AttractionRadius);
            attractionQty = length(attractionIndex);
            
            obj.AttractionCorrection = [0 0];
            
            if attractionQty > 0
                position = zeros(1, 2);
                for i = 1:attractionQty
                    position = position + boids(attractionIndex(i)).Position;
                end
                position = round(position ./ attractionQty);
                obj.AttractionCorrection = position - obj.Position;
            end
            
        end
        
        % Atualiza a sprite de acordo com a dire��o e decide se o
        % p�ssaro est� com as asas para baixo ou para o alto
        function updateSprite(obj, change)
            if change == 1
                obj.SpriteType = ~obj.SpriteType;
            end
            [img, alpha] = obj.getSpriteImg(obj.SpriteType);
            if obj.Direction(1)>0
                img = flip(img,2);
                alpha = flip(alpha,2);
            end
            obj.H.CData = img;
            obj.H.AlphaData = alpha;
            obj.H.XData = obj.Position(1);
            obj.H.YData = obj.Position(2);
        end        
        
        %% Fun��es get e set para consulta e atualiz�o de vari�veis
        function setSprite(obj, type)
            obj.Sprite = type;
        end
        
        function h = getSprite(obj)
            h = obj.Sprite;
        end
        
        function setSpriteType(obj, type)
            obj.SpriteType = type;
        end
        
        function t = getSpriteType(obj)
            t = obj.SpriteType;
        end
        
        function p = getPosition(obj)
            p = obj.Position;
        end
        
        function h = getH(obj)
            h = obj.H;
        end        
        
        function setH(obj, h)
            obj.H = h;
        end
        %%
    end
   
    methods(Static)
        % seleciona o p�ssaro est� com as asas para cima ou para baixo
        function img = setImage(type)
            if type == 1
                img = Config.BoidSpriteOne;
            else
                img = Config.BoidSpriteTwo;
            end
        end
        
        % M�todo para ler as images das sprites
        function [img, alpha] = getSpriteImg(type)
            persistent birds
            if isempty(birds)
                bird1 = struct('img', 0, 'alpha', 0);
                bird2 = struct('img', 0, 'alpha', 0);
                [bird1.img, map, bird1.alpha] = imread(Config.BoidSpriteOne);
                [bird2.img, map, bird2.alpha] = imread(Config.BoidSpriteTwo);
                birds = [bird1 bird2];
            end
            type = type+1;
            img = birds(type).img;
            alpha = birds(type).alpha;
        end
    end
end