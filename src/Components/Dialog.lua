local Root = script.Parent.Parent
local Typography = require(Root.Typography)
local Motion = require(Root.Packages.DimensiMotion)
local Creator = require(Root.Creator)
local Library = require(Root)

local Spring = Motion.Spring.new
local Instant = Motion.Instant.new
local New = Creator.New

local Dialog = {
	Window = nil,
}

function Dialog:Init(Window)
	Dialog.Window = Window
	return Dialog
end

function Dialog:Create()
	local NewDialog = {
		Buttons = 0,
		Closed = false,
		_IsOpen = false,
	}

	function NewDialog:SetOpenState(IsOpen)
		IsOpen = not not IsOpen
		if self._IsOpen == IsOpen then
			return
		end
		self._IsOpen = IsOpen
		Library._OpenDialogCount = math.max(0, (Library._OpenDialogCount or 0) + (IsOpen and 1 or -1))
		Library.DialogOpen = Library._OpenDialogCount > 0
	end

	NewDialog.TintFrame = New("TextButton", {
		Text = "",
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 1,
		Parent = Dialog.Window.Root,
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 12),
		}),
	})

	local TintMotor, TintTransparency = Creator.SpringMotor(1, NewDialog.TintFrame, "BackgroundTransparency", true)

	NewDialog.ButtonHolder = New("Frame", {
		Size = UDim2.new(1, -40, 1, -40),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundTransparency = 1,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 10),
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
	})

	NewDialog.ButtonHolderFrame = New("Frame", {
		Size = UDim2.new(1, 0, 0, 70),
		Position = UDim2.new(0, 0, 1, -70),
		ThemeTag = {
			BackgroundColor3 = "DialogHolder",
		},
	}, {
		New("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			ThemeTag = {
				BackgroundColor3 = "DialogHolderLine",
			},
		}),
		NewDialog.ButtonHolder,
	})

	NewDialog.Title = New("TextLabel", {
		FontFace = Typography.SemiBold,
		Text = "Dialog",
		TextColor3 = Color3.fromRGB(239, 242, 250),
		TextSize = 16,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, 0, 0, 22),
		Position = UDim2.fromOffset(20, 25),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	NewDialog.Scale = New("UIScale", {
		Scale = 1,
	})

	local ScaleMotor, Scale = Creator.SpringMotor(1.1, NewDialog.Scale, "Scale")

	NewDialog.Root = New("CanvasGroup", {
		Size = UDim2.fromOffset(math.clamp(Dialog.Window.Size.X.Offset - 24, 220, 300), 165),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		GroupTransparency = 1,
		Parent = NewDialog.TintFrame,
		ThemeTag = {
			BackgroundColor3 = "Dialog",
		},
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 12),
		}),
		New("UIStroke", {
			Transparency = 0,
			ThemeTag = {
				Color = "DialogBorder",
			},
		}),
		NewDialog.Scale,
		NewDialog.Title,
		NewDialog.ButtonHolderFrame,
	})

	local RootMotor, RootTransparency = Creator.SpringMotor(1, NewDialog.Root, "GroupTransparency")

	function NewDialog:Open()
		if NewDialog.Closed or Library.Unloaded or not NewDialog.TintFrame.Parent then return false end
		NewDialog:SetOpenState(true)
		NewDialog.Scale.Scale = 1.1
		TintTransparency(0.75)
		RootTransparency(0)
		Scale(1)
	end

	function NewDialog:Close()
		if NewDialog.Closed then return end
		NewDialog.Closed = true
		NewDialog:SetOpenState(false)
		TintTransparency(1)
		RootTransparency(1)
		Scale(1.1)
		if NewDialog.Root and NewDialog.Root:FindFirstChild("UIStroke") then
			NewDialog.Root.UIStroke:Destroy()
		end
		task.wait(0.15)
		if NewDialog.TintFrame and NewDialog.TintFrame.Parent then
			NewDialog.TintFrame:Destroy()
		end
	end

	Creator.AddSignal(NewDialog.TintFrame.Destroying, function()
		NewDialog:SetOpenState(false)
		NewDialog.Closed = true
	end, NewDialog.TintFrame)

	function NewDialog:Button(Title, Callback)
		assert(Title == nil or type(Title) == "string", "Dialog:Button Title must be a string")
		assert(Callback == nil or type(Callback) == "function", "Dialog:Button Callback must be a function")
		if NewDialog.Closed then return nil end
		NewDialog.Buttons = NewDialog.Buttons + 1
		Title = Title or "Button"
		Callback = Callback or function() end

		local Button = require(Root.Components.Button)("", NewDialog.ButtonHolder, true)
		Button.Title.Text = Title

		for _, Btn in next, NewDialog.ButtonHolder:GetChildren() do
			if Btn:IsA("TextButton") then
				Btn.Size =
					UDim2.new(1 / NewDialog.Buttons, -(((NewDialog.Buttons - 1) * 10) / NewDialog.Buttons), 0, 32)
			end
		end

		Creator.AddSignal(Button.Frame.MouseButton1Click, function()
			require(Root):SafeCallback(Callback)
			pcall(function()
				NewDialog:Close()
			end)
		end, Button.Frame)

		return Button
	end

	return NewDialog
end

return Dialog
