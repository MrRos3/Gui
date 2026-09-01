local Toggle = {}

local Creator = require("../../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local UserInputService = game:GetService("UserInputService")

local function addCorner(object, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = object
	return corner
end

local function addStroke(object, color, transparency, thickness)
	local stroke = Instance.new("UIStroke")
	stroke.Color = color
	stroke.Transparency = transparency or 0
	stroke.Thickness = thickness or 1
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = object
	return stroke
end

function Toggle.New(Value, Icon, IconSize, Parent, Callback, NewElement, Config)
	local Toggle = {}

	-- True capsule geometry copied from the reference control.
	-- Plain Frame + UICorner is intentional: do not use the Gui squircle renderer here.
	local TrackWidth = 52
	local TrackHeight = 30
	local ThumbSize = 26
	local Inset = 2
	local Travel = TrackWidth - ThumbSize - (Inset * 2)
	local GroupWidth = 86

	local OffColor = Color3.fromRGB(40, 40, 40)
	local OnColor = Color3.fromRGB(220, 20, 60)
	local ThumbColor = Color3.fromRGB(255, 255, 255)
	local OffTextColor = Color3.fromRGB(176, 176, 182)

	local ToggleContainer = New("Frame", {
		Name = "ToggleContainer",
		Size = UDim2.fromOffset(GroupWidth, TrackHeight),
		BackgroundTransparency = 1,
		Parent = Parent,
	})

	local StateLabel = New("TextLabel", {
		Name = "StateLabel",
		Size = UDim2.fromOffset(28, TrackHeight),
		Position = UDim2.fromOffset(0, 0),
		BackgroundTransparency = 1,
		Text = "OFF",
		Font = Enum.Font.GothamBold,
		TextSize = 10,
		TextColor3 = OffTextColor,
		TextXAlignment = Enum.TextXAlignment.Right,
		TextYAlignment = Enum.TextYAlignment.Center,
		ZIndex = 14,
		Parent = ToggleContainer,
	})

	local ToggleFrame = New("Frame", {
		Name = "ToggleFrame",
		Size = UDim2.fromOffset(TrackWidth, TrackHeight),
		Position = UDim2.new(1, 0, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = OffColor,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		ClipsDescendants = false,
		ZIndex = 3,
		Parent = ToggleContainer,
	})
	addCorner(ToggleFrame, TrackHeight / 2)
	addStroke(ToggleFrame, Color3.fromRGB(255, 255, 255), 0.93, 1)

	local Thumb = New("Frame", {
		Name = "Thumb",
		Size = UDim2.fromOffset(ThumbSize, ThumbSize),
		Position = UDim2.new(0, Inset, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = ThumbColor,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		ZIndex = 5,
		Parent = ToggleFrame,
	})
	addCorner(Thumb, ThumbSize / 2)
	addStroke(Thumb, OnColor, 0.42, 1)

	local ThumbScale = New("UIScale", {
		Name = "UIScale",
		Scale = 1,
		Parent = Thumb,
	})

	if Icon and Icon ~= "" then
		local iconData = Creator.Icon(Icon)
		if iconData then
			New("ImageLabel", {
				Name = "Icon",
				Size = UDim2.fromOffset(math.min(12, IconSize or 12), math.min(12, IconSize or 12)),
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Image = iconData[1],
				ImageRectOffset = iconData[2].ImageRectPosition,
				ImageRectSize = iconData[2].ImageRectSize,
				ImageTransparency = 0.35,
				ImageColor3 = Color3.fromRGB(72, 72, 76),
				ZIndex = 6,
				Parent = Thumb,
			})
		end
	end

	local Hitbox = New("TextButton", {
		Name = "Hitbox",
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Text = "",
		ZIndex = 10,
		Parent = ToggleFrame,
	})

	local dragConnection
	local endConnection

	local function getThumbX(toggled)
		return Inset + (toggled and Travel or 0)
	end

	local function updateStateLabel(toggled)
		StateLabel.Text = toggled and "ON" or "OFF"
		StateLabel.TextColor3 = toggled and OnColor or OffTextColor
	end

	local function applyVisual(toggled, animate)
		local thumbPosition = UDim2.new(0, getThumbX(toggled), 0.5, 0)
		local trackColor = toggled and OnColor or OffColor
		updateStateLabel(toggled)

		if animate then
			Tween(Thumb, 0.24, { Position = thumbPosition }, Enum.EasingStyle.Back, Enum.EasingDirection.Out):Play()
			Tween(ToggleFrame, 0.18, { BackgroundColor3 = trackColor }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out):Play()
		else
			Thumb.Position = thumbPosition
			ToggleFrame.BackgroundColor3 = trackColor
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
		local startFrameX = Thumb.Position.X.Offset
		local hasDragged = false
		local isScrolling = false

		Tween(ThumbScale, 0.10, { Scale = 1.04 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

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

			Thumb.Position = UDim2.new(0, newX, 0.5, 0)
			ToggleFrame.BackgroundColor3 = OffColor:Lerp(OnColor, percent)

			if percent >= 0.5 then
				StateLabel.Text = "ON"
				StateLabel.TextColor3 = OnColor
			else
				StateLabel.Text = "OFF"
				StateLabel.TextColor3 = OffTextColor
			end
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

			Tween(ThumbScale, 0.14, { Scale = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

			if isScrolling then
				applyVisual(ToggleObj.Value, true)
				return
			end

			if not hasDragged then
				ToggleObj:Set(not ToggleObj.Value, true, false)
			else
				local currentX = Thumb.Position.X.Offset
				local newValue = currentX > (Inset + Travel / 2)
				ToggleObj:Set(newValue, true, false)
			end
		end)
	end

	return ToggleContainer, Toggle
end

return Toggle
