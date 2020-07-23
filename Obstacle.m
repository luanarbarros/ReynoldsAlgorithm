classdef Obstacle < handle
    properties
        Position;
        Ratio;
        ActDistance;
        
        % Variáveis para atualização das sprites (gráfico)
        Sprite;
        SpriteType;
        H;
    end
    
    methods
        % Constructor
        function obj = Obstacle()
            obj.Position = floor(rand(1, 2).*Config.Area);
            obj.Ratio = 1;
            obj.ActDistance = 200;
            initSprite = randi([0 1]);
            obj.SpriteType = initSprite;
        end
        
        % Movimenta o obstáculo pelo cenário
        function changePosition(obj)
            persistent t w
            if isempty(t)
                t = rand;
                w = (rand*0.2 - 0.5) + 1;
            end
            center = Config.Area ./ 2;
            obj.Position = [cos(w*t) sin(t)].*(center./2) + center;
            t = t+0.05;
        end
        
        % Atualiza a sprite do predador e decide se está com as asas
        % para baixo ou para o alto
        function updateSprite(obj, change)
            if change == 1
                obj.changePosition();
                obj.SpriteType = ~obj.SpriteType;
            end
            [img, alpha] = obj.getSpriteImg(obj.SpriteType);
            obj.H.CData = img;
            obj.H.AlphaData = alpha;
            obj.H.XData = obj.Position(1);
            obj.H.YData = obj.Position(2);
        end
       
        %% Funções get e set para consulta e atualizão de variáveis
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
        % seleciona o predador com as asas para cima ou para baixo
        function img = setImage(type)
            if type == 1
                img = Config.ObstacleSpriteOne;
            else
                img = Config.ObstacleSpriteTwo;
            end
        end
        
        % Método para ler as images das sprites
        function [img, alpha] = getSpriteImg(type)
            persistent obstacle1_img obstacle1_alpha obstacle2_img obstacle2_alpha;
            if isempty(obstacle1_img)
                [obstacle1_img, map, obstacle1_alpha] = imread(Config.ObstacleSpriteOne);
            end
            
            if isempty(obstacle2_img)
                [obstacle2_img, map, obstacle2_alpha] = imread(Config.ObstacleSpriteTwo);
            end
            
            if type == 1
                img = obstacle1_img;
                alpha = obstacle1_alpha;
            else
                img = obstacle2_img;
                alpha = obstacle2_alpha;
            end
            
        end
    end
end