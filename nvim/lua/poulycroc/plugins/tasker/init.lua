-- tasker: lazygit-style board for tasks/T-NNN.md
-- left: tasks grouped by frontmatter status, right: the task file itself
local tasks = require("poulycroc.plugins.tasker.tasks")

local M = {}

local ns = vim.api.nvim_create_namespace("tasker")
local collapsed = { done = true } -- survives close/reopen
local S -- open state: { dir, list_buf, list_win, right_win, empty_buf, lines, mapped, ours, augroup }

local function valid(win)
	return win and vim.api.nvim_win_is_valid(win)
end

local function current_item()
	return S.lines[vim.api.nvim_win_get_cursor(S.list_win)[1]]
end

local function task_buf(path)
	local buf = vim.fn.bufadd(path)
	if vim.api.nvim_buf_is_loaded(buf) then
		return buf
	end
	-- file open in another nvim: skip the E325 ATTENTION prompt, and since .swp is taken
	-- we get a .swo/.swn swap -> mark read-only so two instances don't fight
	local shortmess = vim.o.shortmess
	vim.opt.shortmess:append("A")
	vim.fn.bufload(buf)
	vim.o.shortmess = shortmess
	if S then
		S.ours[buf] = true -- loaded by tasker: unloaded again on close
	end
	local swap = vim.fn.swapname(buf)
	if swap ~= "" and not swap:match("%.swp$") then
		vim.bo[buf].readonly = true
	end
	return buf
end

local function truncate(s, w)
	if vim.fn.strdisplaywidth(s) <= w then
		return s
	end
	return vim.fn.strcharpart(s, 0, math.max(w - 1, 0)) .. "…"
end

local sel_ns = vim.api.nvim_create_namespace("tasker_sel")

-- first/last line of the entry under the cursor (a task can span 2 lines)
local function entry_range(lnum)
	local item = S.lines[lnum]
	local first, last = lnum, lnum
	while S.lines[first - 1] == item do
		first = first - 1
	end
	while S.lines[last + 1] == item do
		last = last + 1
	end
	return first, last
end

local function highlight_selection()
	vim.api.nvim_buf_clear_namespace(S.list_buf, sel_ns, 0, -1)
	local first, last = entry_range(vim.api.nvim_win_get_cursor(S.list_win)[1])
	for l = first, last do
		vim.api.nvim_buf_set_extmark(S.list_buf, sel_ns, l - 1, 0, {
			line_hl_group = "CursorLine",
			virt_text = { { "▎", "TaskerAccent" } },
			virt_text_pos = "overlay",
		})
	end
end

-- j/k jump whole entries instead of lines
local function step(dir)
	local lnum = vim.api.nvim_win_get_cursor(S.list_win)[1]
	local first, last = entry_range(lnum)
	local target = dir > 0 and last + 1 or first - 1
	if not S.lines[target] then
		return
	end
	vim.api.nvim_win_set_cursor(S.list_win, { (entry_range(target)), 0 })
end

-- tag colors are borrowed from these groups, faded toward the background ("opacity")
local TAG_SRC = { "Keyword", "String", "Constant", "Type", "Function", "Operator", "Special", "DiagnosticHint" }
local TAG_OPACITY = 0.6

local function blend(fg, bg, a)
	local out = 0
	for shift = 16, 0, -8 do
		local f, b = bit.band(bit.rshift(fg, shift), 0xff), bit.band(bit.rshift(bg, shift), 0xff)
		out = out + bit.lshift(math.floor(a * f + (1 - a) * b + 0.5), shift)
	end
	return out
end

-- re-run on every open so a colorscheme change is picked up
local function setup_hl()
	local function get(name)
		return vim.api.nvim_get_hl(0, { name = name, link = false })
	end
	local normal = get("Normal")
	local bg = get("NormalFloat").bg or normal.bg or 0
	local fg = normal.fg or 0xffffff
	for i, src in ipairs(TAG_SRC) do
		vim.api.nvim_set_hl(0, "TaskerTag" .. i, { fg = blend(get(src).fg or fg, bg, TAG_OPACITY) })
	end
	vim.api.nvim_set_hl(0, "TaskerSep", { fg = blend(fg, bg, 0.15) })
	vim.api.nvim_set_hl(0, "TaskerAccent", { fg = get("DiagnosticOk").fg or fg })
end

-- each tag gets a stable color from its name
local function tag_hl(tag)
	local h = 0
	for i = 1, #tag do
		h = (h * 31 + tag:byte(i)) % 1000003
	end
	return "TaskerTag" .. (h % #TAG_SRC + 1)
end

local function render(keep_path)
	local all = tasks.load(S.dir)
	S.all = all
	local text, hls, seps = {}, {}, {}
	S.lines = {}
	local width = vim.api.nvim_win_get_width(S.list_win)
	for _, g in ipairs(tasks.groups(all)) do
		table.insert(text, string.format("%s %s (%d)", collapsed[g.status] and "▶" or "▼", g.status, #g.items))
		S.lines[#text] = { header = g.status }
		table.insert(hls, { #text, 0, -1, "Title" })
		if not collapsed[g.status] then
			for _, t in ipairs(g.items) do
				local item = { task = t }
				local prefix = "  " .. t.id .. "  "
				table.insert(text, prefix .. truncate(t.title, width - vim.fn.strdisplaywidth(prefix)))
				S.lines[#text] = item
				table.insert(hls, { #text, 2, 2 + #t.id, "Identifier" })
				-- second line: tags, only when the task has some
				if #t.tags > 0 then
					local line = "   "
					local ranges = {}
					for _, tag in ipairs(t.tags) do
						line = line .. " "
						table.insert(ranges, { #line, #line + #tag + 1, tag_hl(tag) })
						line = line .. "#" .. tag
					end
					table.insert(text, truncate(line, width))
					S.lines[#text] = item
					for _, r in ipairs(ranges) do
						table.insert(hls, { #text, r[1], r[2], r[3] })
					end
				end
				table.insert(seps, #text)
			end
		end
	end

	vim.bo[S.list_buf].modifiable = true
	vim.api.nvim_buf_set_lines(S.list_buf, 0, -1, false, text)
	vim.bo[S.list_buf].modifiable = false
	vim.api.nvim_buf_clear_namespace(S.list_buf, ns, 0, -1)
	for _, h in ipairs(hls) do
		local len = #text[h[1]]
		if h[2] < len then -- tag may be cut off by truncate()
			vim.api.nvim_buf_set_extmark(S.list_buf, ns, h[1] - 1, h[2], {
				end_col = h[3] == -1 and len or math.min(h[3], len),
				hl_group = h[4],
			})
		end
	end
	-- thin separator under each task; virtual, so the cursor never lands on it
	local sep = { { { " " .. string.rep("─", width - 2), "TaskerSep" } } }
	for _, l in ipairs(seps) do
		vim.api.nvim_buf_set_extmark(S.list_buf, ns, l - 1, 0, { virt_lines = sep })
	end

	if keep_path then
		for lnum, item in ipairs(S.lines) do
			if item.task and item.task.path == keep_path then
				vim.api.nvim_win_set_cursor(S.list_win, { lnum, 0 })
				break
			end
		end
	end
	highlight_selection()
end

-- task buffers are real files: map q/<C-h> while tasker is open, unmap on close
local function map_task_buf(buf)
	if S.mapped[buf] then
		return
	end
	S.mapped[buf] = true
	for _, lhs in ipairs({ "q", "<C-h>" }) do
		vim.keymap.set("n", lhs, function()
			vim.api.nvim_set_current_win(S.list_win)
		end, { buffer = buf, desc = "tasker: back to list" })
	end
end

local function preview()
	local item = current_item()
	if not (item and item.task) then
		return
	end
	local buf = task_buf(item.task.path)
	map_task_buf(buf)
	if vim.api.nvim_win_get_buf(S.right_win) ~= buf then
		vim.api.nvim_win_set_buf(S.right_win, buf)
		vim.api.nvim_win_set_config(S.right_win, { title = " " .. vim.fs.basename(item.task.path) .. " " })
	end
end

function M.close()
	if not S then
		return
	end
	local s = S
	S = nil
	pcall(vim.api.nvim_del_augroup_by_id, s.augroup)
	for buf in pairs(s.mapped) do
		if vim.api.nvim_buf_is_valid(buf) then
			pcall(vim.keymap.del, "n", "q", { buffer = buf })
			pcall(vim.keymap.del, "n", "<C-h>", { buffer = buf })
		end
	end
	for _, win in ipairs({ s.right_win, s.list_win }) do
		if valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end
	-- drop preview buffers (and their swap files) unless edited or shown elsewhere
	for buf in pairs(s.ours) do
		if vim.api.nvim_buf_is_valid(buf) and not vim.bo[buf].modified and #vim.fn.win_findbuf(buf) == 0 then
			vim.api.nvim_buf_delete(buf, {})
		end
	end
end

local function edit()
	local item = current_item()
	if item and item.task then
		preview()
		vim.api.nvim_set_current_win(S.right_win)
	end
end

local function toggle_or_edit()
	local item = current_item()
	if item and item.header then
		collapsed[item.header] = not collapsed[item.header]
		render()
	else
		edit()
	end
end

local function add()
	vim.ui.input({ prompt = "New task title: " }, function(title)
		if not S or not title or title == "" then
			return
		end
		local path = tasks.create(S.dir, tasks.next_id(S.all), title)
		collapsed.todo = false
		render(path)
		edit()
	end)
end

local function delete()
	local item = current_item()
	if not (item and item.task) then
		return
	end
	local t = item.task
	if vim.fn.confirm("Delete " .. t.id .. " " .. t.title .. "?", "&Yes\n&No", 2) ~= 1 then
		return
	end
	local buf = vim.fn.bufnr(t.path)
	if buf ~= -1 then
		if vim.api.nvim_win_get_buf(S.right_win) == buf then
			vim.api.nvim_win_set_buf(S.right_win, S.empty_buf)
		end
		S.mapped[buf] = nil
		vim.api.nvim_buf_delete(buf, { force = true })
	end
	os.remove(t.path)
	render()
	preview()
end

local function move()
	local item = current_item()
	if not (item and item.task) then
		return
	end
	local path = item.task.path
	local choices = {}
	for _, g in ipairs(tasks.groups(S.all)) do
		table.insert(choices, g.status)
	end
	table.insert(choices, "new…")

	local function apply(status)
		if not S or not status or status == "" then
			return
		end
		tasks.set_status(task_buf(path), status)
		collapsed[status] = false
		render(path)
		preview()
	end

	vim.ui.select(choices, { prompt = item.task.id .. " → status" }, function(choice)
		if choice == "new…" then
			vim.ui.input({ prompt = "New status: " }, apply)
		else
			apply(choice)
		end
	end)
end

function M.open()
	if S then
		vim.api.nvim_set_current_win(S.list_win)
		return
	end
	local dir = tasks.root()
	if not dir then
		vim.notify("tasker: no tasks/ folder found from " .. vim.fn.getcwd(), vim.log.levels.WARN)
		return
	end

	local W, H = vim.o.columns, vim.o.lines
	local width, height = math.floor(W * 0.9), math.floor(H * 0.9) - 2
	local row, col = math.floor((H - height) / 2) - 1, math.floor((W - width) / 2)
	local left_w = math.floor(width * 0.35)
	local right_w = width - left_w - 4 -- 2 borders per window

	S = {
		dir = dir,
		list_buf = vim.api.nvim_create_buf(false, true),
		empty_buf = vim.api.nvim_create_buf(false, true),
		mapped = {},
		ours = {},
		augroup = vim.api.nvim_create_augroup("tasker", { clear = true }),
	}
	vim.bo[S.list_buf].filetype = "tasker"
	setup_hl()

	S.right_win = vim.api.nvim_open_win(S.empty_buf, false, {
		relative = "editor",
		row = row,
		col = col + left_w + 2,
		width = right_w,
		height = height,
		border = "rounded",
		title = " task ",
	})
	S.list_win = vim.api.nvim_open_win(S.list_buf, true, {
		relative = "editor",
		row = row,
		col = col,
		width = left_w,
		height = height,
		border = "rounded",
		title = " Tasks · " .. vim.fn.fnamemodify(dir, ":~:h") .. " ",
		style = "minimal",
	})
	vim.wo[S.list_win].cursorline = false -- selection drawn by highlight_selection (spans 2 lines)
	vim.wo[S.list_win].wrap = false

	local function map(lhs, fn, desc)
		vim.keymap.set("n", lhs, fn, { buffer = S.list_buf, nowait = true, desc = "tasker: " .. desc })
	end
	map("j", function()
		step(1)
	end, "next")
	map("k", function()
		step(-1)
	end, "previous")
	map("<Down>", function()
		step(1)
	end, "next")
	map("<Up>", function()
		step(-1)
	end, "previous")
	map("<CR>", toggle_or_edit, "toggle group / edit")
	map("e", edit, "edit task")
	map("<C-l>", edit, "edit task")
	map("a", add, "add task")
	map("d", delete, "delete task")
	map("m", move, "change status")
	map("r", function()
		local item = current_item()
		render(item and item.task and item.task.path)
	end, "refresh")
	map("q", M.close, "close")
	map("<Esc>", M.close, "close")

	vim.api.nvim_create_autocmd("CursorMoved", {
		group = S.augroup,
		buffer = S.list_buf,
		callback = function()
			highlight_selection()
			preview()
		end,
	})
	vim.api.nvim_create_autocmd("WinLeave", {
		group = S.augroup,
		callback = function()
			if S and vim.api.nvim_get_current_win() == S.right_win then
				vim.cmd("silent! update")
			end
		end,
	})
	vim.api.nvim_create_autocmd("WinClosed", {
		group = S.augroup,
		pattern = { tostring(S.list_win), tostring(S.right_win) },
		callback = function()
			vim.schedule(M.close)
		end,
	})

	render()
	-- start on first task, not a header
	for lnum = 1, vim.api.nvim_buf_line_count(S.list_buf) do
		if S.lines[lnum] and S.lines[lnum].task then
			vim.api.nvim_win_set_cursor(S.list_win, { lnum, 0 })
			break
		end
	end
	highlight_selection()
	preview()
end

function M.setup()
	vim.api.nvim_create_user_command("Tasker", M.open, { desc = "Open tasker board" })
	vim.keymap.set("n", "<leader>to", M.open, { desc = "Tasker board" })
end

return M
