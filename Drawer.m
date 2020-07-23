classdef Drawer
    methods (Static)
        
        % Desenha o mapa, os boids e o obstáculo
        function drawAll(boids, obstacle)
            persistent map;
            persistent untilChangeSprite;
            persistent changeSprite;
            
            if isempty(map)
                Drawer.drawBackgroud();
                set(gca,'visible','off')
                ax = gca;
                ax.DataAspectRatio = [1 1 1];
                map = gcf;
                map.PaperPositionMode = 'auto';
                print('Map','-dpng','-r0');
            end
            
            if isempty(untilChangeSprite )
                untilChangeSprite = Config.ChangeBoids;
            end
            
            if isempty(changeSprite)
                changeSprite = false;
            end
            
            untilChangeSprite = untilChangeSprite-1;
            if untilChangeSprite == 0
                changeSprite = true;
                untilChangeSprite = Config.ChangeBoids;
            end
            
            Drawer.drawBoids(boids, changeSprite);
            Drawer.drawObstacle(obstacle, changeSprite);
            changeSprite = false;
        end
        
        % Desenha o cenário
        function drawBackgroud()
            image(Config.Scenario);
        end
        
        % Desenha os boids
        function drawBoids(boids, changeSprite)
            for i=1:Config.BoidsQty
                if isempty(boids(i).getH)
                    [img, alpha] = boids(i).getSpriteImg(boids(i).getSpriteType());
                    h = image('XData', boids(i).Position(1),...
                    'YData', boids(i).Position(2),...
                    'CData',img, 'AlphaData', alpha);
                    boids(i).setH(h);
                end
                
                boids(i).updateSprite(changeSprite);
                
            end
        end
        
        % Desenha os Obstáculos
        function drawObstacle(obstacle, changeSprite)
            if isempty(obstacle.getH)
                [img, alpha] = obstacle.getSpriteImg(obstacle.getSpriteType());
                h = image('XData', obstacle.Position(1),...
                'YData', obstacle.Position(2),...
                'CData',img, 'AlphaData', alpha);
               obstacle.setH(h);
            end
            obstacle.updateSprite(changeSprite);
        end
    end
end