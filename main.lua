-- LÖVE 2D |Smosh Radio| simaler to https://scratch.mit.edu/projects/953615295/

function love.load()
    -- 3/16/2024 DEBUGLIBRARY -----------------------
    debug = require("DebugLibrary") -- Imports the Debug function Library
    debug.clear()
    debug.log("successfully imported: DebugLibrary.lua")
    --------------------------------------------------

    -- 3/15/2024 DATETIMEFUNCTIONLIBRARY ------------
    dateTime = require("DateTimeFunctionLibrary") -- Imports the Date Time Function Library
    dateTime.Start()
    debug.log("successfully imported: DateTimeFunctionLibrary.lua")
    --------------------------------------------------

    love.window.setTitle("Smoah Radio") -- Names the window Spofify
    debug.log("set title of program to |Smosh Radio|")

    old_song_id = 0
    song_names = {}
    song_path = {}
    final_text = ""
    for i = 1, get_amount_of_files("audio/music") do -- Creates a table that contains all of the song names
        local filePath = get_file_path("audio/music", i)
        table.insert(song_names, filePath)
    end
    debug.log("audio/music: " .. table_to_string(song_names))
    
    table.sort(song_names) -- Sorts the song name table
    debug.log("sorted |song_names| to: " .. table_to_string(song_names))

    for i = 1, #song_names do -- Creates a table that holds the song paths
        if type(song_names[i]) == "string" then -- Checks to make sure that song_names[i] is a string
            if song_names[i] == "" then -- Checks if song_names[i] is an empty string
                debug.log("ERROR: song_names[" .. i .. "] is an empty string")
            else
                source = love.audio.newSource(song_names[i], "static")
                table.insert(song_path, source)
            end
        else
            debug.log("ERROR: song_names[" .. i .. "]" .. "is not a string")
        end
    end
    debug.log("created |song_path| based on |song_names|")

    final_text = ""
    image_path = {}
    for i = 1, get_amount_of_files("images/cover_art") do -- Creates a table that holds all of the song covers
        local filePath = get_file_path("images/cover_art", i)
        table.insert(image_path, filePath)
        final_text = final_text .. filePath .. ", "
    end
    debug.log("images/cover_art: " .. final_text)

    table.sort(image_path) -- Sorts the table that holds all of the song covers alphabetically
    debug.log("sorted |image_path| to: " .. table_to_string(image_path))

    if #image_path == #song_path then -- Makes sure there is the same amount of items in the |image_path| table as the |song_path| table
        debug.log("|image_path| and |song_path| have the same amount of items")
    else
        debug.log("ERROR: |image_path| and |song_path| do not have the same amount of files")
    end

    queue = {}
    ad = {}
    for i = 1, get_amount_of_files("audio/host") do -- Creates a table for all of the audio that the host/ad's say
        local filePath = get_file_path("audio/host", i)
        table.insert(ad, love.audio.newSource(filePath, "static"))
        final_text = final_text .. filePath .. ", "
    end
    debug.log("audio/host: " .. final_text)

    -- Creates all of the variables that are used to control the current_song
    total_songs_played = 0
    current_song = {}
    current_song.ID = 0
    current_song.status = "play"
    current_song.name = ""
    current_song.path = ""
    is_ad_playing = true
    update_current_song()
end
------------------------------------------------------------COUSTOM FUNCTIONS--------------------------

function table_to_string(table_name) -- Converts a table to a string
    final_string = ""
    for i = 1, #table_name do
        if i ~= #table_name then -- Checks to see if this is the last value in the table
            final_string = final_string .. tostring(table_name[i]) .. ", "
        else
            final_string = final_string .. tostring(table_name[i])
        end
    end
    return final_string -- Returns the final string
end

function get_file_path(directory_path, position) -- Gets the file path of a file in its directory based on its position in the directory
    local index = 1

    local files = {}
    for file in io.popen('dir "'..directory_path..'" /b'):lines() do -- Creates a temporary table that contains all of the files in the director_path directory
        table.insert(files, file)
    end

    for file in io.popen('dir "'..directory_path..'" /b'):lines() do -- Looks for the file position
        if index == position then
            debug.log("get_file_path(" .. directory_path .. ", " .. position .. ") returned " .. directory_path .. "/" .. files[index])
            return tostring(directory_path .. "/" .. files[index])
        end
        index = index + 1
    end

    return nil
end

function get_amount_of_files(directory_path) -- Gets the number of files that are in a directory
    local files = {}
    local index = 1

    for file in io.popen('dir "'..directory_path..'" /b'):lines() do -- Repeats for the amount of files that are in the directory
        files[index] = directory_path .. "/" .. file
        index = index + 1
    end

    debug.log("discovered " .. tostring(#files) .. " files in " .. tostring(directory_path) .. " folder")
    return #files
end

function table_contains(table, value) -- Checks if a table contains a certain value
    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

function update_current_song()
    old_song_id = current_song.ID
    math.randomseed(os.time())
    
    -- Add ad to the queue before selecting a new song
    table.insert(queue, ad[math.random(1, #ad)])

    -- Select a new song
    while current_song.ID == old_song_id do
        current_song.ID = math.random(1, #song_names)
    end

    current_song.name = song_names[current_song.ID]
    current_song.path = song_path[current_song.ID]

    -- Add the selected song to the queue
    table.insert(queue, current_song.path)

    debug.log("Updated current song to: " .. current_song.name)
    total_songs_played = total_songs_played + 1
    debug.log(total_songs_played .. " total songs played")
end

function update_current_image() -- Updates the current image
    -- Load appropriate cover art based on whether ad is playing or not
    if is_ad_playing then
        image = love.graphics.newImage("images/ad/smosh_ad's.png")
    else
        image = love.graphics.newImage(image_path[current_song.ID])
    end

    originalWidth, originalHeight = 920, 271
    scale = 0.6
    scaledWidth, scaledHeight = originalWidth * scale, originalHeight * scale
    screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
    x = (screenWidth - scaledWidth) / 2
    y = (screenHeight - scaledHeight) / 2
end

function play_next_audio() -- Plays the next audio that is in the queue table
    if #queue > 0 then
        local current_track = table.remove(queue, 1)
        love.timer.sleep(math.random(1.1, 2.1))
        current_song.path = current_track
        current_song.path:play()

        if table_contains(ad, current_track) then
            is_ad_playing = true
        else
            is_ad_playing = false
        end
    else
        update_current_song()
    end
end
---------------------------------------------SYSTEM FUNCTIONS------------------------------------------

function love.draw() -- Draws the scene
    update_current_image() -- Updates the current image
    love.graphics.draw(love.graphics.newImage("images/background/background.png"), 0, 0, 0, 4, 4) -- Creates the background

    time_font = love.graphics.newFont(24) -- Changes the font size
    love.graphics.setFont(time_font)
    time = dateTime.full_time() .. " " .. dateTime.am_pm() -- Sets the time
    love.graphics.print(time, 10, 10) -- Prints the current time

    love.graphics.draw(image, x, y, 0, scale, scale) -- Draws the image's cover art
end

function love.update(dt)
    dateTime.update_current_date() -- Updates the current time

    if current_song.path and not current_song.path:isPlaying() then -- Changes the audio if the song is over
        play_next_audio()
    end
end
