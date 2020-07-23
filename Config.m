classdef Config
    properties(Constant)
        % Cenario e Sprites utilizadas
        Scenario = imread('sky1.jpg');
        BoidSpriteOne = 'bird1.png';
        BoidSpriteTwo = 'bird2.png';
        ObstacleSpriteOne = 'predator1.png';
        ObstacleSpriteTwo = 'predator2.png';
        % Configura a cada quantas interações as Sprites serão atualizadas
        ChangeBoids = 1;
        
        % Constantes
        Area = [size(Config.Scenario,1) size(Config.Scenario,2)];
        BoidsQty = 50;
        RepulsionRadius = 70;
        AlignmentRadius = 100;
        AttractionRadius = 100;
        kSeparation = 0.1;
        kCohesion = 0.1;
        kAlignment = 0.1;
    end
end