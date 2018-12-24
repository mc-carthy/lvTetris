local gridRows = 18
local gridCols = 10

local colours = {
    empty = { 0.875, 0.875, 0.875, 1 },
    i = { 0.47, 0.76, 0.94, 1 },
    j = { 0.93, 0.91, 0.42, 1 },
    l = { 0.49, 0.85, 0.76, 1 },
    o = { 0.92, 0.69, 0.47, 1 },
    s = { 0.83, 0.54, 0.93, 1 },
    t = { 0.97, 0.58, 0.77, 1 },
    z = { 0.66, 0.83, 0.46, 1 }
}

function love.load()
    blocks = {}
    for x = 1, gridCols do
        blocks[x] = {}
        for y = 1, gridRows do
            blocks[x][y] = 'empty'
        end
    end

    blocks[1][18] = 'i'
    blocks[2][17] = 'j'
    blocks[3][16] = 'l'
    blocks[4][15] = 'o'
    blocks[5][14] = 's'
    blocks[6][13] = 't'
    blocks[7][12] = 'z'
end

function love.update(dt)

end

function love.draw()
    love.graphics.setBackgroundColor(1, 1, 1, 1)
    love.graphics.setColor(colours.empty)
    for x = 1, gridCols do
        for y = 1, gridRows do
            local block = blocks[x][y]
            local colour = colours[block]
            love.graphics.setColor(colour)
            local blockSize = 20
            local blockDrawSize = blockSize - 1
            love.graphics.rectangle(
                'fill',
                (x - 1) * blockSize,
                (y - 1) * blockSize,
                blockDrawSize,
                blockDrawSize
            )
        end
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end