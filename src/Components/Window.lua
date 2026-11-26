-- DimensiUI window: layout, drag/resize, sidebar, minimize bubble, dialogs and tab API.
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local ContentProvider = game:GetService("ContentProvider")
local GuiService = game:GetService("GuiService")
local Camera = Workspace.CurrentCamera

local Root = script.Parent.Parent
local Typography = require(Root.Typography)
local Motion = require(Root.Packages.DimensiMotion)
local Creator = require(Root.Creator)
local Surface = require(Root.Surface)
local Assets = require(script.Parent.Assets)
local BubbleIconData = require(Root.BubbleIcon)
local Components = script.Parent

local Spring = Motion.Spring.new
local Instant = Motion.Instant.new
local New = Creator.New

return function(Config)
	local Library = require(Root)

	local function getBounds()
		Camera = Workspace.CurrentCamera or Camera
		local viewport = Camera and Camera.ViewportSize or Vector2.new(800, 600)
		local mobile = viewport.X < 600
		local minWidth = math.min(mobile and 300 or 420, math.max(260, viewport.X - 24))
		local minHeight = math.min(mobile and 280 or 340, math.max(240, viewport.Y - 24))
		return viewport, minWidth, minHeight, math.max(minWidth, viewport.X - 24), math.max(minHeight, viewport.Y - 24), mobile
	end

	local viewport, minWidth, minHeight, maxWidth, maxHeight, mobile = getBounds()
	local initialWidth = math.clamp(Config.Size.X.Offset, minWidth, maxWidth)
	local initialHeight = math.clamp(Config.Size.Y.Offset, minHeight, maxHeight)
	local initialTabWidth = mobile and math.clamp(Config.TabWidth, 92, 108) or math.clamp(Config.TabWidth, 120, 220)

	local Window = {
		Minimized = false,
		Collapsed = false,
		Hidden = false,
		Size = UDim2.fromOffset(initialWidth, initialHeight),
		TabWidth = initialTabWidth,
		ExpandedTabWidth = initialTabWidth,
		SidebarCollapsed = false,
		TabItems = {},
		ContentTop = 76,
		CurrentPos = 0,
		Position = UDim2.fromOffset(
			math.max(12, viewport.X / 2 - initialWidth / 2),
			math.max(12, viewport.Y / 2 - initialHeight / 2)
		),
	}

	local Dragging, DragInput, MousePos, StartPos = false
	local Resizing, ResizePos = false
	local DragEndConnection
	local MinimizeNotif = false

	Window.Surface = Surface()

	local ResizeStartFrame = New("Frame", {
		Size = UDim2.fromOffset(28, 28),
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -28, 1, -28),
	})

	Window.TabHolder = New("ScrollingFrame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ScrollBarImageTransparency = 1,
		ScrollBarThickness = 0,
		BorderSizePixel = 0,
		CanvasSize = UDim2.fromScale(0, 0),
		ScrollingDirection = Enum.ScrollingDirection.Y,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 4),
		}),
	})

	Window.Sidebar = New("Frame", {
		Size = UDim2.new(0, Window.TabWidth + 24, 1, 0),
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		ThemeTag = {
			BackgroundColor3 = "Sidebar",
		},
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 12),
		}),
		-- Squares off the sidebar's right-hand corners so only the window's left corners stay round.
		New("Frame", {
			Name = "Patch",
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.new(0, 14, 1, 0),
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			ThemeTag = {
				BackgroundColor3 = "Sidebar",
			},
		}),
	})

	local TabFrame = New("Frame", {
		Size = UDim2.new(0, Window.TabWidth, 1, -76),
		Position = UDim2.new(0, 12, 0, 64),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
	}, {
		Window.TabHolder,
	})

	Window.TabDisplay = New("TextLabel", {
		RichText = true,
		Text = "Tab",
		TextTransparency = 0,
		FontFace = Typography.SemiBold,
		TextSize = 20,
		TextXAlignment = "Left",
		TextYAlignment = "Center",
		TextTruncate = Enum.TextTruncate.AtEnd,
		Size = UDim2.new(1, -(Window.TabWidth + 144), 0, 28),
		Position = UDim2.fromOffset(Window.TabWidth + 48, 14),
		BackgroundTransparency = 1,
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	Window.PageDescription = New("TextLabel", {
		Text = "",
		FontFace = Typography.Regular,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Size = UDim2.new(1, -(Window.TabWidth + 144), 0, 18),
		Position = UDim2.fromOffset(Window.TabWidth + 48, 38),
		BackgroundTransparency = 1,
		ThemeTag = { TextColor3 = "SubText" },
	})

	Window.ContainerHolder = New("CanvasGroup", {
		Size = UDim2.new(1, -(Window.TabWidth + 72), 1, -(Window.ContentTop + 20)),
		Position = UDim2.fromOffset(Window.TabWidth + 48, Window.ContentTop),
		BackgroundTransparency = 1,
	})

	Window.Root = New("Frame", {
		BackgroundTransparency = 1,
		Size = Window.Size,
		Position = Window.Position,
		Parent = Config.Parent,
		Active = true,
	}, {
		Window.Surface.Frame,
		Window.Sidebar,
		Window.TabDisplay,
		Window.PageDescription,
		Window.ContainerHolder,
		TabFrame,
		ResizeStartFrame,
	})

	Window.TitleBar = require(script.Parent.TitleBar)({
		Title = Config.Title,
		SubTitle = Config.SubTitle,
		Parent = Window.Root,
		Window = Window,
	})

	-- The tab list starts below the brand block, which grows when a long title wraps.
	local function LayoutSidebar()
		local Brand = Window.TitleBar.Brand
		Brand.Visible = not Window.SidebarCollapsed
		local Top = Window.SidebarCollapsed and 64 or math.max(64, Brand.Position.Y.Offset + Brand.AbsoluteSize.Y + 18)
		TabFrame.Position = UDim2.fromOffset(12, Top)
		TabFrame.Size = UDim2.new(0, Window.TabWidth, 1, -(Top + 12))
		if Window.TitleBar and Window.TitleBar.CollapseButton then
			Window.TitleBar.CollapseButton.Position = UDim2.fromOffset(Window.TabWidth + 12, 14)
		end
		for _, TabItem in ipairs(Window.TabItems) do
			if TabItem.Label then
				TabItem.Label.Visible = not Window.SidebarCollapsed or not TabItem.HasIcon
				TabItem.Label.Text = Window.SidebarCollapsed and not TabItem.HasIcon and string.sub(TabItem.Name, 1, 1) or TabItem.Name
				TabItem.Label.Position = Window.SidebarCollapsed and UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(0, 40, 0.5, 0)
				TabItem.Label.AnchorPoint = Window.SidebarCollapsed and Vector2.new(0.5, 0.5) or Vector2.new(0, 0.5)
			end
			if TabItem.IconImage then
				TabItem.IconImage.Position = Window.SidebarCollapsed and UDim2.new(0.5, -8, 0.5, 0) or UDim2.new(0, 12, 0.5, 0)
			end
			if TabItem.Frame then
				TabItem.Frame.Size = UDim2.new(1, 0, 0, 36)
				TabItem.Frame:SetAttribute("TabTitle", TabItem.Name)
			end
		end
	end

	function Window:SetSidebarCollapsed(Collapsed)
		Collapsed = not not Collapsed
		if Window.SidebarCollapsed == Collapsed then return false end
		Window.SidebarCollapsed = Collapsed
		Window.TabWidth = Collapsed and 64 or Window.ExpandedTabWidth
		local sidebarWidth = Window.TabWidth + 24
		local contentX = Window.TabWidth + 48
		local tweenInfo = TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
		TweenService:Create(Window.Sidebar, tweenInfo, { Size = UDim2.new(0, sidebarWidth, 1, 0) }):Play()
		TweenService:Create(TabFrame, tweenInfo, { Size = UDim2.new(0, Window.TabWidth, 1, -(TabFrame.Position.Y.Offset + 12)) }):Play()
		TweenService:Create(Window.TabDisplay, tweenInfo, { Position = UDim2.fromOffset(contentX, 10), Size = UDim2.new(1, -(contentX + 24), 0, 28) }):Play()
		TweenService:Create(Window.PageDescription, tweenInfo, { Position = UDim2.fromOffset(contentX, 36), Size = UDim2.new(1, -(contentX + 24), 0, 18) }):Play()
		TweenService:Create(Window.ContainerHolder, tweenInfo, { Position = UDim2.fromOffset(contentX, Window.ContentTop), Size = UDim2.new(1, -(contentX + 24), 1, -(Window.ContentTop + 20)) }):Play()
		LayoutSidebar()
		return true
	end

	function Window:ToggleSidebar()
		return self:SetSidebarCollapsed(not self.SidebarCollapsed)
	end
	LayoutSidebar()
	Creator.AddSignal(Window.TitleBar.Brand:GetPropertyChangedSignal("AbsoluteSize"), LayoutSidebar, Window.Root)

	local SizeMotor = Creator.TrackMotor(Motion.GroupMotor.new({
		X = Window.Size.X.Offset,
		Y = Window.Size.Y.Offset,
	}), Window.Root)

	local PosMotor = Creator.TrackMotor(Motion.GroupMotor.new({
		X = Window.Position.X.Offset,
		Y = Window.Position.Y.Offset,
	}), Window.Root)

	Window.ContainerBackMotor = Creator.TrackMotor(Motion.SingleMotor.new(0), Window.Root)
	Window.ContainerPosMotor = Creator.TrackMotor(Motion.SingleMotor.new(Window.ContentTop), Window.Root)

	SizeMotor:onStep(function(values)
		Window.Root.Size = UDim2.new(0, values.X, 0, values.Y)
	end)

	PosMotor:onStep(function(values)
		Window.Root.Position = UDim2.new(0, values.X, 0, values.Y)
	end)

	Window.ContainerBackMotor:onStep(function(Value)
		Window.ContainerHolder.GroupTransparency = Value
	end)

	Window.ContainerPosMotor:onStep(function(Value)
		Window.ContainerHolder.Position = UDim2.fromOffset(Window.TabWidth + 48, Value)
	end)

	Creator.AddSignal(Window.TitleBar.Frame.InputBegan, function(Input)
		if
			Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch
		then
			Dragging = true
			MousePos = Input.Position
			StartPos = Window.Root.Position

			if DragEndConnection then
				Creator.DisconnectSignal(DragEndConnection)
			end
			DragEndConnection = Creator.AddSignal(Input.Changed, function()
				if Input.UserInputState == Enum.UserInputState.End then
					Dragging = false
					if DragEndConnection then
						Creator.DisconnectSignal(DragEndConnection)
						DragEndConnection = nil
					end
				end
			end, Window.Root)
		end
	end, Window.Root)

	Creator.AddSignal(Window.TitleBar.Frame.InputChanged, function(Input)
		if
			Input.UserInputType == Enum.UserInputType.MouseMovement
			or Input.UserInputType == Enum.UserInputType.Touch
		then
			DragInput = Input
		end
	end, Window.Root)

	Creator.AddSignal(ResizeStartFrame.InputBegan, function(Input)
		if
			Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch
		then
			Resizing = true
			ResizePos = Input.Position
		end
	end, Window.Root)

	Creator.AddSignal(UserInputService.InputChanged, function(Input)
		if Input == DragInput and Dragging then
			local Delta = Input.Position - MousePos
			local view = Camera.ViewportSize
			local x = math.clamp(StartPos.X.Offset + Delta.X, 0, math.max(0, view.X - Window.Size.X.Offset))
			local y = math.clamp(StartPos.Y.Offset + Delta.Y, 0, math.max(0, view.Y - Window.Size.Y.Offset))
			Window.Position = UDim2.fromOffset(x, y)
			PosMotor:setGoal({
				X = Instant(Window.Position.X.Offset),
				Y = Instant(Window.Position.Y.Offset),
			})

		end

		if
			(Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch)
			and Resizing
		then
			local Delta = Input.Position - ResizePos
			local StartSize = Window.Size

			local TargetSize = Vector3.new(StartSize.X.Offset, StartSize.Y.Offset, 0) + Vector3.new(1, 1, 0) * Delta
			local _, minW, minH, maxW, maxH = getBounds()
			local viewport = Camera.ViewportSize
			maxW = math.max(minW, math.min(maxW, viewport.X - Window.Position.X.Offset - 12))
			maxH = math.max(minH, math.min(maxH, viewport.Y - Window.Position.Y.Offset - 12))
			local TargetSizeClamped = Vector2.new(
				math.clamp(TargetSize.X, minW, maxW),
				math.clamp(TargetSize.Y, minH, maxH)
			)

			SizeMotor:setGoal({
				X = Motion.Instant.new(TargetSizeClamped.X),
				Y = Motion.Instant.new(TargetSizeClamped.Y),
			})
		end
	end, Window.Root)

	Creator.AddSignal(UserInputService.InputEnded, function(Input)
		if Resizing == true or Input.UserInputType == Enum.UserInputType.Touch then
			Resizing = false
			Window.Size = UDim2.fromOffset(SizeMotor:getValue().X, SizeMotor:getValue().Y)
		end
	end, Window.Root)

	-- Assigned once the minimize bubble exists, so it can re-clamp itself when the viewport changes.
	local BubbleViewportHook

	local function FitToViewport()
		if not Window.Root or not Window.Root.Parent then return end
		local view, minW, minH, maxW, maxH, isMobile = getBounds()
		local width = math.clamp(Window.Size.X.Offset, minW, maxW)
		local height = math.clamp(Window.Size.Y.Offset, minH, maxH)
		local x = math.clamp(Window.Position.X.Offset, 0, math.max(0, view.X - width))
		local y = math.clamp(Window.Position.Y.Offset, 0, math.max(0, view.Y - height))
		Window.Size = UDim2.fromOffset(width, height)
		Window.Position = UDim2.fromOffset(x, y)
		Window.ExpandedTabWidth = isMobile and math.clamp(Window.ExpandedTabWidth, 92, 108) or math.clamp(Window.ExpandedTabWidth, 120, 220)
		Window.TabWidth = Window.SidebarCollapsed and 64 or Window.ExpandedTabWidth
		SizeMotor:setGoal({ X = Instant(width), Y = Instant(height) })
		PosMotor:setGoal({ X = Instant(x), Y = Instant(y) })
		Window.Sidebar.Size = UDim2.new(0, Window.TabWidth + 24, 1, 0)
		Window.TitleBar.Brand.Size = UDim2.fromOffset(math.max(96, Window.TabWidth - 12), 0)
		LayoutSidebar()
		Window.TabDisplay.Position = UDim2.fromOffset(Window.TabWidth + 48, 10)
		Window.TabDisplay.Size = UDim2.new(1, -(Window.TabWidth + 72), 0, 28)
		Window.PageDescription.Position = UDim2.fromOffset(Window.TabWidth + 48, 36)
		Window.PageDescription.Size = UDim2.new(1, -(Window.TabWidth + 72), 0, 18)
		Window.ContainerHolder.Size = UDim2.new(1, -(Window.TabWidth + 72), 1, -(Window.ContentTop + 20))
		Window.ContainerHolder.Position = UDim2.fromOffset(Window.TabWidth + 48, Window.ContentTop)
		if BubbleViewportHook then BubbleViewportHook() end
	end

	local ViewportConnection
	local function BindCamera()
		if ViewportConnection then
			Creator.DisconnectSignal(ViewportConnection)
			ViewportConnection = nil
		end
		Camera = Workspace.CurrentCamera
		if Camera then
			ViewportConnection = Creator.AddSignal(Camera:GetPropertyChangedSignal("ViewportSize"), FitToViewport, Window.Root)
			FitToViewport()
		end
	end
	Creator.AddSignal(Workspace:GetPropertyChangedSignal("CurrentCamera"), BindCamera, Window.Root)
	BindCamera()

	Creator.AddSignal(Window.TabHolder.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
		Window.TabHolder.CanvasSize = UDim2.new(0, 0, 0, Window.TabHolder.UIListLayout.AbsoluteContentSize.Y)
	end, Window.Root)

	Creator.AddSignal(UserInputService.InputBegan, function(Input)
		if
			type(Library.MinimizeKeybind) == "table"
			and Library.MinimizeKeybind.Type == "Keybind"
			and not UserInputService:GetFocusedTextBox()
		then
			if Input.KeyCode.Name == Library.MinimizeKeybind.Value then
				Window:ToggleHidden()
			end
		elseif Input.KeyCode == Library.MinimizeKey and not UserInputService:GetFocusedTextBox() then
			Window:ToggleHidden()
		end
	end, Window.Root)

	-- Floating round "D" bubble shown while the window is minimized: docked near the left edge,
	-- at 75% of the screen height (from the top), and clickable to restore the window.
	local BUBBLE_SIZE = 44
	local BUBBLE_MARGIN = 36 -- gap between the screen's left edge and the bubble
	local BUBBLE_DOCK_Y = 0.75 -- docked vertical centre, as a fraction of the screen height (from the top)

	local function ResolveIcon(Icon)
		-- Hanya sumber yang bisa dimuat langsung oleh ImageLabel. URL biasa ditangani FetchIcon.
		if type(Icon) == "number" then
			return "rbxassetid://" .. Icon
		end
		if type(Icon) ~= "string" or Icon == "" then
			return nil
		end
		if Icon:match("^rbxassetid://") or Icon:match("^rbxasset://") or Icon:match("^rbxthumb://") or Icon:match("roblox%.com/asset") then
			return Icon
		end
		if tonumber(Icon) then
			return "rbxassetid://" .. Icon
		end
		if Icon:match("^https?://") then
			return nil
		end
		local AssetFn = getcustomasset or getsynasset
		if type(AssetFn) == "function" then
			local ok, asset = pcall(AssetFn, Icon)
			if ok and type(asset) == "string" and asset ~= "" then
				return asset
			end
		end
		return nil
	end

	-- Unduh PNG dari URL (mis. GitHub) sekali, simpan di workspace executor, lalu pakai file lokalnya.
	local PNG_SIGNATURE = "\137PNG\r\n\26\n"
	local ICON_FOLDER = "DimensiUI"

	local function HashText(Text)
		local h = 5381
		for i = 1, #Text do
			h = (h * 33 + Text:byte(i)) % 4294967296
		end
		return string.format("%08x", h)
	end

	local function FetchIcon(Url)
		-- Halaman github.com/.../blob/... diubah ke link raw supaya yang terunduh gambarnya, bukan HTML.
		local User, Repo, Rest = Url:match("^https?://github%.com/([^/]+)/([^/]+)/blob/(.+)$")
		if User then
			Url = ("https://raw.githubusercontent.com/%s/%s/%s"):format(User, Repo, (Rest:gsub("%?.*$", "")))
		end

		if type(writefile) ~= "function" or type(getcustomasset or getsynasset) ~= "function" then
			return nil, "executor tidak mendukung writefile/getcustomasset"
		end

		local Path = ("%s/icon_%s.png"):format(ICON_FOLDER, HashText(Url))
		pcall(function()
			if type(isfolder) == "function" and type(makefolder) == "function" and not isfolder(ICON_FOLDER) then
				makefolder(ICON_FOLDER)
			end
		end)

		-- Cache: pakai file yang sudah ada kalau isinya memang PNG.
		if type(isfile) == "function" and isfile(Path) then
			if type(readfile) ~= "function" then return Path end
			local okRead, Cached = pcall(readfile, Path)
			if okRead and type(Cached) == "string" and Cached:sub(1, 8) == PNG_SIGNATURE then
				return Path
			end
		end

		local Body
		local okGet, Res = pcall(function() return game:HttpGet(Url) end)
		if okGet and type(Res) == "string" then
			Body = Res
		end
		if not Body then
			local Req = (syn and syn.request) or http_request or request
			if type(Req) == "function" then
				local okReq, Resp = pcall(Req, { Url = Url, Method = "GET" })
				if okReq and type(Resp) == "table" and Resp.StatusCode == 200 and type(Resp.Body) == "string" then
					Body = Resp.Body
				end
			end
		end
		if not Body then
			return nil, "unduhan gagal (cek URL dan apakah repo publik)"
		end
		if Body:sub(1, 8) ~= PNG_SIGNATURE then
			return nil, "isi unduhan bukan file PNG (pakai link raw, bukan halaman /blob/)"
		end
		if not pcall(writefile, Path, Body) then
			return nil, "writefile gagal"
		end
		return Path
	end

	local BubbleIcon = New("ImageLabel", {
		Name = "Icon",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Image = "",
		ScaleType = Enum.ScaleType.Fit,
		Visible = false,
	}, {
		New("UICorner", { CornerRadius = UDim.new(1, 0) }),
	})

	local BubbleLetter = New("TextLabel", {
		Name = "Letter",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text = "D",
		FontFace = Typography.Bold,
		TextSize = 28,
		ThemeTag = { TextColor3 = "Accent" },
	})

	local BubbleStroke = New("UIStroke", {
		Thickness = 2,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		ThemeTag = { Color = "Accent" },
	})

	local BubbleScale = New("UIScale", { Scale = 1 })

	Window.Bubble = New("TextButton", {
		Name = "MinimizedBubble",
		Size = UDim2.fromOffset(BUBBLE_SIZE, BUBBLE_SIZE),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0, BUBBLE_MARGIN + BUBBLE_SIZE / 2, 0.5, 0),
		Visible = false,
		Active = true,
		ZIndex = 100,
		Text = "",
		AutoButtonColor = false,
		Parent = Config.Parent,
		ThemeTag = { BackgroundColor3 = "WindowBackground" },
	}, {
		New("UICorner", { CornerRadius = UDim.new(1, 0) }),
		BubbleStroke,
		BubbleScale,
		BubbleIcon,
		BubbleLetter,
	})

	local IconToken = 0
	Window.IconStatus = "huruf D"

	local function ShowLetter()
		BubbleIcon.Visible = false
		BubbleLetter.Visible = true
	end

	local function ReportIconProblem(Message)
		warn("[DimensiUI] Icon: " .. Message)
		task.defer(function()
			pcall(function()
				Library:Notify({ Title = "DimensiUI", Content = "Icon: " .. Message, Duration = 10 })
			end)
		end)
	end

	-- Logo "D" bawaan: PNG tertanam di library, ditulis sekali ke workspace executor.
	local function LoadEmbeddedIcon()
		local AssetFn = getcustomasset or getsynasset
		if type(writefile) ~= "function" or type(AssetFn) ~= "function" then
			return nil, "executor tidak mendukung writefile/getcustomasset"
		end
		local Path = ("%s/bubble_%d_%s.png"):format(ICON_FOLDER, #BubbleIconData, HashText(BubbleIconData))
		pcall(function()
			if type(isfolder) == "function" and type(makefolder) == "function" and not isfolder(ICON_FOLDER) then
				makefolder(ICON_FOLDER)
			end
		end)
		local NeedWrite = true
		if type(isfile) == "function" and type(readfile) == "function" and isfile(Path) then
			local okRead, Cached = pcall(readfile, Path)
			if okRead and Cached == BubbleIconData then
				NeedWrite = false
			end
		end
		if NeedWrite and not pcall(writefile, Path, BubbleIconData) then
			return nil, "writefile gagal"
		end
		local ok, Asset = pcall(AssetFn, Path)
		if ok and type(Asset) == "string" and Asset ~= "" then
			return Asset
		end
		return nil, "getcustomasset gagal"
	end

	local function ApplyIcon(Resolved, Label, OnFail)
		BubbleIcon.Image = Resolved
		BubbleIcon.Visible = true
		BubbleLetter.Visible = false
		Window.IconStatus = Label .. ": " .. tostring(Resolved)
		-- File lokal (rbxasset://) langsung dipercaya. Hanya asset Roblox yang dicek; kalau gagal
		-- (id salah / Decal / belum lolos moderasi) panggil OnFail.
		if not tostring(Resolved):match("^rbxasset://") then
			task.spawn(function()
				pcall(function()
					ContentProvider:PreloadAsync({ BubbleIcon }, function(_, status)
						if status ~= Enum.AssetFetchStatus.Success and BubbleIcon.Parent and BubbleIcon.Image == Resolved then
							OnFail("gambar gagal dimuat (" .. tostring(status) .. "): " .. tostring(Resolved))
						end
					end)
				end)
			end)
		end
	end

	local function UseDefaultIcon()
		local Asset, Reason = LoadEmbeddedIcon()
		if Asset then
			ApplyIcon(Asset, "bawaan", function(Message)
				ShowLetter()
				Window.IconStatus = "huruf D (" .. Message .. ")"
			end)
			return true
		end
		ShowLetter()
		Window.IconStatus = "huruf D (logo bawaan tidak bisa dipakai: " .. tostring(Reason) .. ")"
		return false, Reason
	end

	-- Icon: nil = logo bawaan, false = huruf "D", angka/"rbxassetid://ID"/path file/URL = gambar sendiri.
	function Window:SetIcon(Icon)
		IconToken = IconToken + 1
		local Token = IconToken
		ShowLetter()
		BubbleIcon.Image = ""

		if Icon == false then
			Window.IconStatus = "huruf D (Icon = false)"
			return false
		end

		if Icon == nil or Icon == "" then
			local ok, Reason = UseDefaultIcon()
			if not ok then
				warn("[DimensiUI] Logo bawaan tidak bisa dipakai, bubble memakai huruf D: " .. tostring(Reason))
			end
			return ok
		end

		local function Fail(Message)
			if Token ~= IconToken then return end
			ReportIconProblem(Message .. " (memakai logo bawaan)")
			UseDefaultIcon()
		end

		local Resolved = ResolveIcon(Icon)
		if Resolved then
			ApplyIcon(Resolved, "dimuat", Fail)
			return true
		end

		if type(Icon) == "string" and Icon:match("^https?://") then
			-- Async: window tetap langsung muncul dengan logo bawaan sampai gambar dari URL siap.
			UseDefaultIcon()
			Window.IconStatus = "mengunduh: " .. Icon
			task.spawn(function()
				local Path, Reason = FetchIcon(Icon)
				if Token ~= IconToken or not BubbleIcon.Parent then return end
				local Asset
				if Path then
					local ok, result = pcall(getcustomasset or getsynasset, Path)
					if ok and type(result) == "string" and result ~= "" then
						Asset = result
					else
						Reason = "getcustomasset gagal untuk " .. tostring(Path)
					end
				end
				if Asset then
					ApplyIcon(Asset, "dimuat dari URL", Fail)
				else
					Fail(tostring(Reason))
				end
			end)
			return true
		end

		Fail("bukan asset id, URL, atau file executor yang valid: " .. tostring(Icon))
		return false
	end

	Window:SetIcon(Config.Icon)

	-- Bubble placement. X is the pixel offset of the bubble's left edge; Y is a pixel offset from the
	-- vertical centre of the GUI area. The bubble is anchored at its own centre, so Y = 0 is centred
	-- and the pop / hover scale grows symmetrically around the logo.
	local BubbleDocked = true
	local BubbleX, BubbleY = BUBBLE_MARGIN, 0
	local BubbleShown = false
	local BubbleToken = 0
	local BubbleHovering = false
	local BubbleMoveTween
	local BubbleDragging, BubbleMoved, BubbleStart = false, false, nil
	local BubbleOriginX, BubbleOriginY = 0, 0

	local BubbleShowInfo = TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	local BubbleFadeInInfo = TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local BubbleHideInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
	local BubbleHoverInfo = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local BubblePressInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	local function BubblePosition(X, Y)
		return UDim2.new(0, X + BUBBLE_SIZE / 2, 0.5, Y)
	end

	-- Width and height of the GUI area plus the top inset that the ScreenGui reserves (if any).
	local function GetGuiArea()
		Camera = Workspace.CurrentCamera or Camera
		local view = Camera and Camera.ViewportSize or Vector2.new(800, 600)
		local inset = 0
		local Gui = Window.Bubble:FindFirstAncestorOfClass("ScreenGui")
		if Gui and not Gui.IgnoreGuiInset then
			local ok, value = pcall(function()
				return GuiService:GetGuiInset()
			end)
			if ok and typeof(value) == "Vector2" then
				inset = value.Y
			end
		end
		return view.X, math.max(BUBBLE_SIZE, view.Y - inset), inset
	end

	-- Docked: left edge (BUBBLE_MARGIN gap), vertical centre at BUBBLE_DOCK_Y of the full screen height (the GUI area is
	-- the screen minus the top inset, so the inset is folded in). Dragged: keep the chosen spot, on screen.
	local function ResolveBubbleCoords()
		local width, height, inset = GetGuiArea()
		if BubbleDocked then
			BubbleX, BubbleY = BUBBLE_MARGIN, BUBBLE_DOCK_Y * (height + inset) - inset - height / 2
		end
		local limitY = math.max(0, (height - BUBBLE_SIZE) / 2)
		BubbleX = math.clamp(BubbleX, 0, math.max(0, width - BUBBLE_SIZE))
		BubbleY = math.clamp(BubbleY, -limitY, limitY)
	end

	local function PlayBubbleTween(Object, Info, Goal)
		local Tween = TweenService:Create(Object, Info, Goal)
		Tween:Play()
		return Tween
	end

	local function SetBubbleFade(Alpha)
		Window.Bubble.BackgroundTransparency = Alpha
		BubbleStroke.Transparency = Alpha
		BubbleIcon.ImageTransparency = Alpha
		BubbleLetter.TextTransparency = Alpha
	end

	local function TweenBubbleFade(Info, Alpha)
		PlayBubbleTween(Window.Bubble, Info, { BackgroundTransparency = Alpha })
		PlayBubbleTween(BubbleStroke, Info, { Transparency = Alpha })
		PlayBubbleTween(BubbleIcon, Info, { ImageTransparency = Alpha })
		PlayBubbleTween(BubbleLetter, Info, { TextTransparency = Alpha })
	end

	-- Show or hide the bubble with a short slide / scale / fade. A token discards stale hide callbacks
	-- so rapid minimize / restore / hide-key presses can never leave the bubble in the wrong state.
	local function SetBubbleShown(Show)
		local Bubble = Window.Bubble
		if not Bubble or not Bubble.Parent then return end
		if Show == BubbleShown then return end
		BubbleShown = Show
		BubbleToken += 1
		local Token = BubbleToken
		if BubbleMoveTween then
			BubbleMoveTween:Cancel()
			BubbleMoveTween = nil
		end

		if Show then
			ResolveBubbleCoords()
			Bubble.Visible = true
			Bubble.Position = BubblePosition(BubbleDocked and -BUBBLE_SIZE or (BubbleX - 18), BubbleY)
			BubbleScale.Scale = 0.5
			BubbleStroke.Thickness = 2
			SetBubbleFade(1)
			BubbleMoveTween = PlayBubbleTween(Bubble, BubbleShowInfo, { Position = BubblePosition(BubbleX, BubbleY) })
			PlayBubbleTween(BubbleScale, BubbleShowInfo, { Scale = 1 })
			TweenBubbleFade(BubbleFadeInInfo, 0)
		else
			BubbleMoveTween = PlayBubbleTween(Bubble, BubbleHideInfo, { Position = BubblePosition(BubbleX - 14, BubbleY) })
			PlayBubbleTween(BubbleScale, BubbleHideInfo, { Scale = 0.6 })
			TweenBubbleFade(BubbleHideInfo, 1)
			task.delay(BubbleHideInfo.Time + 0.03, function()
				if Token == BubbleToken and Bubble.Parent then
					Bubble.Visible = false
				end
			end)
		end
	end

	local function SetBubbleHover(Hovering)
		BubbleHovering = Hovering
		if not BubbleShown or BubbleDragging then return end
		PlayBubbleTween(BubbleScale, BubbleHoverInfo, { Scale = Hovering and 1.08 or 1 })
		PlayBubbleTween(BubbleStroke, BubbleHoverInfo, { Thickness = Hovering and 3 or 2 })
	end

	BubbleViewportHook = function()
		if not BubbleShown or not Window.Bubble.Parent then return end
		if BubbleMoveTween then
			BubbleMoveTween:Cancel()
			BubbleMoveTween = nil
		end
		ResolveBubbleCoords()
		Window.Bubble.Position = BubblePosition(BubbleX, BubbleY)
	end

	local function ApplyVisibility()
		local ShowWindow = not Window.Hidden and not Window.Collapsed
		Window.Root.Visible = ShowWindow
		SetBubbleShown(not Window.Hidden and Window.Collapsed)
		Window.Minimized = Window.Collapsed
		if not ShowWindow then
			for _, frame in ipairs(Library.OpenFrames) do
				if frame and frame.Parent then frame.Visible = false end
			end
		end
	end

	-- Title-bar minimize button: collapse into the bubble (or restore from it).
	function Window:SetCollapsed(Collapsed)
		Collapsed = not not Collapsed
		if Window.Collapsed == Collapsed then return false end
		Window.Collapsed = Collapsed
		if Collapsed then
			-- Every minimize docks the bubble back at the left edge, vertically centered.
			BubbleDocked = true
		end
		ApplyVisibility()
		return true
	end

	function Window:Minimize()
		return Window:SetCollapsed(not Window.Collapsed)
	end

	-- Hotkey: hide everything (window and bubble) or bring back what was showing.
	function Window:ToggleHidden()
		Window.Hidden = not Window.Hidden
		ApplyVisibility()
		if Window.Hidden and not MinimizeNotif then
			MinimizeNotif = true
			local Key = Library.MinimizeKeybind and Library.MinimizeKeybind.Value or Library.MinimizeKey.Name
			Library:Notify({
				Title = "Interface",
				Content = "Press " .. Key .. " to show the interface again.",
				Duration = 6,
			})
		end
	end

	-- Bubble input: hover and press feedback, click restores, drag moves.
	Creator.AddSignal(Window.Bubble.MouseEnter, function()
		SetBubbleHover(true)
	end, Window.Bubble)

	Creator.AddSignal(Window.Bubble.MouseLeave, function()
		SetBubbleHover(false)
	end, Window.Bubble)

	Creator.AddSignal(Window.Bubble.InputBegan, function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			BubbleDragging = true
			BubbleMoved = false
			BubbleStart = Input.Position
			BubbleOriginX, BubbleOriginY = BubbleX, BubbleY
			if BubbleMoveTween then
				BubbleMoveTween:Cancel()
				BubbleMoveTween = nil
			end
			PlayBubbleTween(BubbleScale, BubblePressInfo, { Scale = 0.92 })
		end
	end, Window.Bubble)

	Creator.AddSignal(UserInputService.InputChanged, function(Input)
		if not BubbleDragging then return end
		if Input.UserInputType ~= Enum.UserInputType.MouseMovement and Input.UserInputType ~= Enum.UserInputType.Touch then return end
		local Delta = Input.Position - BubbleStart
		if not BubbleMoved and Delta.Magnitude < 5 then return end
		if not BubbleMoved then
			BubbleMoved = true
			BubbleDocked = false
			PlayBubbleTween(BubbleScale, BubblePressInfo, { Scale = 1.06 })
		end
		BubbleX, BubbleY = BubbleOriginX + Delta.X, BubbleOriginY + Delta.Y
		ResolveBubbleCoords()
		Window.Bubble.Position = BubblePosition(BubbleX, BubbleY)
	end, Window.Root)

	Creator.AddSignal(UserInputService.InputEnded, function(Input)
		if not BubbleDragging then return end
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			BubbleDragging = false
			if not BubbleMoved and not Window.Hidden then
				Window:SetCollapsed(false)
			elseif BubbleShown then
				PlayBubbleTween(BubbleScale, BubbleHoverInfo, { Scale = BubbleHovering and 1.08 or 1 })
			end
		end
	end, Window.Root)

	function Window:Destroy()
		for index = #Library.OpenFrames, 1, -1 do
			local frame = Library.OpenFrames[index]
			if frame and frame.Parent then pcall(function() frame:Destroy() end) end
			table.remove(Library.OpenFrames, index)
		end
		if Window.Bubble then Window.Bubble:Destroy() end
		if Window.Root then Window.Root:Destroy() end
	end

	local DialogModule = require(Components.Dialog):Init(Window)
	function Window:Dialog(Config)
		assert(type(Config) == "table" and type(Config.Title) == "string" and type(Config.Content) == "string", "Window:Dialog requires Title and Content strings")
		Config.Buttons = Config.Buttons or {}
		assert(type(Config.Buttons) == "table", "Window:Dialog Buttons must be a table")
		for Index, Button in ipairs(Config.Buttons) do
			assert(type(Button) == "table" and type(Button.Title) == "string" and Button.Title ~= "", "Window:Dialog button #" .. Index .. " requires a title")
			assert(Button.Callback == nil or type(Button.Callback) == "function", "Window:Dialog button callback must be a function")
		end
		if require(Root).Unloaded then return nil end
		local Dialog = DialogModule:Create()
		Dialog.Title.Text = Config.Title

		local Content = New("TextLabel", {
			FontFace = Typography.Regular,
			Text = Config.Content,
			TextColor3 = Color3.fromRGB(150, 158, 172),
			TextSize = 13,
			TextWrapped = true,
			LineHeight = 1.12,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			Size = UDim2.new(1, -40, 1, 0),
			Position = UDim2.fromOffset(20, 60),
			BackgroundTransparency = 1,
			Parent = Dialog.Root,
			ClipsDescendants = false,
			ThemeTag = {
				TextColor3 = "SubText",
			},
		})

		New("UISizeConstraint", {
			MinSize = Vector2.new(220, 150),
			MaxSize = Vector2.new(620, math.huge),
			Parent = Dialog.Root,
		})

		Dialog.Root.Size = UDim2.fromOffset(Content.TextBounds.X + 40, 165)
		if Content.TextBounds.X + 40 > Window.Size.X.Offset - 120 then
			Dialog.Root.Size = UDim2.fromOffset(Window.Size.X.Offset - 120, 165)
			Content.TextWrapped = true
			Dialog.Root.Size = UDim2.fromOffset(Window.Size.X.Offset - 120, Content.TextBounds.Y + 150)
		end

		for _, Button in next, Config.Buttons do
			Dialog:Button(Button.Title, Button.Callback)
		end

		Dialog:Open()
	end

	local TabModule = require(Components.Tab):Init(Window)
	function Window:AddTab(TabConfig)
		assert(type(TabConfig) == "table", "Window:AddTab expects a table")
		assert(type(TabConfig.Title) == "string" and TabConfig.Title ~= "", "Window:AddTab requires Title")
		assert(TabConfig.Description == nil or type(TabConfig.Description) == "string", "Window:AddTab Description must be a string")
		return TabModule:New(TabConfig.Title, TabConfig.Icon, Window.TabHolder, TabConfig.Description)
	end

	function Window:SelectTab(Tab)
		local Index = type(Tab) == "table" and Tab.Index or Tab
		return TabModule:SelectTab(Index)
	end

	return Window
end