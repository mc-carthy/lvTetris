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
    timer = 0

    blocks = {}
    for x = 1, gridCols do
        blocks[x] = {}
        for y = 1, gridRows do
            blocks[x][y] = ' '
        end
    end

    pieceType = 1
    pieceRotation = 1
    pieceX = 3
    pieceY = 0
end

function love.update(dt)
    fallDelta = love.keyboard.isDown('down') and 0.1 or 0.5
    timer = timer + dt
    if timer > fallDelta then
        timer = timer - fallDelta
        local nextY = pieceY + 1
        if canPieceMove(x, nextY, pieceRotation) then
            pieceY = nextY
        end
    end
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
                drawBlock(block, x + pieceX, y + pieceY)
            end
        end
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    if key == 'x' then
        local nextRotation = pieceRotation + 1
        if nextRotation > #pieceStructures[pieceType] then
            nextRotation = 1
        end
        if canPieceMove(pieceX, pieceY, nextRotation) then
            pieceRotation = nextRotation
        end
    end
    if key == 'z' then
        local nextRotation = pieceRotation - 1
        if nextRotation < 1 then
            nextRotation = #pieceStructures[pieceType]
        end
        if canPieceMove(pieceX, pieceY, nextRotation) then
            pieceRotation = nextRotation
        end
    end
    if key == 'left' then
        local nextX = pieceX - 1
        if canPieceMove(nextX, pieceY, pieceRotation) then
            pieceX = nextX
        end
    end
    if key == 'right' then
        local nextX = pieceX + 1
        if canPieceMove(nextX, pieceY, pieceRotation) then
            pieceX = nextX
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

function canPieceMove(x, y, rotation)
    return true
end