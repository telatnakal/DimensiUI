local httpService = game:GetService("HttpService")

local SaveManager = {} do
	SaveManager.Folder = "DimensiUISettings"
	SaveManager.Ignore = {}
	SaveManager.Parser = {
		Toggle = {
			Save = function(idx, object) 
				return { type = "Toggle", idx = idx, value = object.Value } 
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then 
					SaveManager.Options[idx]:SetValue(data.value)
				end
			end,
		},
		Slider = {
			Save = function(idx, object)
				return { type = "Slider", idx = idx, value = tostring(object.Value) }
			end,
			Load = function(idx, data)
				local value = tonumber(data.value)
				if value and SaveManager.Options[idx] then SaveManager.Options[idx]:SetValue(value) end
			end,
		},
		Dropdown = {
			Save = function(idx, object)
				return { type = "Dropdown", idx = idx, value = object.Value, mutli = object.Multi }
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then 
					SaveManager.Options[idx]:SetValue(data.value)
				end
			end,
		},
		Colorpicker = {
			Save = function(idx, object)
				return { type = "Colorpicker", idx = idx, value = object.Value:ToHex(), transparency = object.Transparency }
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then 
					SaveManager.Options[idx]:SetValueRGB(Color3.fromHex(data.value), data.transparency)
				end
			end,
		},
		Keybind = {
			Save = function(idx, object)
				return { type = "Keybind", idx = idx, mode = object.Mode, key = object.Value }
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then 
					SaveManager.Options[idx]:SetValue(data.key, data.mode)
				end
			end,
		},

		Input = {
			Save = function(idx, object)
				return { type = "Input", idx = idx, text = object.Value }
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] and type(data.text) == "string" then
					SaveManager.Options[idx]:SetValue(data.text)
				end
			end,
		},
	}

	function SaveManager:SetIgnoreIndexes(list)
		for _, key in next, list do
			self.Ignore[key] = true
		end
	end

	function SaveManager:SetFolder(folder)
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
		if not ok then return false, "folder creation failed: " .. tostring(err) end
		return true
	end

	function SaveManager:Save(name)
		if type(name) ~= "string" or name == "" or #name > 64 then return false, "invalid config name" end
		if name:find("[\\/:*?\"<>|%c]") or name == "." or name == ".." then return false, "invalid config name" end
		local data = { objects = {} }
		for idx, option in next, SaveManager.Options do
			if type(idx) ~= "string" or type(option) ~= "table" or not self.Parser[option.Type] or self.Ignore[idx] then continue end
			local ok, entry = pcall(self.Parser[option.Type].Save, idx, option)
			if not ok or type(entry) ~= "table" then return false, "failed to serialize option " .. tostring(idx) end
			table.insert(data.objects, entry)
		end
		local ok, encoded = pcall(httpService.JSONEncode, httpService, data)
		if not ok or type(encoded) ~= "string" then return false, "failed to encode config" end
		if #encoded > 1024 * 1024 then return false, "config exceeds 1 MiB limit" end
		local path = self.Folder .. "/settings/" .. name .. ".json"
		local wrote, err = pcall(writefile, path, encoded)
		if not wrote then return false, "write error: " .. tostring(err) end
		return true
	end

	function SaveManager:Load(name)
		if type(name) ~= "string" or name == "" or #name > 64 then return false, "invalid config name" end
		if name:find("[\\/:*?\"<>|%c]") or name == "." or name == ".." then return false, "invalid config name" end
		local path = self.Folder .. "/settings/" .. name .. ".json"
		if not isfile(path) then return false, "invalid file" end
		local readOk, contents = pcall(readfile, path)
		if not readOk or type(contents) ~= "string" then return false, "read error" end
		if #contents > 1024 * 1024 then return false, "config exceeds 1 MiB limit" end
		local decodeOk, decoded = pcall(httpService.JSONDecode, httpService, contents)
		if not decodeOk or type(decoded) ~= "table" or type(decoded.objects) ~= "table" then return false, "invalid config structure" end
		local count, maxIndex = 0, 0
		for key in pairs(decoded.objects) do
			if type(key) ~= "number" or key < 1 or key % 1 ~= 0 then return false, "invalid objects array" end
			count += 1
			maxIndex = math.max(maxIndex, key)
		end
		if count > 500 or maxIndex ~= count then return false, "invalid objects array size" end
		local applied, skipped = 0, 0
		for _, option in ipairs(decoded.objects) do
			if type(option) ~= "table" or type(option.type) ~= "string" or type(option.idx) ~= "string" then skipped += 1; continue end
			local parser = self.Parser[option.type]
			if not parser or not self.Options[option.idx] then skipped += 1; continue end
			local valid = false
			if option.type == "Toggle" then
				valid = type(option.value) == "boolean"
			elseif option.type == "Slider" then
				local value = tonumber(option.value)
				valid = value ~= nil and value == value and math.abs(value) < math.huge
			elseif option.type == "Dropdown" then
				local object = self.Options[option.idx]
				if object.Multi and type(option.value) == "table" then
					valid = true
					for value, enabled in pairs(option.value) do
						if type(value) ~= "string" or type(enabled) ~= "boolean" or (enabled and not table.find(object.Values, value)) then valid = false; break end
					end
				elseif not object.Multi and type(option.value) == "string" then
					valid = table.find(object.Values, option.value) ~= nil
				end
			elseif option.type == "Colorpicker" then
				valid = type(option.value) == "string" and option.value:match("^%x%x%x%x%x%x$") ~= nil
				and (option.transparency == nil or (type(option.transparency) == "number" and option.transparency == option.transparency and option.transparency >= 0 and option.transparency <= 1))
			elseif option.type == "Keybind" then
				valid = type(option.key) == "string" and (option.key == "MouseLeft" or option.key == "MouseRight" or Enum.KeyCode[option.key] ~= nil)
				and (option.mode == "Toggle" or option.mode == "Hold" or option.mode == "Always")
			elseif option.type == "Input" then
				local object = self.Options[option.idx]
				valid = type(option.text) == "string" and #option.text <= 4096 and (not object.Numeric or option.text == "" or tonumber(option.text) ~= nil)
			end
			if not valid then skipped += 1; continue end
			local ok = pcall(parser.Load, option.idx, option)
			if ok then applied += 1 else skipped += 1 end
		end
		if skipped > 0 then return false, string.format("loaded %d options; skipped %d invalid entries", applied, skipped) end
		return true
	end

	function SaveManager:IgnoreThemeSettings()
		self:SetIgnoreIndexes({ 
			"InterfaceTheme", "AcrylicToggle", "TransparentToggle", "MenuKeybind"
		})
	end

	function SaveManager:BuildFolderTree()
		local paths = {
			self.Folder,
			self.Folder .. "/settings"
		}

		for i = 1, #paths do
			local str = paths[i]
			if not isfolder(str) then
				makefolder(str)
			end
		end
	end

	function SaveManager:RefreshConfigList()
		local folderOk = pcall(self.BuildFolderTree, self)
		if not folderOk then return {} end
		local ok, list = pcall(listfiles, self.Folder .. "/settings")
		if not ok or type(list) ~= "table" then
			return {}
		end

		local out = {}
		for i = 1, #list do
			local file = list[i]
			if file:sub(-5) == ".json" then
				local name = file:match("([^/\\]+)%.json$")
				if name and name ~= "options" then
					table.insert(out, name)
				end
			end
		end
		
		return out
	end

	function SaveManager:SetLibrary(library)
		self.Library = library
        self.Options = library.Options
	end

	function SaveManager:LoadAutoloadConfig()
		local path = self.Folder .. "/settings/autoload.txt"
		if isfile(path) then
			local readOk, name = pcall(readfile, path)
			if not readOk or type(name) ~= "string" then return false, "autoload read error" end

			local success, err = self:Load(name)
			if not success then
				return self.Library:Notify({
					Title = "Interface",
					Content = "Config loader",
					SubContent = "Failed to load autoload config: " .. err,
					Duration = 7
				})
			end

			self.Library:Notify({
				Title = "Interface",
				Content = "Config loader",
				SubContent = string.format("Auto loaded config %q", name),
				Duration = 7
			})
		end
	end

	function SaveManager:BuildConfigSection(tab)
		assert(self.Library, "Must set SaveManager.Library")

		local section = tab:AddSection("Configuration")

		section:AddInput("SaveManager_ConfigName",    { Title = "Config name" })
		section:AddDropdown("SaveManager_ConfigList", { Title = "Config list", Values = self:RefreshConfigList(), AllowNull = true })

		section:AddButton({
            Title = "Create config",
            Callback = function()
                local name = SaveManager.Options.SaveManager_ConfigName.Value

                if name:gsub(" ", "") == "" then 
                    return self.Library:Notify({
						Title = "Interface",
						Content = "Config loader",
						SubContent = "Invalid config name (empty)",
						Duration = 7
					})
                end

                local success, err = self:Save(name)
                if not success then
                    return self.Library:Notify({
						Title = "Interface",
						Content = "Config loader",
						SubContent = "Failed to save config: " .. err,
						Duration = 7
					})
                end

				self.Library:Notify({
					Title = "Interface",
					Content = "Config loader",
					SubContent = string.format("Created config %q", name),
					Duration = 7
				})

                SaveManager.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
                SaveManager.Options.SaveManager_ConfigList:SetValue(nil)
            end
        })

        section:AddButton({Title = "Load config", Callback = function()
			local name = SaveManager.Options.SaveManager_ConfigList.Value

			local success, err = self:Load(name)
			if not success then
				return self.Library:Notify({
					Title = "Interface",
					Content = "Config loader",
					SubContent = "Failed to load config: " .. err,
					Duration = 7
				})
			end

			self.Library:Notify({
				Title = "Interface",
				Content = "Config loader",
				SubContent = string.format("Loaded config %q", name),
				Duration = 7
			})
		end})

		section:AddButton({Title = "Overwrite config", Callback = function()
			local name = SaveManager.Options.SaveManager_ConfigList.Value

			local success, err = self:Save(name)
			if not success then
				return self.Library:Notify({
					Title = "Interface",
					Content = "Config loader",
					SubContent = "Failed to overwrite config: " .. err,
					Duration = 7
				})
			end

			self.Library:Notify({
				Title = "Interface",
				Content = "Config loader",
				SubContent = string.format("Overwrote config %q", name),
				Duration = 7
			})
		end})

		section:AddButton({Title = "Refresh list", Callback = function()
			SaveManager.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
			SaveManager.Options.SaveManager_ConfigList:SetValue(nil)
		end})

		local AutoloadButton
		AutoloadButton = section:AddButton({Title = "Set as autoload", Description = "Current autoload config: none", Callback = function()
			local name = SaveManager.Options.SaveManager_ConfigList.Value
			if not name or name == "" then
				return self.Library:Notify({
					Title = "Interface",
					Content = "Config loader",
					SubContent = "No config file is selected",
					Duration = 5
				})
			end
			writefile(self.Folder .. "/settings/autoload.txt", name)
			AutoloadButton:SetDesc("Current autoload config: " .. name)
			self.Library:Notify({
				Title = "Interface",
				Content = "Config loader",
				SubContent = string.format("Set %q to auto load", name),
				Duration = 7
			})
		end})

		if isfile(self.Folder .. "/settings/autoload.txt") then
			local name = readfile(self.Folder .. "/settings/autoload.txt")
			AutoloadButton:SetDesc("Current autoload config: " .. name)
		end

		SaveManager:SetIgnoreIndexes({ "SaveManager_ConfigList", "SaveManager_ConfigName" })
	end

	SaveManager:BuildFolderTree()
end

return SaveManager