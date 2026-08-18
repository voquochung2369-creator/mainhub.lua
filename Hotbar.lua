local Hub =
    _G.CustomHub

if not Hub then

    warn(
        "CustomHub Main.lua chưa được load"
    )

    return
end

local Window =
    Hub.Window

--------------------------------------------------
-- LINK
--------------------------------------------------

local BLOXFRUIT_URL =
    "https://raw.githubusercontent.com/voquochung2369-creator/mainhub.lua/refs/heads/main/BloxFruit.lua"

local ESP_URL =
    "https://raw.githubusercontent.com/voquochung2369-creator/mainhub.lua/refs/heads/main/ESP.lua"

local SETTING_URL =
    "https://raw.githubusercontent.com/voquochung2369-creator/mainhub.lua/refs/heads/main/Setting.lua"

--------------------------------------------------
-- BLOX FRUIT TAB
--------------------------------------------------

Window:MakeTab({

    Name =
        "Blox Fruit",

    Icon =
        "",

    PremiumOnly =
        false,

    Slot =
        1,

    Link =
        BLOXFRUIT_URL
})

--------------------------------------------------
-- ESP TAB
--------------------------------------------------

Window:MakeTab({

    Name =
        "ESP",

    Icon =
        "",

    PremiumOnly =
        false,

    Slot =
        2,

    Link =
        ESP_URL
})

--------------------------------------------------
-- SETTING TAB
--------------------------------------------------

Window:MakeTab({

    Name =
        "Setting",

    Icon =
        "",

    PremiumOnly =
        false,

    Slot =
        3,

    Link =
        SETTING_URL
})
