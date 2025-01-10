---@diagnostic disable: undefined-global

local hyper = { "alt", "ctrl" }

local function positionWindow(x, y, w, h)
	return function()
		local win = hs.window.focusedWindow()
		if win then
			local f = win:frame()
			local s = win:screen():frame()
			f.x = s.x + s.w * x
			f.y = s.y + s.h * y
			f.w = s.w * w
			f.h = s.h * h
			win:setFrame(f)
		end
	end
end

-- Settings
hs.autoLaunch(true)
hs.automaticallyCheckForUpdates(false)
hs.consoleOnTop(false)
hs.dockIcon(false)
hs.menuIcon(false)
hs.uploadCrashData(false)
hs.window.animationDuration = 0

-- Window management
hs.hotkey.bind(hyper, "h", positionWindow(0, 0, 1 / 2, 1))
hs.hotkey.bind(hyper, "l", positionWindow(1 / 2, 0, 1 / 2, 1))
hs.hotkey.bind(hyper, "j", positionWindow(0, 1 / 2, 1, 1 / 2))
hs.hotkey.bind(hyper, "k", positionWindow(0, 0, 1, 1 / 2))
hs.hotkey.bind(hyper, "u", positionWindow(0, 0, 1 / 2, 1 / 2))
hs.hotkey.bind(hyper, "i", positionWindow(1 / 2, 0, 1 / 2, 1 / 2))
hs.hotkey.bind(hyper, "n", positionWindow(0, 1 / 2, 1 / 2, 1 / 2))
hs.hotkey.bind(hyper, "m", positionWindow(1 / 2, 1 / 2, 1 / 2, 1 / 2))
hs.hotkey.bind(hyper, "a", positionWindow(1 / 12, 1 / 16, 10 / 12, 10 / 12))
hs.hotkey.bind(hyper, "c", function()
	hs.window.focusedWindow():centerOnScreen(nil, true, 0)
end)
hs.hotkey.bind(hyper, "return", positionWindow(0, 0, 1, 1))
