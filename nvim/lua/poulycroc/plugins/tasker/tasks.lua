-- Data layer for tasker: reads and writes tasks/T-NNN.md frontmatter.
local M = {}

-- statuses pinned to the front, in this order; unknown ones go A-Z before "done"
local ORDER = { "todo", "in_progress", "review" }
local LAST = "done"

function M.root()
	return vim.fs.find("tasks", { upward = true, type = "directory", path = vim.fn.getcwd() })[1]
end

local function frontmatter(lines)
	local fm = { tags = {} }
	if lines[1] ~= "---" then
		return fm
	end
	local key
	for i = 2, #lines do
		if lines[i] == "---" then
			break
		end
		local k, v = lines[i]:match("^(%w[%w_]*):%s*(.-)%s*$")
		if k then
			key = k
			if k == "tags" then
				-- inline form: tags: [a, b]
				for tag in (v:match("^%[(.*)%]$") or ""):gmatch("[^,%s]+") do
					table.insert(fm.tags, tag)
				end
			else
				fm[k] = v
			end
		elseif key == "tags" then
			-- block form: "  - a"
			local tag = lines[i]:match("^%s*-%s*(.-)%s*$")
			if tag and tag ~= "" then
				table.insert(fm.tags, tag)
			end
		end
	end
	return fm
end

function M.load(dir)
	local tasks = {}
	for name, kind in vim.fs.dir(dir) do
		if kind == "file" and name:match("%.md$") then
			local path = dir .. "/" .. name
			-- ponytail: only the head is read; frontmatter longer than 40 lines gets cut
			local fm = frontmatter(vim.fn.readfile(path, "", 40))
			table.insert(tasks, {
				path = path,
				id = fm.id or name:gsub("%.md$", ""),
				title = fm.title or "",
				tags = fm.tags,
				status = (fm.status and fm.status ~= "") and fm.status or "todo",
			})
		end
	end
	return tasks
end

function M.groups(tasks)
	local by = {}
	for _, t in ipairs(tasks) do
		by[t.status] = by[t.status] or {}
		table.insert(by[t.status], t)
	end

	local rank = {}
	for i, s in ipairs(ORDER) do
		rank[s] = i
	end
	local statuses = vim.tbl_keys(by)
	table.sort(statuses, function(a, b)
		local ra = a == LAST and math.huge or rank[a] or #ORDER + 1
		local rb = b == LAST and math.huge or rank[b] or #ORDER + 1
		if ra ~= rb then
			return ra < rb
		end
		return a < b
	end)

	local groups = {}
	for _, s in ipairs(statuses) do
		table.sort(by[s], function(a, b)
			return a.id < b.id
		end)
		table.insert(groups, { status = s, items = by[s] })
	end
	return groups
end

-- rewrite status + updated_at inside the frontmatter of a loaded buffer, then save
function M.set_status(buf, status)
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	if lines[1] ~= "---" then
		return false
	end
	for i = 2, #lines do
		if lines[i] == "---" then
			break
		end
		local key = lines[i]:match("^(%w[%w_]*):")
		if key == "status" then
			lines[i] = "status: " .. status
		elseif key == "updated_at" then
			lines[i] = "updated_at: " .. os.date("%Y-%m-%d")
		end
	end
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.api.nvim_buf_call(buf, function()
		vim.cmd("silent update")
	end)
	return true
end

function M.next_id(tasks)
	local max = 0
	for _, t in ipairs(tasks) do
		local n = tonumber(t.id:match("^T%-(%d+)$"))
		if n and n > max then
			max = n
		end
	end
	return string.format("T-%03d", max + 1)
end

function M.create(dir, id, title)
	local today = os.date("%Y-%m-%d")
	local path = dir .. "/" .. id .. ".md"
	vim.fn.writefile({
		"---",
		"id: " .. id,
		"title: " .. title,
		"status: todo",
		"assignee: null",
		"priority: null",
		"tags: []",
		"depends_on: []",
		"created_at: " .. today,
		"updated_at: " .. today,
		"---",
		"",
		"## Goal",
		"",
		"## Acceptance Criteria",
		"",
		"- [ ]",
		"",
		"## Notes",
		"",
		"## Progress",
		"",
	}, path)
	return path
end

return M
