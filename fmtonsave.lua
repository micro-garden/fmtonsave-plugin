VERSION = "0.0.2"

local default_formatters = {
	lua = { "stylua" },
	go = { "gofmt", "-w" },
	c = { "clang-format", "-i" },
	python = { "black" },
}

local unpack = table.unpack or unpack

local micro = import("micro")
local config = import("micro/config")
local shell = import("micro/shell")

local function parse_formatter(line)
	local formatter = {}
	for word in line:gmatch("[^%s]+") do
		table.insert(formatter, word)
	end
	return formatter
end

local function parse_formatters(raw)
	local formatters = {}
	for line in raw:gmatch("[^\n]+") do
		local key, value = line:match("^(.-)=(.+)$")
		if key and value then
			formatters[key] = parse_formatter(value)
		end
	end
	return formatters
end

local function get_formatters()
	local raw = config.GetGlobalOption("fmtonsave.formatters")
	if raw == nil or raw == "" then
		return nil
	end
	return parse_formatters(raw)
end

local running = false

function onSave(bp)
	local formatters = get_formatters() or default_formatters
	local cmd = formatters[bp.Buf:FileType()]
	if not cmd then
		return
	end

	if running then
		return
	end
	running = true

	local ok = bp:Save()
	if not ok then
		micro.InfoBar():Error("Save failed")
		running = false
		return
	end

	local fullcmd = { unpack(cmd) }
	table.insert(fullcmd, bp.Buf.Path)
	local result, err = shell.ExecCommand(unpack(fullcmd))

	if err and tostring(err) ~= "" then
		micro.InfoBar():Error(cmd[1] .. " failed: " .. tostring(err))
	elseif result and tostring(result) ~= "" then
		-- micro.InfoBar():Message(cmd[1] .. " output: " .. tostring(result)
	end

	bp.Buf:ReOpen()

	running = false
end

function SetFmtOnSaveCmd(bp, args)
	if #args == 0 then
		micro.InfoBar():Message("Usage: setfmtonsave <cmd|false> [arg1] ...")
		return
	end

	local lang = bp.Buf:FileType()
	if lang == "unknown" then
		micro.InfoBar():Error("Unknown filetype")
		return
	end

	local raw = config.GetGlobalOption("fmtonsave.formatters") or ""
	local formatters = parse_formatters(raw)

	local args_table = {}
	for i = 1, #args do
		table.insert(args_table, args[i])
	end

	if #args == 1 and args[1] == "false" then
		if formatters[lang] ~= nil then
			formatters[lang] = nil
			micro.InfoBar():Message("fmtonsave: removed formatter for " .. lang)
		else
			micro.InfoBar():Message("fmtonsave: no formatter to remove for " .. lang)
		end
	else
		formatters[lang] = args_table
		micro.InfoBar():Message("fmtonsave: set " .. lang .. "=" .. table.concat(args_table, " "))
	end

	local new_parts = {}
	for k, v in pairs(formatters) do
		table.insert(new_parts, k .. "=" .. table.concat(v, " "))
	end
	local new_raw = table.concat(new_parts, "\n")
	config.SetGlobalOption("fmtonsave.formatters", new_raw)
end

function preinit()
	config.RegisterCommonOption("fmtonsave", "formatters", "")
end

function init()
	config.MakeCommand("setfmtonsave", SetFmtOnSaveCmd, config.NoComplete)
	config.AddRuntimeFile("fmtonsave", config.RTHelp, "help/fmtonsave.md")
end
