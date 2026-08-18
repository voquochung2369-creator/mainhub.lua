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
    "YOUR_RAW_BLOXFRUIT_URL"

local ESP_URL =
    "YOUR_RAW_ESP_URL"

local SETTING_URL =
    "YOUR_RAW_SETTING_URL"

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
