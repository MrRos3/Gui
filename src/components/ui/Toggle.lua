local Toggle = {}

local Creator = require("../../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local UserInputService = game:GetService("UserInputService")

function Toggle.New(Value, Icon, IconSize, Parent, Callback, NewElement, Config)
	local Toggle = {}

	-- Compact Windows 11-inspired toggle for dense settings panels.
	local ToggleWidth = NewElement and 40 or 38
	local ToggleHeight = NewElement and 20 or 19
	local ThumbSize = NewElement and 12 or 11
	local Inset = 4
	local Radius = ToggleHeight / 2
	local Travel = ToggleWidth - ThumbSize - (Inset * 2)

	local IconToggleFrame
	if Icon and Icon ~= "" then
		local iconData = Creator.Icon(Icon)
		if iconData then
			IconToggleFrame = New("ImageLabel", {
				Size = UDim2.fromOffset(math.min(8, IconSize or 8), math.min(8, IconSize or 8)),
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Image = iconData[1],
				ImageRectOffset = iconData[2].ImageRectPosition,
				ImageRectSize = iconData[2].ImageRectSize,
				ImageTransparency = 0.35,
				ImageColor3 = Color3.fromRGB(72, 72, 76),
				ZIndex = 7,
			})
		end
	end

	local ToggleContainer = New("Frame", {
		Size = UDim2.fromOffset(ToggleWidth, ToggleHeight),
		BackgroundTransparency = 1,
		Parent = Parent,
	})

	local ToggleFrame = Creator.NewRoundFrame(Radius, "Squircle", {
		ImageColor3 = Color3.fromRGB(45, 45, 50),
		ImageTransparency = 0,
		Parent = ToggleContainer,
		Size = UDim2.fromOffset(ToggleWidth, ToggleHeight),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Name = "ToggleFrame",
	}, {
		Creator.NewRoundFrame(Radius, "Squircle", {
			Size = UDim2.fromScale(1, 1),
			Name = "Layer",
			ThemeTag = {
				ImageColor3 = "Toggle",
			},
			ImageTransparency = 1,
			ZIndex = 1,
		}),

		Creator.NewRoundFrame(Radius, "SquircleOutline", {
			Size = UDim2.fromScale(1, 1),
			Name = "Stroke",
			ImageColor3 = Color3.fromRGB(150, 150, 156),
			ImageTransparency = 0.38,
			ZIndex = 2,
		}),

		Creator.NewRoundFrame(9999, "Squircle", {
			Size = UDim2.fromOffset(ThumbSize, ThumbSize),
			Position = UDim2.new(0, Inset, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			ImageTransparency = 1,
			Name = "Frame",
			ZIndex = 4,
		}, {
			Creator.NewRoundFrame(9999, "Squircle", {
				Size = UDim2.fromScale(1, 1),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				ImageColor3 = Color3.fromRGB(245, 245, 245),
				ImageTransparency = 0,
				Name = "Bar",
				ZIndex = 5,
			}, {
				New("UIScale", {
					Scale = 1,
				}),
				Creator.NewRoundFrame(9999, "SquircleOutline", {
					Size = UDim2.new(1, 1, 1, 1),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					ImageColor3 = Color3.fromRGB(20, 20, 22),
					ImageTransparency = 0.72,
					Name = "ThumbStroke",
					ZIndex = 6,
				}),
				IconToggleFrame,
			}),
		}),

		New("TextButton", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Name = "Hitbox",
			Text = "",
			ZIndex = 10,
		}),
	})

	local dragConnection
	local endConnection

	local function getThumbX(toggled)
		return Inset + (toggled and Travel or 0)
	end

	local function applyVisual(toggled, animate)
		local thumbPosition = UDim2.new(0, getThumbX(toggled), 0.5, 0)
		local layerTransparency = toggled and 0 or 1
		local strokeTransparency = toggled and 0.82 or 0.38

		if animate then
			Tween(ToggleFrame.Frame, 0.18, { Position = thumbPosition }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
			Tween(ToggleFrame.Layer, 0.16, { ImageTransparency = layerTransparency }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
			Tween(ToggleFrame.Stroke, 0.16, { ImageTransparency = strokeTransparency }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
		else
			ToggleFrame.Frame.Position = thumbPosition
			ToggleFrame.Layer.ImageTransparency = layerTransparency
			ToggleFrame.Stroke.ImageTransparency = strokeTransparency
		end
	end

	function Toggle:Set(Toggled, isCallback, isAnim)
		applyVisual(Toggled, not isAnim)

		isCallback = isCallback ~= false
		task.spawn(function()
			if Callback and isCallback then
				Creator.SafeCallback(Callback, Toggled)
			end
		end)
	end

	function Toggle:Animate(input, ToggleObj)
		if Config.Window.IsToggleDragging then
			return
		end

		Config.Window.IsToggleDragging = true

		local startMouseX = input.Position.X
		local startMouseY = input.Position.Y
		local startFrameX = ToggleFrame.Frame.Position.X.Offset
		local hasDragged = false
		local isScrolling = false

		Tween(ToggleFrame.Frame.Bar.UIScale, 0.12, { Scale = 1.08 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

		if dragConnection then
			dragConnection:Disconnect()
		end

		dragConnection = UserInputService.InputChanged:Connect(function(inputChanged)
			if not Config.Window.IsToggleDragging then
				return
			end
			if inputChanged.UserInputType ~= Enum.UserInputType.MouseMovement and inputChanged.UserInputType ~= Enum.UserInputType.Touch then
				return
			end

			local deltaX = math.abs(inputChanged.Position.X - startMouseX)
			local deltaY = math.abs(inputChanged.Position.Y - startMouseY)

			if not hasDragged and deltaY > 10 and deltaY > deltaX then
				isScrolling = true
				return
			end
			if isScrolling then
				return
			end

			if deltaX > 5 then
				hasDragged = true
			end

			local mouseDelta = inputChanged.Position.X - startMouseX
			local newX = math.clamp(startFrameX + mouseDelta, Inset, Inset + Travel)
			local percent = Travel > 0 and math.clamp((newX - Inset) / Travel, 0, 1) or 0

			ToggleFrame.Frame.Position = UDim2.new(0, newX, 0.5, 0)
			ToggleFrame.Layer.ImageTransparency = 1 - percent
			ToggleFrame.Stroke.ImageTransparency = 0.38 + (0.44 * percent)
		end)

		if endConnection then
			endConnection:Disconnect()
		end

		endConnection = UserInputService.InputEnded:Connect(function(inputEnded)
			if not Config.Window.IsToggleDragging then
				return
			end
			if inputEnded.UserInputType ~= Enum.UserInputType.MouseButton1 and inputEnded.UserInputType ~= Enum.UserInputType.Touch then
				return
			end

			Config.Window.IsToggleDragging = false
			Config.WindUI.CurrentInput = nil

			if dragConnection then
				dragConnection:Disconnect()
				dragConnection = nil
			end
			if endConnection then
				endConnection:Disconnect()
				endConnection = nil
			end

			Tween(ToggleFrame.Frame.Bar.UIScale, 0.14, { Scale = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

			if isScrolling then
				applyVisual(ToggleObj.Value, true)
				return
			end

			if not hasDragged then
				ToggleObj:Set(not ToggleObj.Value, true, false)
			else
				local currentX = ToggleFrame.Frame.Position.X.Offset
				local newValue = currentX > (Inset + Travel / 2)
				ToggleObj:Set(newValue, true, false)
			end
		end)
	end

	return ToggleContainer, Toggle
end

return Toggle
