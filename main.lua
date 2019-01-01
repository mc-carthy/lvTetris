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
    z = { 0.66, 0.83, 0.46, 1 },
    next = { 0.75, 0.75, 0.75, 1 }
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

local pieceXCount = 4
local pieceYCount = 4

function love.load()
    reset()
end

function love.update(dt)
    fallDelta = love.keyboard.isDown('down') and 0.1 or 0.5
    timer = timer + dt
    if timer > fallDelta then
        timer = timer - fallDelta
        local nextY = pieceY + 1
        if canPieceMove(pieceX, nextY, pieceRotation) then
            pieceY = nextY
        else
            -- Add block to 'blocks'
            for x = 1, pieceXCount do
                for y = 1, pieceYCount do
                    local block = pieceStructures[pieceType][pieceRotation][y][x]
                    if block ~= ' ' then
                        blocks[x + pieceX][y + pieceY] = block
                    end
                end
            end

            -- Check for complete rows
            for y = 1, gridRows do
                local complete = true
                for x = 1, gridCols do
                    if blocks[x][y] == ' ' then
                        complete = false
                    end
                end

                if complete then
                    for removeY = y, 2, -1 do
                        for removeX = 1, gridCols do
                            blocks[removeX][removeY] = blocks[removeX][removeY - 1]
                        end
                    end

                    for removeX = 1, gridCols do
                        blocks[1][removeX] = ' '
                    end
                end
            end

            newPiece()

            if not canPieceMove(pieceX, pieceY, pieceRotation) then
                -- Game over
                reset()
            end
        end
    end
end

function love.draw()
    local xOffset = 2
    local yOffset = 5

    love.graphics.setBackgroundColor(1, 1, 1, 1)

    -- Draw grid
    for x = 1, gridCols do
        for y = 1, gridRows do
            drawBlock(blocks[x][y], x + xOffset, y + yOffset)
        end
    end

    -- Draw current piece
    for x = 1, pieceXCount do
        for y = 1, pieceYCount do
            local block = pieceStructures[pieceType][pieceRotation][y][x]
            if block ~= ' ' then
                drawBlock(block, x + pieceX + xOffset, y + pieceY + yOffset)
            end
        end
    end

    -- Draw next piece
    for y = 1, pieceYCount do
        for x = 1, pieceXCount do
            local block = pieceStructures[sequence[#sequence]][1][y][x]
            if block ~= ' ' then
                drawBlock('next', x + 5, y + 1)
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

function canPieceMove(testX, testY, testRotation)
    for x = 1, pieceXCount do
        for y = 1, pieceYCount do
            local testBlockX = testX + x
            local testBlockY = testY + y
            if pieceStructures[pieceType][testRotation][y][x] ~= ' ' and (
                (testBlockX) < 1 or
                (testBlockX) > gridCols or
                (testBlockY) > gridRows or
                blocks[testBlockX][testBlockY] ~= ' '
            ) then
                return false
            end
        end
    end
    return true
end

function newPiece()
    pieceX = 3
    pieceY = 0
    pieceRotation = 1
    pieceType = table.remove(sequence)

    if #sequence == 0 then
        newSequence()
    end
end

function newSequence()
    sequence = {}
    for pieceIndex = 1, #pieceStructures do
        local position = love.math.random(#sequence + 1)
        table.insert(sequence, position, pieceIndex)
    end
end

function reset()
    timer = 0

    blocks = {}
    for x = 1, gridCols do
        blocks[x] = {}
        for y = 1, gridRows do
            blocks[x][y] = ' '
        end
    end

    newSequence()
    newPiece()
end