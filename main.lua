function love.load()
    anim8 = require 'libraries/anim8/anim8'

    sprites = {}
    sprites.playerSheet = love.graphics.newImage('sprites/playerSheet.png')

    -- width : 9210 / 15 = 614
    -- height: 1692 / 3 = 564
    local grid = anim8.newGrid(614, 564, sprites.playerSheet:getWidth(),sprites.playerSheet:getHeight())

    animations = {}
    animations.idle = anim8.newAnimation(grid('1-15',1), 0.03) -- column, row, time each grid
    animations.jump = anim8.newAnimation(grid('1-7',2), 0.03)
    animations.run = anim8.newAnimation(grid('1-15',3), 0.03)

    wf = require 'libraries/windfield/windfield'
    world = wf.newWorld(0, 1000, false) -- gravity x and y
    world:setQueryDebugDrawing(true)


    world:addCollisionClass('Platform')
    world:addCollisionClass('Player'--[[,{ignores = {'Platform'}}]])
    world:addCollisionClass('Danger')

    require('player')

    platform = world:newRectangleCollider(250,400,300,100, {collision_class = "Platform"})
    platform:setType('static')

    dangerZone = world:newRectangleCollider(0,550,800,50, {collision_class = "Danger"})
    dangerZone:setType('static')

end

function love.update(dt)
    world:update(dt)
    playerUpdate(dt)
end

function love.draw()
    world:draw()
    drawPlayer()
end

function love.keypressed(key)
    if key == 'up' then
        -- 創造一個collider在底部
        -- local colliders = world:queryRectangleArea(player:getX()-20, player:getY()+50, 40, 2, {'Platform'})
        -- 如果collider存在，表示player與platform有接觸，才能跳躍
        if player.grounded then
            player:applyLinearImpulse(0,-4000)
        end

    end
end

function love.mousepressed(x,y,button)
    if button == 1 then
        local colliders = world:queryCircleArea(x,y,200,{'Platform',"Danger"})
        for i,c in ipairs(colliders) do
            c:destroy()
        end
    end
end