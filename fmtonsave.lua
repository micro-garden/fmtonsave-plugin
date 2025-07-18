VERSION = "0.0.0"

local formatters = {
	lua = { "stylua" },
	go = { "gofmt", "-w" },
	c = { "clang-format", "-i" },
	python = { "black" },
}

local unpack = table.unpack or unpack

local micro = import("micro")
local config = import("micro/config")
local shell = import("micro/shell")

local running = false

function onSave(bp)
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

function init()
	config.AddRuntimeFile("fmtonsave", config.RTHelp, "help/fmtonsave.md")
end
