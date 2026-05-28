return {

    useScheduledWeather = true, -- Do you want txAdmin to schedule custom rain and thunder near restart?
    serverDuration = 14, -- How many hours will the server run before restarting?, if a server restarts every 8 hours put this to 9 etc.
    weatherCycletimer = 30, -- How many minutes between weather changes

    timeBetweenRain = 180, -- How many minutes between rain events
    rainAfterRestart = 60, -- How many minutes AFTER a server restart before rain will start to show?

    decemberSnow = true, -- if turned on means that only snow will happen in december

    useStaticWeather = true,
    staticWeather = {
        ['BLIZZARD'] = 0.05,
        ['CLEAR'] = 0.01,
        ['CLEARING'] = 0.03,
        ['CLOUDS'] = 0.12,
        ['EXTRASUNNY'] = 0.02,
        ['FOGGY'] = 0.18,
        ['NEUTRAL'] = 0.08,
        ['OVERCAST'] = 0.22,
        ['RAIN'] = 0.12,
        ['RAIN_HALLOWEEN'] = 0.12,
        ['SMOG'] = 0.20,
        ['SNOW'] = 0.01,
        ['SNOWLIGHT'] = 0.01,
        ['SNOW_HALLOWEEN'] = 0.07,
        ['THUNDER'] = 0.10,
        ['XMAS'] = 0.01
    },



    useWeatherSequences = true,

    weatherSequences = {

        { -- Sunny
            probability = 0.1, -- 10%
            events = {
                {
                    weather = 'SMOG',
                    time = math.random(3, 10), -- Minutes
                    windSpeed = 0.05,
                },
                {
                    weather = 'CLEAR',
                    time = math.random(5, 10), -- Minutes
                    windSpeed = 0.1,
                },
                {
                    weather = 'EXTRASUNNY',
                    time = math.random(3, 10), -- Minutes
                    windSpeed = 0.05,
                }
            },
        },

        { -- cloudy
            probability = 0.10, -- 10%
            events = {
                {
                    weather = 'OVERCAST',
                    time = math.random(5, 10),
                    windSpeed = 0.1,
                },
                {
                    weather = 'CLOUDS',
                    time = math.random(3, 10),
                    windSpeed = 0.05,
                }
            },
        },

        { -- snowing
            probability = 0.3, -- 30%
            month = 12, -- What month can there be snow?
            events = {
                {
                    weather = 'OVERCAST',
                    time = math.random(5, 10), -- Minutes
                    windSpeed = 0.0,
                },
                {
                    weather = 'SNOWLIGHT',
                    time = math.random(5, 10), -- Minutes
                    windSpeed = 0.1,
                },
                {
                    weather = 'SNOW',
                    time = math.random(3, 7), -- Minutes
                    windSpeed = 0.3,
                },
                {
                    weather = 'SNOWLIGHT',
                    time = math.random(5, 10), -- Minutes
                    windSpeed = 0.1,
                },
                {
                    weather = 'OVERCAST',
                    time = math.random(3, 7), -- Minutes
                    windSpeed = 0.0,
                },
                {
                    weather = 'CLOUDS',
                    time = math.random(3, 7), -- Minutes
                    windSpeed = 0.0,
                },
            },
        },

        { -- snowstorm
            probability = 0.30, -- 30%
            windDirection = 120.0, -- Storms come from the south
            month = 12, -- What month can there be snow?
            events = {
                {
                    weather = 'OVERCAST',
                    time = math.random(5, 10), -- Minutes
                    windSpeed = 0.5,
                },
                {
                    weather = 'SNOWLIGHT',
                    time = math.random(3, 7), -- Minutes
                    windSpeed = 1.0,
                },
                {
                    weather = 'SNOW',
                    time = math.random(3, 7), -- Minutes
                    windSpeed = 1.0,
                },
                {
                    weather = 'SNOW',
                    time = math.random(5, 10), -- Minutes
                    windSpeed = 1.0,
                    hasSnow = true,
                },
                {
                    weather = 'BLIZZARD',
                    time = 14, -- Minutes
                    windSpeed = 3.0,
                    hasSnow = true,
                },
                {
                    weather = 'SNOW',
                    time = 15, -- Minutes
                    windSpeed = 2.0,
                    hasSnow = true,
                },
                {
                    weather = 'SNOWLIGHT',
                    time = 20, -- Minutes
                    windSpeed = 1.0,
                    hasSnow = true,
                },
                {
                    weather = 'OVERCAST',
                    windSpeed = 0.5,
                    time = 15, -- Minutes
                    hasSnow = true,
                },
                {
                    weather = 'CLOUDS',
                    windSpeed = 0.5,
                    time = 15, -- Minutes
                    hasSnow = true,
                },
                {
                    weather = 'CLEAR',
                    windSpeed = 0.5,
                    time = 15, -- Minutes
                    hasSnow = true,
                },
                {
                    weather = 'EXTRASUNNY',
                    time = 15, -- minutes
                    windSpeed = 0.5,
                },
            },
        },

        { -- rainshower
            probability = 0.1, -- 10%
            windDirection = 240.0, -- Storms come from the south
            events = {
                {
                    weather = 'CLOUDS',
                    time = math.random(3, 7), -- Minutes
                    windSpeed = 0.5,
                },
                {
                    weather = 'OVERCAST',
                    time = math.random(3, 7), -- Minutes
                    windSpeed = 1.0,
                },
                {
                    weather = 'RAIN',
                    time = math.random(5, 10), -- Minutes
                    windSpeed = 2.0,
                },
                {
                    weather = 'CLEARING',
                    time = math.random(3, 7), -- Minutes
                    windSpeed = 1.0,
                },
                {
                    weather = 'CLOUDS',
                    time = math.random(5, 10), -- Minutes
                    windSpeed = 0.5,
                },
                {
                    weather = 'EXTRASUNNY',
                    time = math.random(5, 10),
                    windSpeed = 0.0,
                },
            },
        },

        { -- rainstorm
            probability = 0.10, -- 10%
            windDirection = 280.0, -- Storms come from the south
            events = {
                {
                    weather = 'CLOUDS',
                    time = math.random(3, 7), -- Minutes
                    windSpeed = 0.5,
                },
                {
                    weather = 'OVERCAST',
                    time = math.random(3, 7), -- Minutes
                    windSpeed = 1.0,
                },
                {
                    weather = 'RAIN',
                    time = math.random(5, 10), -- Minutes
                    windSpeed = 3.5,
                },
                {
                    weather = 'CLEARING',
                    time = math.random(3, 7), -- Minutes
                    windSpeed = 1.5,
                },
                {
                    weather = 'CLOUDS',
                    time = math.random(3, 7),
                    windSpeed = 0.5,
                },
            },
        },

        { -- smallstorm
            probability = 0.10, -- 10%
            windDirection = 120.0, -- Storms come from the south
            events = {
                {
                    weather = 'CLOUDS',
                    time = math.random(3, 7),
                    windSpeed = 0.5,
                },
                {
                    weather = 'RAIN',
                    time = math.random(3, 7),
                    windSpeed = 1.0,
                },
                {
                    weather = 'THUNDER',
                    time = math.random(3, 7),
                    windSpeed = 3.0,
                },
                {
                    weather = 'RAIN',
                    time = math.random(5, 10), -- Minutes
                    windSpeed = 2.0,
                },
                {
                    weather = 'CLEARING',
                    time = math.random(3, 7),
                    windSpeed = 1.0,
                },
                {
                    weather = 'EXTRASUNNY',
                    time = math.random(5, 10),
                    windSpeed = 0.5,
                },
            },
        },

        { -- bigstorm
            windDirection = 180.0, -- Storms come from the south
            probability = 0.10, -- 10%
            events = {
                {
                    weather = 'OVERCAST',
                    time = math.random(3, 7),
                    windSpeed = 4.0,
                },
                {
                    weather = 'RAIN',
                    time = math.random(3, 7),
                    windSpeed = 8.0,
                },
                {
                    weather = 'THUNDER',
                    time = math.random(3, 7),
                    windSpeed = 12.0,
                },
                {
                    weather = 'RAIN',
                    time = math.random(3, 7),
                    windSpeed = 12.0,
                },
                {
                    weather = 'THUNDER',
                    time = math.random(3, 7),
                    windSpeed = 12.0,
                },
                {
                    weather = 'CLEARING',
                    time = math.random(3, 7),
                    windSpeed = 3.0,
                },
                {
                    weather = 'EXTRASUNNY',
                    time = math.random(3, 7),
                    windSpeed = 0.0,
                },
            },
        },
    }
}





