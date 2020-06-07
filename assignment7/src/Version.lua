function set255Colour(x, y, z, a)
    -- First account for possibility of colour table
    if not y then
        x2 = {}

        for i, val in pairs(x) do
            table.insert(x2, val / 255)
        end

        love.graphics.setColor(x2)

    -- Secondly account for each colour passed in separately
    else
        if not a then a = 255 end -- set alpha to opaque

        x2, y2, z2, a2 = x / 255, y / 255, z / 255, a / 255

        love.graphics.setColor(x2, y2, z2, a2)
    end
end

function clear255(x, y, z, a)
    -- First account for possibility of colour table
    if not y then
        x2 = {}

        for i, val in pairs(x) do
            table.insert(x2, val / 255)
        end

        love.graphics.clear(x2)

    -- Secondly account for each colour passed in separately
    else
        if not a then a = 255 end -- set alpha to opaque

        x2, y2, z2, a2 = x / 255, y / 255, z / 255, a / 255

        love.graphics.clear(x2, y2, z2, a2)
    end
end

function newSource(f, t)

    if not t then t = 'stream' end

    return love.audio.newSource(f, t)
end