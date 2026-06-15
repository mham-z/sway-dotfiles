local pid_file = '/tmp/luastatus-caffeine-pid'

widget = {
	plugin = 'timer',
	opts = {period = 1, make_self_pipe = true},
	cb = function()
		local f = io.open(pid_file, 'r')
		if f then f:close()
			return {full_text = '󰅶', color = '#f6c177'}
		end
		return {full_text = '󰾪', color = '#ebbcba'}
	end,
	event = function(t)
		if t.button == 1 then
			local f = io.open(pid_file, 'r')
			if f then
				local pid = f:read('*line'); f:close()
				os.execute('kill ' .. pid .. ' 2>/dev/null; rm -f ' .. pid_file)
			else
				io.popen("systemd-inhibit --what=idle --who=caffeine --why=user sleep infinity & echo $! > " .. pid_file)
			end
			luastatus.plugin.wake_up()
		end
	end,
}