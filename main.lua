local gridRows = 18
local gridCols = 10

local colours = {
    [' '] = { 0.875, 0.875, 0.875, 1 },
    i = { 0.47, 0.76, 0.94, 1 },
    j = { 0.93, 0.91, 0.42, 1 },
    l = { 0.49, 0.85, 0.76, 1 },
    o = { 0.92, 0.69, 0.47, 1 },
    s = { 0.83, 0.54, 0.93, 1 },
    t = { 0.97, 0.58, 0.77, 1 },
    z = { 0.66, 0.83, 0.46, 1 }
}

local pieceStructures = {
    {
        {
            {' ', ' ', ' ', ' '},
            {'i', 'i', 'i', 'i'},
            {' ', ' ', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 'i', ' ', ' '},
            {' ', 'i', ' ', ' '},
            {' ', 'i', ' ', ' '},
            {' ', 'i', ' ', ' '},
        },
    },
    {
        {
            {' ', ' ', ' ', ' '},
            {' ', 'o', 'o', ' '},
            {' ', 'o', 'o', ' '},
            {' ', ' ', ' ', ' '},
        },
    },
    {
        {
            {' ', ' ', ' ', ' '},
            {'j', 'j', 'j', ' '},
            {' ', ' ', 'j', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 'j', ' ', ' '},
            {' ', 'j', ' ', ' '},
            {'j', 'j', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {'j', ' ', ' ', ' '},
            {'j', 'j', 'j', ' '},
            {' ', ' ', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 'j', 'j', ' '},
            {' ', 'j', ' ', ' '},
            {' ', 'j', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
    },
    {
        {
            {' ', ' ', ' ', ' '},
            {'l', 'l', 'l', ' '},
            {'l', ' ', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 'l', ' ', ' '},
            {' ', 'l', ' ', ' '},
            {' ', 'l', 'l', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', ' ', 'l', ' '},
            {'l', 'l', 'l', ' '},
            {' ', ' ', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {'l', 'l', ' ', ' '},
            {' ', 'l', ' ', ' '},
            {' ', 'l', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
    },
    {
        {
            {' ', ' ', ' ', ' '},
            {'t', 't', 't', ' '},
            {' ', 't', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 't', ' ', ' '},
            {' ', 't', 't', ' '},
            {' ', 't', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 't', ' ', ' '},
            {'t', 't', 't', ' '},
            {' ', ' ', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 't', ' ', ' '},
            {'t', 't', ' ', ' '},
            {' ', 't', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
    },
    {
        {
            {' ', ' ', ' ', ' '},
            {' ', 's', 's', ' '},
            {'s', 's', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {'s', ' ', ' ', ' '},
            {'s', 's', ' ', ' '},
            {' ', 's', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
    },
    {
        {
            {' ', ' ', ' ', ' '},
            {'z', 'z', ' ', ' '},
            {' ', 'z', 'z', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 'z', ' ', ' '},
            {'z', 'z', ' ', ' '},
            {'z', ' ', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
    },
}

function love.load()
    blocks = {}
    for x = 1, gridCols do
        blocks[x] = {}
        for y = 1, gridRows do
            blocks[x][y] = ' '
        end
    end

    -- blocks[1][18] = 'i'
    -- blocks[2][17] = 'j'
    -- blocks[3][16] = 'l'
    -- blocks[4][15] = 'o'
    -- blocks[5][14] = 's'
    -- blocks[6][13] = 't'
    -- blocks[7][12] = 'z'

    pieceType = 1
    pieceRotation = 1
end

function love.update(dt)

end

function love.draw()
    love.graphics.setBackgroundColor(1, 1, 1, 1)
    for x = 1, gridCols do
        for y = 1, gridRows do
            drawBlock(blocks[x][y], x, y)
        end
    end

    for x = 1, 4 do
        for y = 1, 4 do
            local block = pieceStructures[pieceType][pieceRotation][y][x]
            if block ~= ' ' then
                drawBlock(block, x, y)
            end
        end
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    if key == 'x' then
        pieceRotation = pieceRotation + 1
        if pieceRotation > #pieceStructures[pieceType] then
            pieceRotation = 1
        end
    end
    if key == 'z' then
        pieceRotation = pieceRotation - 1
        if pieceRotation < 1 then
            pieceRotation = #pieceStructures[pieceType]
        end
    end
end

function drawBlock(block, x, y)
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