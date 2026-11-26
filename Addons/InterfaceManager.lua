local httpService = game:GetService("HttpService")

local function IsValidKeyName(key)
	if key == "MouseLeft" or key == "MouseRight" then return true end
	if type(key) ~= "string" then return false end
	local ok, value = pcall(function() return Enum.KeyCode[key] end)
	return ok and value ~= nil
end

local function CreateInterfaceManager()
	local InterfaceManager = {}
	do
	InterfaceManager.Folder = "DimensiUISettings"
    InterfaceManager.Settings = {
        Theme = "Dimensi",
        Transparency = false,
        MenuKeybind = "RightControl"
    }

    function InterfaceManager:SetFolder(folder)
		if type(folder) ~= "string" or folder == "" or #folder > 128 or folder:find("%c") or folder:find("\\", 1, true) then
			return false, "invalid folder path"
		end
		for segment in folder:gmatch("[^/]+") do
			if segment == ".." or segment == "." then return false, "invalid folder path" end
		end
		folder = folder:gsub("/+$", "")
		if folder == "" then return false, "invalid folder path" end
		self.Folder = folder
		local ok, err = pcall(self.BuildFolderTree, self)
		if not ok then return false, tostring(err) end
		return true
	end

    function InterfaceManager:SetLibrary(library)
		if type(library) ~= "table" or type(library.SetTheme) ~= "function" or type(library.ToggleTransparency) ~= "function" then
			return false, "invalid DimensiUI library instance"
		end
		self.Library = library
		local ok, err = pcall(self.BuildFolderTree, self)
		if not ok then return false, tostring(err) end
		return true
	end

    function InterfaceManager:BuildFolderTree()
		local paths = {}
		local parts = self.Folder:split("/")
		for idx = 1, #parts do paths[#paths + 1] = table.concat(parts, "/", 1, idx) end
		paths[#paths + 1] = self.Folder .. "/settings"
		for _, path in ipairs(paths) do
			if not isfolder(path) then makefolder(path) end
		end
		return true
    end


    function InterfaceManager:SaveSettings()
		local ok, encoded = pcall(httpService.JSONEncode, httpService, self.Settings)
		if not ok or type(encoded) ~= "string" then return false, "encode error" end
		if #encoded > 65536 then return false, "settings exceed 64 KiB" end
		local writeOk, err = pcall(writefile, self.Folder .. "/options.json", encoded)
		if not writeOk then return false, tostring(err) end
		return true
    end


    function InterfaceManager:LoadSettings()
		local path = self.Folder .. "/options.json"
		if not isfile(path) then return true end
		local readOk, data = pcall(readfile, path)
		if not readOk or type(data) ~= "string" or #data > 65536 then return false, "read error or settings too large" end
		local decodeOk, decoded = pcall(httpService.JSONDecode, httpService, data)
		if not decodeOk or type(decoded) ~= "table" then return false, "invalid settings JSON" end
		local current = self.Settings
		current.Theme = "Dimensi"
		if type(decoded.Transparency) == "boolean" then current.Transparency = decoded.Transparency end
		if IsValidKeyName(decoded.MenuKeybind) then current.MenuKeybind = decoded.MenuKeybind end
		return true
    end


    function InterfaceManager:BuildInterfaceSection(tab)
        assert(self.Library, "Must set InterfaceManager.Library")
		local Library = self.Library
        local Settings = self.Settings
        local Manager = self

        local folderOk = pcall(self.BuildFolderTree, self)
        if not folderOk then warn("DimensiUI InterfaceManager folder setup failed") end
        local loadOk, loadResult = pcall(self.LoadSettings, self)
        if not loadOk or not loadResult then warn("DimensiUI InterfaceManager settings load failed") end

		local section = tab:AddSection("Interface")
		Settings.Theme = "Dimensi"
		if Library.Theme ~= "Dimensi" then Library:SetTheme("Dimensi") end
		section:AddToggle("TransparentToggle", {
			Title = "Transparency",
			Description = "Slightly lowers the window background opacity.",
			Default = Settings.Transparency,
			Callback = function(Value)
				Library:ToggleTransparency(Value)
				Settings.Transparency = Value
                Manager:SaveSettings()
			end
		})
	
		local MenuKeybind = section:AddKeybind("MenuKeybind", { Title = "Hide Bind", Default = Settings.MenuKeybind })
		MenuKeybind:OnChanged(function()
			Settings.MenuKeybind = MenuKeybind.Value
            Manager:SaveSettings()
		end)
		Library.MinimizeKeybind = MenuKeybind
    end
	end
	return InterfaceManager
end

local InterfaceManager = CreateInterfaceManager()
InterfaceManager.New = CreateInterfaceManager
InterfaceManager.NewInstance = CreateInterfaceManager

return InterfaceManager