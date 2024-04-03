local dateTime = {}

function dateTime.Start()
    function dateTime.update_current_date() -- Udates the current time to the os's time
        return os.date("*t")
    end
    
    function dateTime.whole_date() -- prints the date as 11/11/24 format
        local currentDate = dateTime.update_current_date()
        return currentDate.month .. "/" .. currentDate.day .. "/" .. currentDate.year
    end
    
    function dateTime.month() -- prints the current month
        local currentDate = dateTime.update_current_date()
        return currentDate.month
    end
    
    function dateTime.day() -- prints the current day
        local currentDate = dateTime.update_current_date()
        return currentDate.day
    end
    
    function dateTime.year() -- prints the current year
        local currentDate = dateTime.update_current_date()
        return currentDate.year
    end
    
    function dateTime.minute() -- prints the current minute
        local currentDate = dateTime.update_current_date()
        if currentDate.min < 10 then
            return "0" .. tostring(currentDate.min)
        else
            return tostring(currentDate.min)
        end
    end
    
    function dateTime.hour() -- prints the current hour
        local currentDate = dateTime.update_current_date()
        if tonumber(currentDate.hour) > 12 then -- changes the time from a 24 hr clock to a 12 hr clock
            return tonumber(currentDate.hour) - 12
        else
            return tonumber(currentDate.hour)
        end
    end
    
    function dateTime.full_time() -- prints the houre nd munute '3:45'
        return tostring(dateTime.hour()) .. ":" .. tostring(dateTime.minute())
    end
    
    function dateTime.am_pm() -- prints am/pm
        if tonumber(dateTime.hour()) > 12 then -- checks if the hour is mre then 12
            return "pm"
        else
            return "am"
        end
    end
end

return dateTime