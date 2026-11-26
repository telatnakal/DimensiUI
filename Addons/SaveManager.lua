local httpService = game:GetService("HttpService")

local function IsValidKeyName(key)
	if key == "MouseLeft" or key == "MouseRight" then return true end
	if type(key) ~= "string" then return false end
	local ok, value = pcall(function() return Enum.KeyCode[key] end)
	return ok and value ~= nil
end

local function CreateSaveManager()
	local SaveManager = {}
	do
	SaveManager.Folder = "DimensiUISettings"
	SaveManager.Ignore = {}
	SaveManager.Parser = {
		Toggle = {
			Save = function(idx, object) 
				return { type = "Toggle", idx = idx, value = object.Value } 
			end,
			Load = function(idx, data, manager)
				if manager.Options[idx] then 
					manager.Options[idx]:SetValue(data.value)
				end
			end,
		},
		Slider = {
			Save = function(idx, object)
				return { type = "Slider", idx = idx, value = tostring(object.Value) }
			end,
			Load = function(idx, data, manager)
				local value = tonumber(data.value)
				if value and manager.Options[idx] then manager.Options[idx]:SetValue(value) end
			end,
		},
		Dropdown = {
			Save = function(idx, object)
				return { type = "Dropdown", idx = idx, value = object.Value, mutli = object.Multi }
			end,
			Load = function(idx, data, manager)
				if manager.Options[idx] then 
					manager.Options[idx]:SetValue(data.value)
				end
			end,
		},
		Colorpicker = {
			Save = function(idx, object)
				return { type = "Colorpicker", idx = idx, value = object.Value:ToHex(), transparency = object.Transparency }
			end,
			Load = function(idx, data, manager)
				if manager.Options[idx] then 
					manager.Options[idx]:SetValueRGB(Color3.fromHex(data.value), data.transparency)
				end
			end,
		},
		Keybind = {
			Save = function(idx, object)
				return { type = "Keybind", idx = idx, mode = object.Mode, key = object.Value }
			end,
			Load = function(idx, data, manager)
				if manager.Options[idx] then 
					manager.Options[idx]:SetValue(data.key, data.mode)
				end
			end,
		},

		Input = {
			Save = function(idx, object)
				return { type = "Input", idx = idx, text = object.Value }
			end,
			Load = function(idx, data, manager)
				if manager.Options[idx] and type(data.text) == "string" then
					manager.Options[idx]:SetValue(data.text)
				end
			end,
		},
	}

	function SaveManager:SetIgnoreIndexes(list)
		if type(list) ~= "table" then return false, "ignore indexes must be a table" end
		for _, key in next, list do
			if type(key) ~= "string" or key == "" then
				return false, "ignore indexes must contain non-empty strings"
			end
		end
		for _, key in next, list do
			self.Ignore[key] = true
		end
		return true
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
		for idx, option in next, self.Options do
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
		local fileOk, exists = pcall(isfile, path)
		if not fileOk or not exists then return false, "invalid file" end
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
		local pending, seen, skipped = {}, {}, 0
		for _, option in ipairs(decoded.objects) do
			if type(option) ~= "table" or type(option.type) ~= "string" or type(option.idx) ~= "string" or seen[option.idx] then
				skipped += 1
				continue
			end
			seen[option.idx] = true
			local parser = self.Parser[option.type]
			local object = self.Options[option.idx]
			if not parser or type(object) ~= "table" then
				skipped += 1
				continue
			end
			local valid = false
			if option.type == "Toggle" then
				valid = type(option.value) == "boolean"
			elseif option.type == "Slider" then
				local value = tonumber(option.value)
				valid = value ~= nil and value == value and math.abs(value) < math.huge
			elseif option.type == "Dropdown" then
				if object.Multi and type(option.value) == "table" then
					valid = true
					for value, enabled in pairs(option.value) do
						if type(value) ~= "string" or type(enabled) ~= "boolean" or not table.find(object.Values, value) then valid = false; break end
					end
				elseif not object.Multi and option.value == nil then
					valid = true -- empty selection (AllowNull dropdown): nil is dropped by JSON
				elseif not object.Multi and type(option.value) == "string" then
					valid = table.find(object.Values, option.value) ~= nil
				end
			elseif option.type == "Colorpicker" then
				valid = type(option.value) == "string" and option.value:match("^%x%x%x%x%x%x$") ~= nil
					and (option.transparency == nil or (type(option.transparency) == "number" and option.transparency == option.transparency and option.transparency >= 0 and option.transparency <= 1))
			elseif option.type == "Keybind" then
				valid = IsValidKeyName(option.key)
					and (option.mode == "Toggle" or option.mode == "Hold" or option.mode == "Always")
			elseif option.type == "Input" then
				valid = type(option.text) == "string" and #option.text <= 4096 and (not object.Numeric or option.text == "" or tonumber(option.text) ~= nil)
			end
			if not valid then
				skipped += 1
				continue
			end
			local saveOk, previous = pcall(parser.Save, option.idx, object)
			if not saveOk or type(previous) ~= "table" then
				skipped += 1
				continue
			end
			local cloneOk, previousCopy = pcall(function()
				return httpService:JSONDecode(httpService:JSONEncode(previous))
			end)
			if not cloneOk or type(previousCopy) ~= "table" then
				skipped += 1
				continue
			end
			table.insert(pending, { Index = option.idx, Data = option, Parser = parser, Previous = previousCopy })
		end
		if skipped > 0 and #pending == 0 then
			return false, string.format("config has no valid entries; %d skipped; no options were changed", skipped)
		end
		local applied = {}
		for _, entry in ipairs(pending) do
			local ok = pcall(entry.Parser.Load, entry.Index, entry.Data, self)
			if not ok then
				pcall(entry.Parser.Load, entry.Index, entry.Previous, self)
				for index = #applied, 1, -1 do
					local previous = applied[index]
					pcall(previous.Parser.Load, previous.Index, previous.Previous, self)
				end
				return false, "config apply failed; previous option values were restored where possible"
			end
			table.insert(applied, entry)
		end
		if skipped > 0 then
			return true, string.format("%d invalid, duplicate or unknown entries were skipped", skipped)
		end
		return true
	end

	function SaveManager:IgnoreThemeSettings()
		self:SetIgnoreIndexes({ 
			"InterfaceTheme", "TransparentToggle", "MenuKeybind"
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
		if type(library) ~= "table" or type(library.Options) ~= "table" or type(library.Notify) ~= "function" then
			return false, "invalid DimensiUI library instance"
		end
		self.Library = library
        self.Options = library.Options
		return true
	end

	function SaveManager:LoadAutoloadConfig()
		local path = self.Folder .. "/settings/autoload.txt"
		local fileOk, exists = pcall(isfile, path)
		if not fileOk then return false, "autoload file check failed" end
		if exists then
			local readOk, name = pcall(readfile, path)
			if not readOk or type(name) ~= "string" then return false, "autoload read error" end

			local success, err = self:Load(name)
			if not success then
				return self.Library:Notify({
					Title = "Interface",
					Content = "Config loader",
					SubContent = "Failed to load autoload config: " .. tostring(err),
					Duration = 7
				})
			end

			self.Library:Notify({
				Title = "Interface",
				Content = "Config loader",
				SubContent = string.format("Auto loaded config %q", name) .. (err and (" (" .. err .. ")") or ""),
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
                local name = self.Options.SaveManager_ConfigName.Value

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
						SubContent = "Failed to save config: " .. tostring(err),
						Duration = 7
					})
                end

				self.Library:Notify({
					Title = "Interface",
					Content = "Config loader",
					SubContent = string.format("Created config %q", name),
					Duration = 7
				})

                self.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
                self.Options.SaveManager_ConfigList:SetValue(nil)
            end
        })

        section:AddButton({Title = "Load config", Callback = function()
			local name = self.Options.SaveManager_ConfigList.Value

			local success, err = self:Load(name)
			if not success then
				return self.Library:Notify({
					Title = "Interface",
					Content = "Config loader",
					SubContent = "Failed to load config: " .. tostring(err),
					Duration = 7
				})
			end

			self.Library:Notify({
				Title = "Interface",
				Content = "Config loader",
				SubContent = string.format("Loaded config %q", name) .. (err and (" (" .. err .. ")") or ""),
				Duration = 7
			})
		end})

		section:AddButton({Title = "Overwrite config", Callback = function()
			local name = self.Options.SaveManager_ConfigList.Value

			local success, err = self:Save(name)
			if not success then
				return self.Library:Notify({
					Title = "Interface",
					Content = "Config loader",
					SubContent = "Failed to overwrite config: " .. tostring(err),
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
			self.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
			self.Options.SaveManager_ConfigList:SetValue(nil)
		end})

		local AutoloadButton
		AutoloadButton = section:AddButton({Title = "Set as autoload", Description = "Current autoload config: none", Callback = function()
			local name = self.Options.SaveManager_ConfigList.Value
			if not name or name == "" then
				return self.Library:Notify({
					Title = "Interface",
					Content = "Config loader",
					SubContent = "No config file is selected",
					Duration = 5
				})
			end
			local writeOk, writeError = pcall(writefile, self.Folder .. "/settings/autoload.txt", name)
			if not writeOk then
				return self.Library:Notify({
					Title = "Interface",
					Content = "Config loader",
					SubContent = "Failed to save autoload setting: " .. tostring(writeError),
					Duration = 7
				})
			end
			AutoloadButton:SetDesc("Current autoload config: " .. name)
			self.Library:Notify({
				Title = "Interface",
				Content = "Config loader",
				SubContent = string.format("Set %q to auto load", name),
				Duration = 7
			})
		end})

		local autoloadPath = self.Folder .. "/settings/autoload.txt"
		local fileOk, exists = pcall(isfile, autoloadPath)
		if fileOk and exists then
			local readOk, name = pcall(readfile, autoloadPath)
			if readOk and type(name) == "string" and name ~= "" then
				AutoloadButton:SetDesc("Current autoload config: " .. name)
			end
		end

		self:SetIgnoreIndexes({ "SaveManager_ConfigList", "SaveManager_ConfigName" })
	end

	SaveManager:BuildFolderTree()
	end
	return SaveManager
end

local SaveManager = CreateSaveManager()
SaveManager.New = CreateSaveManager
SaveManager.NewInstance = CreateSaveManager

return SaveManager