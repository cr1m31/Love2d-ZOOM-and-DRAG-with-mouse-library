io.stdout:setvbuf('no') --console output at run
love.graphics.setDefaultFilter("nearest") --no anti aliasing

--[[
ZOOM and TRANSLATE library_____________________________________________________________________________

  code inspired by javidx9 (one lone coder) 
  https://youtu.be/ZQ8qtAizis4

   made by me cr1m3 for love2d in Lua
_________________________________________________________________________________________________________

The symbolic concept is that you have multiple dimensions, like parallel dimensions in this program.

Since we are in 2D here, i will replace the word "dimension" by "space",
to avoid confusion between two dimensions (2D) and parallel dimension.

Here, we have basically the screen and the world spaces, both have an horizontal x and vertical y axis (2 dimensions).

We create some function to make a portal between screen and world spaces.
The portal is the function and the link between spaces is the offset.
--]]

--VARIABLES________________________________________________________

-- background image
local imgBckgd = love.graphics.newImage("Cave.png")

local offsetX = 0 -- screen to world offset
local offsetY = 0

local mousePosX = 0
local mousePosY = 0

local startMoveX = 0
local startMoveY = 0

local mouseWorldBeforeZoomX = 0
local mouseWorldBeforeZoomY = 0
local mouseWorldAfterZoomX = 0
local mouseWorldAfterZoomY = 0

local zoomX = 1.0 -- zoom default value
local zoomY = 1.0

--OBJECTS_______________________________________________________________

local screen = {}
screen.x = 0 -- screen pos (= window's up left corner)
screen.y = 0

local world = {} -- grid
world.x = 0
world.y = 0
world.width = 1024
world.height = 768
world.cell = 128 -- grid cell size

--______________________________________________________________________

-- screen space will be converted to world space then divided by the zoom factor and add the screen to world offset
function screenToWorld(screenX, screenY) 
  worldX = (screenX / zoomX)  + offsetX
  worldY = (screenY / zoomY) + offsetY
  return worldX, worldY
end

function catchMousePosBeforeMove() --happens only once when btn is pressed
  startMoveX = mousePosX -- capture mouse pos when clicking before moving
  startMoveY = mousePosY
end

function love.update()
  mousePosX = love.mouse.getX()
  mousePosY = love.mouse.getY()
  
  if love.mouse.isDown(1) then
    offsetX = offsetX + (mousePosX - startMoveX) / zoomX -- modify the offset while moving
    offsetY = offsetY + (mousePosY - startMoveY) / zoomY
    startMoveX = mousePosX -- capture the mouse until the end of moving
    startMoveY = mousePosY
  end
  
end

function love.draw()
  --add offset to objects that are a part of the world including the world grid
  
  love.graphics.push() --describe briefly
    love.graphics.scale(zoomX,zoomY) -- love2d zoom function
    
    --draw image background
    love.graphics.draw(imgBckgd, 0 + offsetX, 0 + offsetY)
    
    --draw world grid
    for yLines = 0, world.height, world.cell do
      love.graphics.line(offsetX, yLines + offsetY, world.width + offsetX, yLines + offsetY)
      for xLines = 0, world.width, world.cell do
        love.graphics.line(xLines + offsetX, offsetY, xLines + offsetX, world.height + offsetY)
      end
    end
    --draw rectangular object
    love.graphics.setColor(1,0,0.2)
    love.graphics.rectangle("fill", 260 + offsetX, 256 + offsetY, 30, 50)
    love.graphics.setColor(1,1,1)
  love.graphics.pop()
  
  --show zoom factor
  love.graphics.setColor(0,1,0.2)
  love.graphics.print("zoomX = " .. zoomX, 20,50)
  love.graphics.setColor(1,1,1)
end

function love.wheelmoved(x, y)
    --zoom in and out
    mouseWorldBeforeZoomX, mouseWorldBeforeZoomY = screenToWorld(mousePosX, mousePosY) -- mouse to world transformation, before zoom
    if y > 0 then --wheelMouseUp
      zoomX = zoomX * 1.101  --odd float number to prevent by zero division (multiply scale, not add to)
      zoomY = zoomY * 1.101
    elseif y < 0 then --wheelMouseDown
      zoomX = zoomX * 0.901 --odd float number to prevent by zero division
      zoomY = zoomY * 0.901
    end
    mouseWorldAfterZoomX, mouseWorldAfterZoomY = screenToWorld(mousePosX, mousePosY) -- mouse to world transformation, after zoom
    
    --correct offset while zooming
    offsetX = offsetX - (mouseWorldBeforeZoomX - mouseWorldAfterZoomX) -- minus correction
    offsetY = offsetY - (mouseWorldBeforeZoomY - mouseWorldAfterZoomY) 
end

-- callback functions
function love.mousepressed(x, y, button, istouch)
  if button == 1 then
    catchMousePosBeforeMove() --happens only once when btn is pressed
  end
end

--restart game
function love.keypressed(key)
  if  key == "escape" then
    love.event.quit("restart")
  end
end

