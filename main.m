% Algoritmo de Reynolds - Boids
% Aluna: Luana Barros

clc; clear all; close all;
addpath('.\Images');

% Aloca um vetor vazio do tipo Boids com a quantidade de elementos definida
% na classe Config
birds = Boid.empty(Config.BoidsQty,0);

% Preenche o vetor birds com objetos do tipo Boid
for i = 1:Config.BoidsQty
    birds(i) = Boid();
end

% Inicializa um Obstáculo
predator = Obstacle();

% Desenha o cenário, os boids e o obstáculo de acordo com suas posições
Drawer.drawAll(birds, predator);

while(1)
    % Atualiza a direção e a posição de todos os boids criados
    for i = 1:Config.BoidsQty
        birds(i).updateBoids(birds, predator);
    end
    
    try
        % Desenha os boids e o obstáculo em sua nova posição
        Drawer.drawAll(birds, predator);
        pause(0.1);
    catch ME
        % Finaliza a execução caso a janela seja fechada ou ocorra Ctrl+C
        % como entrada
        switch ME.identifier
            case 'MATLAB:handle_graphics:exceptions:UserBreak'  % Ctrl+C
            case 'MATLAB:class:InvalidHandle'  % window closed
                disp('BOIDs simulation finished')
                break
            otherwise
                disp(ME.identifier)
                rethrow(ME)
        end
    end
end