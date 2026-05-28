-- Weather Admin Management --

local weatherTypes = {
    {
        label = 'BLIZZARD',
        value = 'BLIZZARD'
    },
    {
        label = 'CLEAR',
        value = 'CLEAR'
    },
    {
        label = 'CLEARING',
        value = 'CLEARING'
    },
    {
        label = 'CLOUDS',
        value = 'CLOUDS'
    },
    {
        label = 'EXTRA SUNNY',
        value = 'EXTRASUNNY'
    },
    {
        label = 'FOGGY',
        value = 'FOGGY'
    },
    {
        label = 'NEUTRAL',
        value = 'NEUTRAL'
    },
    {
        label = 'OVERCAST',
        value = 'OVERCAST'
    },
    {
        label = 'RAIN',
        value = 'RAIN'
    },
    {
        label = 'RAIN HALLOWEEN',
        value = 'RAIN_HALLOWEEN'
    },
    {
        label = 'SMOG',
        value = 'SMOG'
    },
    {
        label = 'SNOW',
        value = 'SNOW'
    },
    {
        label = 'SNOW LIGHT',
        value = 'SNOWLIGHT'
    },
    {
        label = 'SNOW HALLOWEEN',
        value = 'SNOW_HALLOWEEN'
    },
    {
        label = 'THUNDER',
        value = 'THUNDER'
    },
    {
        label = 'XMAS',
        value = 'XMAS'
    },
}

local currentWeatherTable = {}

local viewWeatherEvent

local function GetWeatherLabel(weather)

    for i = 1, #weatherTypes do

        local data = weatherTypes[i]

        if data.value == weather then
            return data.label
        end
    end

    return weather
end

local function RefreshWeatherMenu()

    lib.hideContext(false)

    SetTimeout(150, function()

        TriggerEvent('Renewed-Weather:client:viewWeatherInfo', currentWeatherTable)

    end)
end

viewWeatherEvent = function(index, weatherEvent, isQueued)

    local weatherLabel = GetWeatherLabel(weatherEvent.weather)

    local metadata = isQueued and {
        ('Weather %s'):format(weatherLabel),

        ('Lasting for %s minutes'):format(weatherEvent.time)

    } or {

        ('Weather %s'):format(weatherLabel),

        ('%s Minutes Remaining'):format(weatherEvent.time)
    }

    lib.registerContext({
        id = 'Renewed-Weathersync:client:changeWeather',
        title = ('Change Weather (%s)'):format(weatherLabel),
        menu = 'Renewed-Weathersync:client:manageWeather',
        options = {
            {
                title = 'Info',
                icon = 'fa-solid fa-circle-info',
                readOnly = true,
                metadata = metadata
            },
            {
                title = 'Change Weather',
                icon = 'fa-solid fa-cloud',
                arrow = true,
                onSelect = function()
                    local input =
                        lib.inputDialog(
                            'Change Weather Type',
                            {
                                {
                                    label = 'Select Weather',
                                    type = 'select',
                                    required = true,
                                    default = weatherEvent.weather,
                                    options = weatherTypes
                                },
                            }
                        )
                    if input and input[1] then
                        local weather =
                            lib.callback.await('Renewed-Weathersync:server:setWeatherType', false, index, input[1])
                        if weather then
                            weatherEvent.weather = weather
                        end
                    end
                    RefreshWeatherMenu()
                end
            },
            {
                title = 'Change Duration',
                arrow = true,
                icon = 'fa-solid fa-hourglass-half',
                onSelect = function()
                    local input =
                        lib.inputDialog(
                            'Change Duration',
                            {
                                {
                                    label = 'Duration in minutes',
                                    type = 'slider',
                                    required = true,
                                    min = 1,
                                    max = 120,
                                    default = weatherEvent.time,
                                },
                            }
                        )
                    if input and input[1] then
                        local time =
                            lib.callback.await('Renewed-Weathersync:server:setEventTime', false, index, input[1])
                        if time then
                            weatherEvent.time = time
                        end
                    end
                    RefreshWeatherMenu()
                end
            },
            {
                title = 'Remove Weather Event',
                arrow = true,
                icon = 'fa-solid fa-circle-xmark',
                onSelect = function()
                    TriggerServerEvent('Renewed-Weather:server:removeWeatherEvent', index)
                    table.remove(currentWeatherTable, index)
                    RefreshWeatherMenu()
                end
            }
        }
    })
    lib.showContext('Renewed-Weathersync:client:changeWeather')
end

RegisterNetEvent('Renewed-Weather:client:viewWeatherInfo',function(weatherTable)

        currentWeatherTable = weatherTable

        local options = {}
        local amt = 0
        local startingIn = 0

        for i = 1, #weatherTable do

            local currentWeather = weatherTable[i]
            amt += 1
            local isQueued = i > 1
            local weatherLabel = GetWeatherLabel(currentWeather.weather)
            local metadata = isQueued and {

                ('Starting in %s minutes'):format(startingIn),

                ('Lasting for %s minutes'):format(currentWeather.time)

            } or {

                ('%s Minutes Remaining'):format(currentWeather.time)
            }

            options[amt] = {

                title = isQueued
                    and ('Upcoming Weather: %s'):format(weatherLabel)

                    or ('Current Weather: %s'):format(weatherLabel),

                description = isQueued and ('Starting in %s minutes'):format(startingIn),

                arrow = true,
                icon = isQueued and 'fa-solid fa-cloud-arrow-up' or 'fa-solid fa-cloud',
                metadata = metadata,
                onSelect = function()
                    viewWeatherEvent( i, currentWeather, isQueued)
                end
            }
            startingIn += currentWeather.time
        end
        lib.registerContext({
            id = 'Renewed-Weathersync:client:manageWeather',
            title = 'Weather Management',
            options = options
        })
        lib.showContext(
            'Renewed-Weathersync:client:manageWeather'
        )
    end
)
