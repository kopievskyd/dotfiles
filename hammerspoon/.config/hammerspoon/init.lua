---@diagnostic disable: undefined-global

local function pressFn(mods, key)
	if key == nil then
		key = mods
		mods = {}
	end
	return function()
		hs.eventtap.keyStroke(mods, key, 1000)
	end
end

-- Settings
hs.autoLaunch(true)
hs.automaticallyCheckForUpdates(false)
hs.consoleOnTop(false)
hs.dockIcon(false)
hs.menuIcon(false)
hs.uploadCrashData(false)

-- Ctrl + hjkl to arrow keys
hs.hotkey.bind("ctrl", "h", pressFn("left"), nil, pressFn("left"))
hs.hotkey.bind("ctrl", "j", pressFn("down"), nil, pressFn("down"))
hs.hotkey.bind("ctrl", "k", pressFn("up"), nil, pressFn("up"))
hs.hotkey.bind("ctrl", "l", pressFn("right"), nil, pressFn("right"))