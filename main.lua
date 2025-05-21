function love.load()
  target = {radius = 50}
  score = 0
  timer = 10
  gameState = 1

  gameFont = love.graphics.newFont(40)

  sprites = {}
  sprites.sky = love.graphics.newImage("sprites/sky.png")
  sprites.target = love.graphics.newImage("sprites/target.png")
  sprites.crosshairs = love.graphics.newImage("sprites/crosshairs.png")

  love.mouse.setVisible(false)
end

function love.update(dt)
  if timer > 0 then
    timer = timer - dt
  end

  if timer < 0 then
    timer = 0
    gameState = 1
  end
end

function love.draw()
  love.graphics.draw(sprites.sky, 0, 0)

  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(gameFont)
  love.graphics.print("Score: " .. score, 10, 10)

  if gameState == 1 then
    love.graphics.printf("Click to Start", 0, 200, love.graphics.getWidth(), "center")
  elseif gameState == 2 then
    love.graphics.printf("Time: " .. math.ceil(timer), 0, 10, love.graphics.getWidth(), "center")
    love.graphics.draw(sprites.target, target.x - target.radius, target.y - target.radius)
  end
  love.graphics.draw(sprites.crosshairs, love.mouse.getX() - 20, love.mouse.getY() - 20)
end

function love.mousepressed(x, y, button, istouch, presses)
  if button == 1 and gameState == 2 then
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
  elseif button == 1 and gameState == 1 then
    gameState = 2
    timer = 10
    score = 0
    generateTargetPosition()
  end
end

function distance(x1, y1, x2, y2)
  return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

function generateTargetPosition()
  target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
  target.y = math.random(target.radius, love.graphics.getHeight() - target.radius)
end