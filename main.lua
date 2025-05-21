function love.load()
  target = {x = 0, y = 0, radius = 50}
  score = 0
  timer = 10
  gameState = 'start'
  cooldownTimer = 0

  gameFont = love.graphics.newFont(40)

  sprites = {}
  sprites.sky = love.graphics.newImage("sprites/sky.png")
  sprites.target = love.graphics.newImage("sprites/target.png")
  sprites.crosshairs = love.graphics.newImage("sprites/crosshairs.png")

  love.mouse.setVisible(false)
end

function love.update(dt)
  if gameState == 'play' and timer > 0 then
    timer = timer - dt
  end

  if timer < 0 then
    timer = 0
    gameState = 'end'
    cooldownTimer = 1 
  end
  
  if cooldownTimer > 0 then
    cooldownTimer = cooldownTimer - dt
  end
end

function love.draw()
  love.graphics.draw(sprites.sky, 0, 0)

  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(gameFont)
  love.graphics.print("Score: " .. score, 10, 10)

  if gameState == 'start' then
    love.graphics.printf("Click to Start", 0, 200, love.graphics.getWidth(), "center")
  elseif gameState == 'play' then
    love.graphics.printf("Time: " .. math.ceil(timer), 0, 10, love.graphics.getWidth(), "center")
    love.graphics.draw(sprites.target, target.x - target.radius, target.y - target.radius)
  elseif gameState == 'end' then
    love.graphics.printf("Game Over", 0, 100, love.graphics.getWidth(), "center")
    love.graphics.printf("Final Score: " .. score, 0, 200, love.graphics.getWidth(), "center")
    love.graphics.printf("Click to go to Main Menu", 0, 300, love.graphics.getWidth(), "center")
  end
  love.graphics.draw(sprites.crosshairs, love.mouse.getX() - 20, love.mouse.getY() - 20)
end

function love.mousepressed(x, y, button, istouch, presses)
  if button == 1 and gameState == 'play' then
    local distance = distance(x, y, target.x, target.y)
    if distance <= target.radius then
      score = score + 1
      generateTargetPosition()
    else
      score = score - 1
      if score < 0 then
        score = 0
      end
    end
  elseif button == 1 and gameState == 'start' then
    gameState = 'play'
    resetState()
    generateTargetPosition()
  elseif button == 1 and gameState == 'end' and cooldownTimer <= 0 then
    gameState = 'start'
    resetState()
  end
end

function distance(x1, y1, x2, y2)
  return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

function generateTargetPosition()
  target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
  target.y = math.random(target.radius, love.graphics.getHeight() - target.radius)
end

function resetState()
  score = 0
  timer = 10
end