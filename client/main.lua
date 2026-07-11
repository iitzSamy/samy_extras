lib.locale()
local config = require 'config.main'

local function GetVehicleName(veh)
    return GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh)))
end

local function AddToggleOption(options, id, label, selected, cb)
    options[#options + 1] = {
        title = locale('toggle_option_title'):format(id, label or locale('null_label')),
        icon = selected and "toggle-on" or "toggle-off",
        onSelect = cb
    }
end

local function UseLivery(veh)
    SetVehicleModKit(veh, 0)
    local options = {}
    local currentSticker, currentLivery = GetVehicleMod(veh, 48), GetVehicleLivery(veh)

    for i = 0, GetNumVehicleMods(veh, 48) - 1 do
        AddToggleOption(options, i, GetLabelText(GetModTextLabel(veh, 48, i)), currentSticker == i, function()
            SetVehicleMod(veh, 48, i)
            UseLivery(veh)
        end)
    end
    for i = 0, GetVehicleLiveryCount(veh) - 1 do
        AddToggleOption(options, i, GetLabelText(GetLiveryName(veh, i)), currentLivery == i, function()
            SetVehicleLivery(veh, i)
            UseLivery(veh)
        end)
    end

    lib.registerContext({id = "liveries_menu", menu = 'samy_extras', title = locale('liveries_menu_title'):format(GetVehicleName(veh)), options = options})
    lib.showContext("liveries_menu")
end

local function UseExtras(veh)
    local options = {}

    for extraID = 0, 20 do
        if DoesExtraExist(veh, extraID) then
            local isOn = IsVehicleExtraTurnedOn(veh, extraID)
            AddToggleOption(options, extraID, nil, isOn, function()
                SetVehicleExtra(veh, extraID, isOn and 1 or 0)
                UseExtras(veh)
            end)
        end
    end
    if #options == 0 then return end

    lib.registerContext({ id = "extras_menu", menu = 'samy_extras', title = locale('extras_menu_title'):format(GetVehicleName(veh)), options = options })
    lib.showContext("extras_menu")
end

RegisterCommand("extras", function()
    local veh = cache.vehicle
    if not veh then return end
    lib.registerContext({
        id = 'samy_extras',
        title = locale('car_menu_title'),
        canClose = true,
        options = {
            { title = locale('extras_option_title'), description = locale('extras_option_desc'), disabled = config.DisableExtrasIfDamaged and IsVehicleDamaged(veh), onSelect = function() UseExtras(veh) end },
            { title = locale('livery_option_title'), description = locale('livery_option_desc'), onSelect = function() UseLivery(veh) end }
        }
    })
    lib.showContext('samy_extras')
end)

exports('UseLivery', UseLivery)
exports('UseExtras', UseExtras)