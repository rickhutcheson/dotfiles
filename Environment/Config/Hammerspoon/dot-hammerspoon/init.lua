--------------------------TABLE OF CONTENTS-----------------------------

---  CONFIG   -- global configuration settings
---  GLOBALS  -- global functions & variables for later usage
---  BIND     -- key bindings for window movement, etc.
---  LAYOUT   -- application-specific(!) layout configuration
---  DEFAULT  -- default specific screen configurations to layouts
---  SOURCE   -- load configurations from other files
---  APPENDIX -- documentation for modifying file

------------------------------------------------------------------------

-----------------------------  CONFIG  ---------------------------------


----------------------------  CAFFEINE  --------------------------------

-- See: http://www.hammerspoon.org/go/#simplemenubar

caffeine = hs.menubar.new()
function setCaffeineDisplay(state)
    if state then
        caffeine:setTitle("☕")   -- coffee cup icon
    else
        caffeine:setTitle("💤")  -- zzz icon
    end
end

function caffeineClicked()
    setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if caffeine then
    caffeine:setClickCallback(caffeineClicked)
    setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end

-----------------------------  BATTERY  --------------------------------
-- Watcher to ensure that Macbook doesn't surprise me by being dead in
-- the morning when I wake up.

MINIMUM_PERCENT = 5
function sleepOnBatteryLow()
   currentPercent = hs.battery.percentage()
   if currentPercent < MINIMUM_PERCENT and not hs.battery.isCharging() then
      hs.notify.show("Sleepy Time!", "Pay more attention", string.format(
                        "Had to sleep the system. Your battery was at %f!", currentPercent))
      hs.caffeinate.systemSleep()
   end
end

hs.battery.watcher.new(sleepOnBatteryLow):start()

-----------------------------  GLOBALS  --------------------------------

function moveToScreenTop(windowFrame, screenFrame)
   windowFrame.y = screenFrame.y
end

function moveToScreenLeft(windowFrame, screenFrame)
   -- macOS tries to add a padding buffer around windows on the
   -- left side (presumably because of the dock)
   -- This -2 offset forces the window (mostly) flush
   windowFrame.x = screenFrame.x - 2
end

function moveToScreenBottom(windowFrame, screenFrame)
   originalHeight = windowFrame.h
   windowFrame.y1 = screenFrame.y2 - originalHeight
   windowFrame.y2 = screenFrame.y2
end

function moveToScreenRight(windowFrame, screenFrame)
   originalWidth = windowFrame.w
   windowFrame.x1 = screenFrame.x2 - originalWidth
end

function resizeQuarter(windowFrame, screenFrame)
   windowFrame.w = screenFrame.w / 2
   windowFrame.h = screenFrame.h / 2
end

function getFocusedWindowInScreen()
   local win = hs.window.focusedWindow()
   local screen = win:screen()
   if win == nil then
      return nil, nil
   end
   return win, screen
end

function extractFrames(window, screen)
   return window:frame(), screen:frame()
end

function modifyFocused(modifier)
   local window, screen = getFocusedWindowInScreen()
   if window == nil then
      return
   end
   local windowFrame, screenFrame = extractFrames(window, screen)
   modifier(windowFrame, screenFrame)
   window:setFrame(windowFrame)
end

function extendedModifyFocused(modifier)
   local window, screen = getFocusedWindowInScreen()
   if window == nil then
      return
   end
   local windowFrame, screenFrame = extractFrames(window, screen)
   modifier(window, screen)
end

function resizeFull(windowFrame, screenFrame)
   windowFrame.x1 = screenFrame.x1
   windowFrame.x2 = screenFrame.x2
   windowFrame.y1 = screenFrame.y1
   windowFrame.y2 = screenFrame.y2
end


-------------------------------  BIND  ---------------------------------

-- Halves
---------

--- Conventions:
--    cmd is prefix for everything
--    option means "will move"
--    shift means "will change size"
--    using them together combines functionality
prefix = {
   focus  = {"cmd", "option"},
   move   = {"cmd", "control"},
   resizeHalf = {"cmd", "shift"},
   resizeThird = {"cmd", "option", "shift"},
   quadrant = {"cmd", "control", "option"}
}


-- With "focus" prefix, we only switch focus by direction

hs.hotkey.bind(prefix.focus, "Up", function()
    hs.window.focusWindowNorth(nil, nil, true)
end)

hs.hotkey.bind(prefix.focus, "Right", function()
    hs.window.focusWindowEast(nil, nil, true)
end)

hs.hotkey.bind(prefix.focus, "Down", function()
    hs.window.focusWindowSouth(nil, nil, true)
end)

hs.hotkey.bind(prefix.focus, "Left", function()
    hs.window.focusWindowWest(nil, nil, true)
end)


-- Move without resizing

hs.hotkey.bind(prefix.move, "Up", function()
      modifyFocused(function(windowFrame, screenFrame)
            moveToScreenTop(windowFrame, screenFrame)
      end)
end)

hs.hotkey.bind(prefix.move, "Right", function()
      modifyFocused(function(windowFrame, screenFrame)
           moveToScreenRight(windowFrame, screenFrame)
      end)
end)

hs.hotkey.bind(prefix.move, "Down", function()
      modifyFocused(function(windowFrame, screenFrame)
            moveToScreenBottom(windowFrame, screenFrame)
      end)
end)

hs.hotkey.bind(prefix.move, "Left", function()
      modifyFocused(function(windowFrame, screenFrame)
            moveToScreenLeft(windowFrame, screenFrame)
      end)
end)


-- Resize to quadrants

hs.hotkey.bind(prefix.quadrant, "Up", function()
      modifyFocused(function(windowFrame, screenFrame)
            resizeQuarter(windowFrame, screenFrame)
            moveToScreenLeft(windowFrame, screenFrame)
            moveToScreenTop(windowFrame, screenFrame)
      end)
end)

hs.hotkey.bind(prefix.quadrant, "pad7", function()
      modifyFocused(function(windowFrame, screenFrame)
            resizeQuarter(windowFrame, screenFrame)
            moveToScreenLeft(windowFrame, screenFrame)
            moveToScreenTop(windowFrame, screenFrame)
      end)
end)

hs.hotkey.bind(prefix.quadrant, "pad9", function()
      modifyFocused(function(windowFrame, screenFrame)
            resizeQuarter(windowFrame, screenFrame)
            moveToScreenTop(windowFrame, screenFrame)
            moveToScreenRight(windowFrame, screenFrame)
      end)
end)

hs.hotkey.bind(prefix.quadrant, "pad1", function()
      modifyFocused(function(windowFrame, screenFrame)
            resizeQuarter(windowFrame, screenFrame)
            moveToScreenBottom(windowFrame, screenFrame)
            moveToScreenLeft(windowFrame, screenFrame)
      end)
end)


hs.hotkey.bind(prefix.quadrant, "pad3", function()
      modifyFocused(function(windowFrame, screenFrame)
            resizeQuarter(windowFrame, screenFrame)
            moveToScreenBottom(windowFrame, screenFrame)
            moveToScreenRight(windowFrame, screenFrame)
      end)
end)


hs.hotkey.bind(prefix.quadrant, "Down", function()
      modifyFocused(function(windowFrame, screenFrame)
            resizeQuarter(windowFrame, screenFrame)
            moveToScreenBottom(windowFrame, screenFrame)
            moveToScreenRight(windowFrame, screenFrame)
      end)
end)



-- Resize to halves

hs.hotkey.bind(prefix.resizeHalf, "Up", function()
      modifyFocused(function(windowFrame, screenFrame)
            windowFrame.x1 = screenFrame.x1
            windowFrame.x2 = screenFrame.x2
            windowFrame.y1 = screenFrame.y1
            windowFrame.y2 = screenFrame.h / 2
      end)
end)


hs.hotkey.bind(prefix.resizeHalf, "pad8", function()
      modifyFocused(function(windowFrame, screenFrame)
            windowFrame.x1 = screenFrame.x1
            windowFrame.x2 = screenFrame.x2
            windowFrame.y1 = screenFrame.y1
            windowFrame.y2 = screenFrame.h / 2
      end)
end)


hs.hotkey.bind(prefix.resizeHalf, "Right", function()
      modifyFocused(function(windowFrame, screenFrame)
            halfWidth = screenFrame.w / 2
            thirdWidth = screenFrame.w / 3
            currentWidth = windowFrame.x2 - windowFrame.x1
            notFullHeight = math.abs(windowFrame.h - screenFrame.h) > 4
            if math.abs(windowFrame.x2 - screenFrame.x2) > 4 or notFullHeight then
               -- default; if we're not even ON the right side of
               -- the screen, then we shouldn't be toggling size,
               -- we should just assume we wanna get over there
               newWidth = halfWidth
            elseif math.abs(currentWidth - halfWidth) < 10 then
               newWidth = thirdWidth
            elseif math.abs(currentWidth - thirdWidth) < 10 then
               newWidth = 2 * thirdWidth
            else
               newWidth = halfWidth
            end
            windowFrame.x1 = screenFrame.x2 - newWidth
            windowFrame.w = newWidth
            windowFrame.y1 = screenFrame.y1
            windowFrame.y2 = screenFrame.y2
      end)
end)


hs.hotkey.bind(prefix.resizeHalf, "pad6", function()
      modifyFocused(function(windowFrame, screenFrame)
            newWidth = screenFrame.w / 2
            windowFrame.x1 = screenFrame.x2 - newWidth
            windowFrame.w = newWidth
            windowFrame.y1 = screenFrame.y1
            windowFrame.y2 = screenFrame.y2
      end)
end)


hs.hotkey.bind(prefix.resizeHalf, "Down", function()
      modifyFocused(function(windowFrame, screenFrame)
            windowFrame.x1 = screenFrame.x1
            windowFrame.x2 = screenFrame.x2
            windowFrame.y1 = screenFrame.h / 2
            windowFrame.y2 = screenFrame.y2
      end)
end)


hs.hotkey.bind(prefix.resizeHalf, "pad2", function()
      modifyFocused(function(windowFrame, screenFrame)
            windowFrame.x1 = screenFrame.x1
            windowFrame.x2 = screenFrame.x2
            windowFrame.y1 = screenFrame.h / 2
            windowFrame.y2 = screenFrame.y2
      end)
end)


hs.hotkey.bind(prefix.resizeHalf, "Left", function()
      modifyFocused(function(windowFrame, screenFrame)
            halfWidth = screenFrame.w / 2
            thirdWidth = screenFrame.w / 3
            currentWidth = windowFrame.x2 - windowFrame.x1
            notFullHeight = math.abs(windowFrame.h - screenFrame.h) > 4
            if windowFrame.x1 ~= screenFrame.x1 or notFullHeight then
               -- default; if we're not already filling the left side of
               -- the screen, then we shouldn't be toggling size,
               -- we should just assume we wanna get over there
               newWidth = halfWidth
            elseif math.abs(currentWidth - halfWidth) < 10 then
               newWidth = thirdWidth
            elseif math.abs(currentWidth - thirdWidth) < 10 then
               newWidth = 2 * thirdWidth
            else
               newWidth = halfWidth
            end
            windowFrame.x1 = screenFrame.x1
            windowFrame.w = newWidth
            windowFrame.y1 = screenFrame.y1
            windowFrame.y2 = screenFrame.y2
      end)
end)


hs.hotkey.bind(prefix.resizeHalf, "pad4", function()
      modifyFocused(function(windowFrame, screenFrame)
            newWidth = screenFrame.w / 2
            windowFrame.x1 = screenFrame.x1
            windowFrame.w = newWidth
            windowFrame.y1 = screenFrame.y1
            windowFrame.y2 = screenFrame.y2
      end)
end)


hs.hotkey.bind(prefix.resizeHalf, "=", function()
      modifyFocused(function(windowFrame, screenFrame)
            windowFrame.x1 = screenFrame.x1
            windowFrame.x2 = screenFrame.x2
            windowFrame.y1 = screenFrame.y1
            windowFrame.y2 = screenFrame.y2
      end)
end)

hs.hotkey.bind(prefix.resizeHalf, "pad5", function()
      modifyFocused(function(windowFrame, screenFrame)
            windowFrame.x1 = screenFrame.x1
            windowFrame.x2 = screenFrame.x2
            windowFrame.y1 = screenFrame.y1
            windowFrame.y2 = screenFrame.y2
      end)
end)

-- Resize to thirds

hs.hotkey.bind(prefix.resizeThird, "Up", function()
      modifyFocused(function(windowFrame, screenFrame)
            windowFrame.x1 = screenFrame.x1
            windowFrame.x2 = screenFrame.x2
            windowFrame.y1 = screenFrame.y1
            windowFrame.y2 = screenFrame.h / 3
      end)
end)


hs.hotkey.bind(prefix.resizeThird, "pad8", function()
      modifyFocused(function(windowFrame, screenFrame)
            windowFrame.x1 = screenFrame.x1
            windowFrame.x2 = screenFrame.x2
            windowFrame.y1 = screenFrame.y1
            windowFrame.y2 = screenFrame.h / 3
      end)
end)


hs.hotkey.bind(prefix.resizeThird, "Right", function()
      modifyFocused(function(windowFrame, screenFrame)
            newWidth = screenFrame.w / 3
            windowFrame.x1 = screenFrame.x2 - newWidth
            windowFrame.w = newWidth
            windowFrame.y1 = screenFrame.y1
            windowFrame.y2 = screenFrame.y2
      end)
end)


hs.hotkey.bind(prefix.resizeThird, "pad6", function()
      modifyFocused(function(windowFrame, screenFrame)
            newWidth = screenFrame.w / 3
            windowFrame.x1 = screenFrame.x2 - newWidth
            windowFrame.w = newWidth
            windowFrame.y1 = screenFrame.y1
            windowFrame.y2 = screenFrame.y2
      end)
end)


hs.hotkey.bind(prefix.resizeThird, "Down", function()
      modifyFocused(function(windowFrame, screenFrame)
            windowFrame.x1 = screenFrame.x1
            windowFrame.x2 = screenFrame.x2
            windowFrame.y1 = screenFrame.h / 3
            windowFrame.y2 = screenFrame.y2
      end)
end)


hs.hotkey.bind(prefix.resizeThird, "pad2", function()
      modifyFocused(function(windowFrame, screenFrame)
            windowFrame.x1 = screenFrame.x1
            windowFrame.x2 = screenFrame.x2
            windowFrame.y1 = screenFrame.h / 3
            windowFrame.y2 = screenFrame.y2
      end)
end)


hs.hotkey.bind(prefix.resizeThird, "Left", function()
      modifyFocused(function(windowFrame, screenFrame)
            newWidth = screenFrame.w / 3
            windowFrame.x1 = screenFrame.x1
            windowFrame.w = newWidth
            windowFrame.y1 = screenFrame.y1
            windowFrame.y2 = screenFrame.y2
      end)
end)


hs.hotkey.bind(prefix.resizeThird, "pad4", function()
      modifyFocused(function(windowFrame, screenFrame)
            newWidth = screenFrame.w / 3
            windowFrame.x1 = screenFrame.x1
            windowFrame.w = newWidth
            windowFrame.y1 = screenFrame.y1
            windowFrame.y2 = screenFrame.y2
      end)
end)


hs.hotkey.bind(prefix.resizeThird, "=", function()
     modifyFocused(function(windowFrame, screenFrame)
         margin = screenFrame.w - windowFrame.w
         windowFrame.x1 = screenFrame.x1 + margin
         windowFrame.x1 = screenFrame.x2 - margin
         windowFrame.y1 = screenFrame.y1
         windowFrame.y2 = screenFrame.y2
      end)
end)


hs.hotkey.bind(prefix.resizeThird, "pad5", function()
      modifyFocused(function(windowFrame, screenFrame)
            windowFrame.x1 = screenFrame.x1
            windowFrame.x2 = screenFrame.x2
            windowFrame.y1 = screenFrame.y1
            windowFrame.y2 = screenFrame.y2
      end)
end)

-- Move window between screens

hs.hotkey.bind(prefix.quadrant, ".", function()
      local window, screen = getFocusedWindowInScreen()
      local next = screen:toEast()
      local wf, sf = extractFrames(window, next)
      moveToScreenLeft(wf, sf)
      moveToScreenTop(wf, sf)
      window:setFrame(wf)
end)

hs.hotkey.bind(prefix.quadrant, ",", function()
      local window, screen = getFocusedWindowInScreen()
      local next = screen:toWest()
      local wf, sf = extractFrames(window, next)
      moveToScreenLeft(wf, sf)
      moveToScreenTop(wf, sf)
      window:setFrame(wf)
end)


-------------------------------APPENDIX---------------------------------
-- +--------------------------------------------------------------------+
-- |   |                                                                |
-- |esc|                        ( f1 - f20 )                            |
-- +---------------------------------------------------------------------
-- +--------------------------------------------------------------------+
-- |    |                                      |    |    |              |
-- | `  |                                      | -  | =  |delete        |
-- +--------------------------------------------------------------------+
-- |       |                                      |    |    |           |
-- |tab    |                                      | [  | ]  |  backslash|
-- +--------------------------------------------------------------------+
-- |        |                                        |    |    |        |
-- |caps    |                                        | ;  | '  | return |
-- +--------------------------------------------------------------------+
-- |              |                       |    |    |    |              |
-- |    shift     |                       | ,  | .  | /  |     shift    |
-- +--------------------------------------------------------------------+
-- |       |       |    |                         |    |       |        |
-- |control|option |cmd |          space          |cmd |option |control |
-- +--------------------------------------------------------------------+
--
--
-- +-----------------------------+
-- |         |         |         |
-- |         |         |         |
-- |help     |home     |pageUp   |
-- |---------+---------+---------+
-- |         |         |         |
-- |         |         |         |
-- |delete   |end      |pageDown |
-- +---------+---------+---------+
--
--
--           +---------+
--           |         |
--           |         |
--           |   up    |
-- +---------+---------+---------+
-- |         |         |         |
-- |         |         |         |
-- |  left   |  down   |  right  |
-- +---------+---------+---------+
--
--
-- +---------------------------------------+
-- |         |         |         |         |
-- |         |         |         |         |
-- |padClear |pad=     |pad/     |pad*     |
-- |---------+---------+----------+--------|
-- |         |         |         |         |
-- |         |         |         |         |
-- |pad7     |pad8     |pad9     |pad-     |
-- |---------+---------+---------+---------|
-- |         |         |         |         |
-- |         |         |         |         |
-- |pad4     |pad5     |pad6     |pad+     |
-- |---------+---------+---------+---------|
-- |         |         |         |         |
-- |         |         |         |         |
-- |pad1     |pad2     |pad3     |         |
-- |-------------------+---------|         |
-- |                   |         |         |
-- |                   |         |         |
-- |pad0               |pad.     |padEnter |
-- +---------------------------------------+
