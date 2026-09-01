local Toggle = {}

local Creator = require("../../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local UserInputService = game:GetService("UserInputService")

function Toggle.New(Value, Icon, IconSize, Parent, Callback, NewElement, Config)
	local Toggle = {}

	-- Reference-script proportions and colors.
	local ToggleWidth = 52
	local ToggleHeight = 30
	local ThumbSize = 26
	local Inset = 2
	local Travel = ToggleWidth - ThumbSize - (Inset * 2)
	local GroupWidth = 96 -- 38px state + 6px gap + 52px switch

	local ToggleOff = Color3.fromRGB(40, 40, 40)
	local ToggleOn = Color3.fromRGB(220, 20, 60)
	local StateOff = Color3.fromRGB(150, 150, 156)

	local IconToggleFrame
	if Icon and Icon ~= "" then
		local iconData = Creator.Icon(Icon)
		if iconData then
			IconToggleFrame = New("ImageLabel", {
				Size = UDim2.fromOffset(math.min(12, IconSize or 12), math.min(12, IconSize or 12)),
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
		Size = UDim2.fromOffset(GroupWidth, ToggleHeight),
		BackgroundTransparency = 1,
		Parent = Parent,
	})

	local StateLabel = New("TextLabel", {
		Size = UDim2.fromOffset(38, 20),
		Position = UDim2.new(0, 0, 0.5, -10),
		BackgroundTransparency = 1,
		Text = "OFF",
		Font = Enum.Font.GothamBold,
		TextSize = 10,
		TextColor3 = StateOff,
		TextXAlignment = Enum.TextXAlignment.Right,
		ZIndex = 14,
		Parent = ToggleContainer,
	})

	local ToggleFrame = Creator.NewRoundFrame(ToggleHeight / 2, "Squircle", {
		ImageColor3 = ToggleOff,
		ImageTransparency = 0,
		Parent = ToggleContainer,
		Size = UDim2.fromOffset(ToggleWidth, ToggleHeight),
		Position = UDim2.new(1, -ToggleWidth, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		Name = "ToggleFrame",
	}, {
		Creator.NewRoundFrame(ToggleHeight / 2, "Squircle", {
			Size = UDim2.fromScale(1, 1),
			Name = "Layer",
			ImageColor3 = ToggleOn,
			ImageTransparency = 1,
			ZIndex = 1,
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
				ImageColor3 = Color3.new(1, 1, 1),
				ImageTransparency = 0,
				Name = "Bar",
				ZIndex = 5,
			}, {
				New("UIScale", {
					Scale = 1,
				}),
				Creator.NewRoundFrame(9999, "SquircleOutline", {
					Size = UDim2.fromScale(1, 1),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					ImageColor3 = ToggleOn,
					ImageTransparency = 0.55,
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

	local function updateStateLabel(toggled)
		StateLabel.Text = toggled and "ON" or "OFF"
		StateLabel.TextColor3 = toggled and ToggleOn or StateOff
	end

	local function applyVisual(toggled, animate)
		local thumbPosition = UDim2.new(0, getThumbX(toggled), 0.5, 0)
		local layerTransparency = toggled and 0 or 1
		updateStateLabel(toggled)

		if animate then
			Tween(ToggleFrame.Layer, 0.22, { ImageTransparency = layerTransparency }, Enum.EasingStyle.Quart, Enum.EasingDirection.Out):Play()
			Tween(ToggleFrame.Frame, 0.24, { Position = thumbPosition }, Enum.EasingStyle.Back, Enum.EasingDirection.Out):Play()
		else
			ToggleFrame.Frame.Position = thumbPosition
			ToggleFrame.Layer.ImageTransparency = layerTransparency
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

		Tween(ToggleFrame.Frame.Bar.UIScale, 0.12, { Scale = 1.04 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

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

			Tween(ToggleFrame.Frame.Bar.UIScale, 0.16, { Scale = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

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
