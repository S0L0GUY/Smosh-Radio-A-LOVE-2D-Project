local M = {}

function M.log(message)
    -- Writes to |debug_log.txt|
    local file = io.open("debug_log.txt", "a") -- Open log file in append mode
    file:write(message .. "\n") -- Write message to log file
    file:write("" .. "\n") -- Makes a blank space at the bottom of the line
    file:write("--------------------------------" .. "\n") -- Creates the bottom divider
    file:close() -- Closes log file

    -- Writes to the termanal
    print(message)
    print("--------------------------------")
end


function M.clear()
    -- Clears the file |debug_log.txt|
    local file = io.open("debug_log.txt", "w") -- Open file in write mode
    if file then
        file:write("") -- Writes an empty string to effectively clear the file
        file:close()
    else
        M.log("Error: Could not open debug_log.txt for clearing") -- Logs the error to debug_log.txt
        -----------------------
        print("Error: Could not open debug_log.txt for clearing") -- Logs the error to the terminal
        print("")
        print("--------------------------------")
    end
end

return M