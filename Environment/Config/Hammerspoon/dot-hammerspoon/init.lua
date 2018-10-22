--------------------------TABLE OF CONTENTS-----------------------------

---  CONFIG   -- global configuration settings
---  GLOBALS  -- global functions & variables for later usage
---  BIND     -- key bindings for window movement, etc.
---  LAYOUT   -- application-specific(!) layout configuration
---  DEFAULT  -- default specific screen configurations to layouts
---  SOURCE   -- load configurations from other files
---  APPENDIX -- documentation for modifying file

------------------------------------------------------------------------


------------------------------  CONFIG  --------------------------------

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


-------------------------------  BIND  ---------------------------------

-- Halves
---------

--- Conventions:
--    cmd is prefix for everything
--    control means "will move"
--    shift means "will change size"
--    using them together combines functionality
prefix = {
   focus  = {"cmd"},
   move   = {"cmd", "control"},
   resize = {"cmd", "shift"},
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

hs.hotkey.bind(prefix.resize, "Up", function()
      modifyFocused(function(windowFrame, screenFrame)
            windowFrame.x1 = screenFrame.x1
            windowFrame.x2 = screenFrame.x2
            windowFrame.y1 = screenFrame.y1
            windowFrame.y2 = screenFrame.h / 2
      end)
end)


hs.hotkey.bind(prefix.resize, "pad8", function()
      modifyFocused(function(windowFrame, screenFrame)
            windowFrame.x1 = screenFrame.x1
            windowFrame.x2 = screenFrame.x2
            windowFrame.y1 = screenFrame.y1
            windowFrame.y2 = screenFrame.h / 2
      end)
end)


hs.hotkey.bind(prefix.resize, "Right", function()
      modifyFocused(function(windowFrame, screenFrame)
            newWidth = screenFrame.w / 2
            windowFrame.x1 = screenFrame.x2 - newWidth
            windowFrame.w = newWidth
            windowFrame.y1 = screenFrame.y1
            windowFrame.y2 = screenFrame.y2
      end)
end)


hs.hotkey.bind(prefix.resize, "pad6", function()
      modifyFocused(function(windowFrame, screenFrame)
            newWidth = screenFrame.w / 2
            windowFrame.x1 = screenFrame.x2 - newWidth
            windowFrame.w = newWidth
            windowFrame.y1 = screenFrame.y1
            windowFrame.y2 = screenFrame.y2
      end)
end)


hs.hotkey.bind(prefix.resize, "Down", function()
      modifyFocused(function(windowFrame, screenFrame)
            windowFrame.x1 = screenFrame.x1
            windowFrame.x2 = screenFrame.x2
            windowFrame.y1 = screenFrame.h / 2
            windowFrame.y2 = screenFrame.y2
      end)
end)


hs.hotkey.bind(prefix.resize, "pad2", function()
      modifyFocused(function(windowFrame, screenFrame)
            windowFrame.x1 = screenFrame.x1
            windowFrame.x2 = screenFrame.x2
            windowFrame.y1 = screenFrame.h / 2
            windowFrame.y2 = screenFrame.y2
      end)
end)


hs.hotkey.bind(prefix.resize, "Left", function()
      modifyFocused(function(windowFrame, screenFrame)
            newWidth = screenFrame.w / 2
            windowFrame.x1 = screenFrame.x1
            windowFrame.w = newWidth
            windowFrame.y1 = screenFrame.y1
            windowFrame.y2 = screenFrame.y2
      end)
end)


hs.hotkey.bind(prefix.resize, "pad4", function()
      modifyFocused(function(windowFrame, screenFrame)
            newWidth = screenFrame.w / 2
            windowFrame.x1 = screenFrame.x1
            windowFrame.w = newWidth
            windowFrame.y1 = screenFrame.y1
            windowFrame.y2 = screenFrame.y2
      end)
end)


hs.hotkey.bind(prefix.resize, "=", function()
      modifyFocused(function(windowFrame, screenFrame)
            windowFrame.x1 = screenFrame.x1
            windowFrame.x2 = screenFrame.x2
            windowFrame.y1 = screenFrame.y1
            windowFrame.y2 = screenFrame.y2
      end)
end)

hs.hotkey.bind(prefix.resize, "pad5", function()
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
