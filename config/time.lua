return {
    timeScale = 3500, -- How many milliseconds per minute in GTA time (2000ms is normal for a 48 minute day)

    useNightScale = true, -- If true, the server will use timeScaleNight to alter the time during night
    timeScaleNight = 7000, -- How many milliseconds per minute in GTA time DURING NIGHT

    nightTime = {
        beginning = 21,
        ending = 6
    },

    useRealTime = false, -- If true, the server will override all other configs and use the servers real time.

    startUpTime = {
        hour = 7,
        minute = 0
    }
}

