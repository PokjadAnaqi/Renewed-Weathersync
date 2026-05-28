local buildWeatherList = require 'server.weatherbuilder'
local weather_class = require 'classes.weather'

local Config = lib.load('config.weather')
local useScheduledWeather = Config.useScheduledWeather


---@type renewed_weather[]
local weatherList = buildWeatherList()

local overrideWeather = false

-- weatherList executor --
local function executeCurrentWeather()
    local weather = weatherList[1]

    if weather then
        GlobalState.weather = weather:GetWeatherData()
    end

    return weather
end

local function runWeatherList()
    executeCurrentWeather()

    while not overrideWeather do
        -- Always read the head of the list fresh each tick so outside mutations
        -- (admin removals, exports.setWeather, etc.) are picked up immediately
        -- and we never decrement a stale reference to a removed event.
        local currentWeather = weatherList[1]

        if currentWeather then
            currentWeather.time -= 1

            if currentWeather.time <= 0 then
                table.remove(weatherList, 1)

                -- Rebuild the forecast if we just consumed the last event so
                -- weather keeps cycling on long-lived servers instead of
                -- freezing with an empty list.
                if not weatherList[1] then
                    weatherList = buildWeatherList()
                end

                executeCurrentWeather()
            end
        else
            weatherList = buildWeatherList()
            executeCurrentWeather()
        end
        Wait(60000)
    end
end

CreateThread(runWeatherList)

-- Admin related events --
RegisterNetEvent('Renewed-Weather:server:removeWeatherEvent', function(index)
    local source = source
    if not IsPlayerAceAllowed(source, 'command.weather') or not weatherList[index] then return end

    table.remove(weatherList, index)

    -- If we removed the currently-active event, refill the list if it's now
    -- empty and push the new head out to clients immediately so they don't
    -- sit on the removed weather for up to a minute.
    if index == 1 then
        if not weatherList[1] then
            weatherList = buildWeatherList()
        end
        executeCurrentWeather()
    end
end)

lib.callback.register('Renewed-Weathersync:server:setWeatherType', function(source, index, weatherType)
    if IsPlayerAceAllowed(source, 'command.weather') and weatherList[index] then
        local weatherEvent = weatherList[index]

        weatherEvent:SetWeather(weatherType)


        if index == 1 then
            GlobalState.weather = weatherEvent:GetWeatherData()
        end

        return weatherType
    end

    return false
end)

lib.callback.register('Renewed-Weathersync:server:setEventTime', function(source, index, eventTime)
    if IsPlayerAceAllowed(source, 'command.weather') and weatherList[index] then
        local weatherEvent = weatherList[index]

        weatherEvent:SetEventTime(eventTime)

        return eventTime
    end

    return false
end)

lib.addCommand('weather', {
    help = 'View and set the current weather forecast',
    restricted = 'group.admin',
}, function(source)
    TriggerClientEvent('Renewed-Weather:client:viewWeatherInfo', source, weatherList)
end)

lib.addCommand('blackout', {
    help = 'Toggle server wide or player only blackout',
	restricted = 'group.admin',
	params = {
		{ name = 'target', type = 'playerId', help = 'Target player\'s server id', optional = true },
	}
}, function(source, args)
	if not args.target then
		GlobalState.blackOut = not GlobalState.blackOut
	else
		local playerState = Player(args.target)
        if not playerState then return end
        playerState.state:set('playerBlackOut', not playerState.state?.playerBlackOut, true)
	end
end)

-- Exports for other resources --

---Returns a copy of the currently active weather payload.
---@return renewed_weather_payload?
exports('getCurrentWeather', function()
    return GlobalState.weather
end)

---Returns a serialized copy of the full upcoming forecast (index 1 is active).
---Mutating the returned tables does not affect the live forecast.
---@return renewed_weather_payload[]
exports('getForecast', function()
    local forecast = {}
    for i = 1, #weatherList do
        forecast[i] = weatherList[i]:GetWeatherData()
    end
    return forecast
end)

---Force a weather event to start now, pushing the existing forecast back.
---Ignored while a scheduled-restart override is active.
---@param weatherType string  e.g. 'RAIN', 'EXTRASUNNY'
---@param duration? number    Minutes (defaults to Config.weatherCycletimer)
---@param windSpeed? number
---@param windDirection? number
---@return boolean success
exports('setWeather', function(weatherType, duration, windSpeed, windDirection)
    if overrideWeather then return false end
    if type(weatherType) ~= 'string' then return false end

    ---@diagnostic disable-next-line: invisible
    local event = weather_class:new({
        weather = weatherType,
        time = tonumber(duration) or Config.weatherCycletimer,
        windSpeed = tonumber(windSpeed),
        windDirection = tonumber(windDirection),
    })

    table.insert(weatherList, 1, event)
    executeCurrentWeather()

    return true
end)

-- Scheduled restart --
if useScheduledWeather then
    AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
        local secondsRemaining = eventData.secondsRemaining
        local weather = secondsRemaining == 900 and 'OVERCAST' or secondsRemaining == 600 and 'RAIN' or secondsRemaining == 300 and 'THUNDER'

        if weather then
            overrideWeather = true
            GlobalState.weather = {
                weather = weather,
                time = 9000000
            }
        end
    end)
end
