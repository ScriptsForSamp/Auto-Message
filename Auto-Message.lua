require "lib.moonloader"
local se = require "samp.events"
local encoding = require 'encoding'
encoding.default = 'CP1251'
local imgui = require 'imgui'
local key = require 'vkeys'
local u8 = encoding.UTF8
local main_window_state = imgui.ImBool(false)
local msg = imgui.ImBuffer(256)
local cmd = imgui.ImBuffer(258)
local Interval = imgui.ImInt(0)
local CountUser = imgui.ImInt(0)
local Count = 0

imgui.SwitchContext()
local style = imgui.GetStyle()
local colors = style.Colors
local clr = imgui.Col
local ImVec4 = imgui.ImVec4

colors[clr.Text] = ImVec4(1.00, 1.00, 1.00, 1.00)
colors[clr.TextDisabled] = ImVec4(0.60, 0.60, 0.60, 1.00)
colors[clr.WindowBg] = ImVec4(0.11, 0.10, 0.11, 1.00)
colors[clr.ChildWindowBg] = ImVec4(0.00, 0.00, 0.00, 0.00)
colors[clr.PopupBg] = ImVec4(0.00, 0.00, 0.00, 0.00)
colors[clr.Border] = ImVec4(0.86, 0.86, 0.86, 1.00)
colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00)
colors[clr.FrameBg] = ImVec4(0.21, 0.20, 0.21, 0.60)
colors[clr.FrameBgHovered] = ImVec4(0.00, 0.46, 0.65, 1.00)
colors[clr.FrameBgActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
colors[clr.TitleBg] = ImVec4(0.00, 0.46, 0.65, 1.00)
colors[clr.TitleBgCollapsed] = ImVec4(0.00, 0.46, 0.65, 1.00)
colors[clr.TitleBgActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
colors[clr.MenuBarBg] = ImVec4(0.00, 0.46, 0.65, 1.00)
colors[clr.ScrollbarBg] = ImVec4(0.00, 0.46, 0.65, 0.00)
colors[clr.ScrollbarGrab] = ImVec4(0.00, 0.46, 0.65, 0.44)
colors[clr.ScrollbarGrabHovered] = ImVec4(0.00, 0.46, 0.65, 0.74)
colors[clr.ScrollbarGrabActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
colors[clr.ComboBg] = ImVec4(0.15, 0.14, 0.15, 1.00)
colors[clr.CheckMark] = ImVec4(0.00, 0.46, 0.65, 1.00)
colors[clr.SliderGrab] = ImVec4(0.00, 0.46, 0.65, 1.00)
colors[clr.SliderGrabActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
colors[clr.Button] = ImVec4(0.00, 0.46, 0.65, 1.00)
colors[clr.ButtonHovered] = ImVec4(0.00, 0.46, 0.65, 1.00)
colors[clr.ButtonActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
colors[clr.Header] = ImVec4(0.00, 0.46, 0.65, 1.00)
colors[clr.HeaderHovered] = ImVec4(0.00, 0.46, 0.65, 1.00)
colors[clr.HeaderActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
colors[clr.ResizeGrip] = ImVec4(1.00, 1.00, 1.00, 0.30)
colors[clr.ResizeGripHovered] = ImVec4(1.00, 1.00, 1.00, 0.60)
colors[clr.ResizeGripActive] = ImVec4(1.00, 1.00, 1.00, 0.90)
colors[clr.CloseButton] = ImVec4(1.00, 0.10, 0.24, 0.00)
colors[clr.CloseButtonHovered] = ImVec4(0.00, 0.10, 0.24, 0.00)
colors[clr.CloseButtonActive] = ImVec4(1.00, 0.10, 0.24, 0.00)
colors[clr.PlotLines] = ImVec4(0.00, 0.00, 0.00, 0.00)
colors[clr.PlotLinesHovered] = ImVec4(0.00, 0.00, 0.00, 0.00)
colors[clr.PlotHistogram] = ImVec4(0.00, 0.00, 0.00, 0.00)
colors[clr.PlotHistogramHovered] = ImVec4(0.00, 0.00, 0.00, 0.00)
colors[clr.TextSelectedBg] = ImVec4(0.00, 0.00, 0.00, 0.00)
colors[clr.ModalWindowDarkening] = ImVec4(0.00, 0.00, 0.00, 0.00)

function imgui.OnDrawFrame()
  if main_window_state.v then 
    imgui.SetNextWindowSize(imgui.ImVec2(400, 200), imgui.Cond.FirstUseEver)
    imgui.Begin('Auto-Message', main_window_state)
    imgui.InputText("Message", msg)
    imgui.InputText("Chat Command", cmd)
    imgui.InputInt("Interval (In Milliseconds 1 sec. = 1000milisec.)", Interval)
    imgui.InputInt("Message Send Count", CountUser)
    if imgui.Button("START SCRIPT") then
      Count = 0
      lua_thread.create(function()
      repeat 
          sampSendChat(cmd.v .. " " .. u8:decode(msg.v))
          wait(Interval.v)
          Count = Count + 1
        until Count == CountUser.v
      end)
    end
    imgui.End()
  end
end

function main()
 while true do
    wait(0)
    if wasKeyPressed(key.VK_K) then
        main_window_state.v = not main_window_state.v 
    end
    imgui.Process = main_window_state.v
  end
end