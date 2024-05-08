local dateTime = {}

function dateTime.Start()
    -- Updates the current time to the os's time
    function dateTime.update_current_date()
        return os.date("*t")
    end
    
    -- prints the date as 11/11/24 format
    function dateTime.whole_date()
        local currentDate = dateTime.update_current_date()
        return currentDate.month .. "/" .. currentDate.day .. "/" .. currentDate.year
    end
    
    -- prints the current month
    function dateTime.month()
        local currentDate = dateTime.update_current_date()
        return currentDate.month
    end
    
    -- prints the current day
    function dateTime.day() 
        local currentDate = dateTime.update_current_date()
        return currentDate.day
    end
    
    -- prints the current year
    function dateTime.year()
        local currentDate = dateTime.update_current_date()
        return currentDate.year
    end
    
    -- prints the current minute
    function dateTime.minute() 
        local currentDate = dateTime.update_current_date()
        if currentDate.min < 10 then
            return "0" .. tostring(currentDate.min)
        else
            return tostring(currentDate.min)
        end
    end
    
    -- prints the current hour
    function dateTime.hour()
        local currentDate = dateTime.update_current_date()
        -- changes the time from a 24 hr clock to a 12 hr clock
        if tonumber(currentDate.hour) > 12 then
            return tonumber(currentDate.hour) - 12
        else
            return tonumber(currentDate.hour)
        end
    end
    
    -- prints the hour and minute '3:45'
    function dateTime.full_time()
        return tostring(dateTime.hour()) .. ":" .. tostring(dateTime.minute())
    end
    
    -- prints am/pm
    function dateTime.am_pm()
        -- checks if the hour is more than 12
        if tonumber(dateTime.hour()) > 12 then
            return "pm"
        else
            return "am"
        end
    end
end

return dateTime