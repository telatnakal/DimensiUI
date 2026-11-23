local httpService = game:GetService("HttpService")

local InterfaceManager = {} do
	InterfaceManager.Folder = "DimensiUISettings"
    InterfaceManager.Settings = {
        Theme = "Dimensi",
        Acrylic = true,
        Transparency = true,
        MenuKeybind = "LeftControl"
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
		self.Library = library
		pcall(self.BuildFolderTree, self)
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
		if type(decoded.Acrylic) == "boolean" then current.Acrylic = decoded.Acrylic end
		if type(decoded.Transparency) == "boolean" then current.Transparency = decoded.Transparency end
		if type(decoded.MenuKeybind) == "string" and Enum.KeyCode[decoded.MenuKeybind] then current.MenuKeybind = decoded.MenuKeybind end
		return true
    end


    function InterfaceManager:BuildInterfaceSection(tab)
        assert(self.Library, "Must set InterfaceManager.Library")
		local Library = self.Library
        local Settings = InterfaceManager.Settings

        local folderOk = pcall(InterfaceManager.BuildFolderTree, InterfaceManager)
        if not folderOk then warn("DimensiUI InterfaceManager folder setup failed") end
        local loadOk, loadResult = pcall(InterfaceManager.LoadSettings, InterfaceManager)
        if not loadOk or not loadResult then warn("DimensiUI InterfaceManager settings load failed") end

		local section = tab:AddSection("Interface")
		Settings.Theme = "Dimensi"
		if Library.Theme ~= "Dimensi" then Library:SetTheme("Dimensi") end
		if Library.UseAcrylic then
			section:AddToggle("AcrylicToggle", {
				Title = "Acrylic",
				Description = "The blurred background requires graphic quality 8+",
				Default = Settings.Acrylic,
				Callback = function(Value)
					if not Library:ToggleAcrylic(Value) then return end
                    Settings.Acrylic = Value
                    InterfaceManager:SaveSettings()
				end
			})
		end
	
		section:AddToggle("TransparentToggle", {
			Title = "Transparency",
			Description = "Makes the interface transparent.",
			Default = Settings.Transparency,
			Callback = function(Value)
				Library:ToggleTransparency(Value)
				Settings.Transparency = Value
                InterfaceManager:SaveSettings()
			end
		})
	
		local MenuKeybind = section:AddKeybind("MenuKeybind", { Title = "Minimize Bind", Default = Settings.MenuKeybind })
		MenuKeybind:OnChanged(function()
			Settings.MenuKeybind = MenuKeybind.Value
            InterfaceManager:SaveSettings()
		end)
		Library.MinimizeKeybind = MenuKeybind
    end
end

return InterfaceManager