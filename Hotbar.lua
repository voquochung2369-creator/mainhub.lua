local Hub = _G.CustomHub

if not Hub or not Hub.Window then
    warn("CustomHub Main.lua chưa được load")
    return
end

local Window = Hub.Window

local Tabs = {
    {
        Name = "Blox Fruit",
        Slot = 1,
        Link = "https://raw.githubusercontent.com/voquochung2369-creator/mainhub.lua/refs/heads/main/BloxFruit.lua"
    },

    {
        Name = "ESP",
        Slot = 2,
        Link = "https://raw.githubusercontent.com/voquochung2369-creator/mainhub.lua/refs/heads/main/ESP.lua"
    },

    {
        Name = "Test",
        Slot = 3,
        Link = "https://raw.githubusercontent.com/voquochung2369-creator/mainhub.lua/refs/heads/main/Test.lua"
    },

    {
        Name = "Setting",
        Slot = 4,
        Link = "https://raw.githubusercontent.com/voquochung2369-creator/mainhub.lua/refs/heads/main/Setting.lua"
    }
}

for _, Data in ipairs(Tabs) do

    local Tab = Window:MakeTab({
        Name = Data.Name,
        Icon = "",
        PremiumOnly = false,
        Slot = Data.Slot
    })

    local Success, Error = pcall(function()

        local Source = game:HttpGet(Data.Link)

        local Script, CompileError = loadstring(Source)

        if not Script then
            error(
                Data.Name
                .. ".lua compile error: "
                .. tostring(CompileError)
            )
        end

        Script(Tab)

    end)

    if not Success then
        warn(
            "[" .. Data.Name .. "] Load Error:",
            Error
        )
    end
end
