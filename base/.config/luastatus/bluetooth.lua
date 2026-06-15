widget = {
	plugin = 'timer',
	opts = {period = 5, make_self_pipe = true},
	cb = function()
		local f = io.popen('bluetoothctl show 2>/dev/null', 'r')
		local out = f:read('*all'); f:close()
		local powered = out:match('Powered: yes')
		if not powered then
			return {full_text = 'BT OFF', color = '#908caa'}
		end
		local f2 = io.popen("bluetoothctl devices Connected 2>/dev/null | head -1", 'r')
		local dev = f2:read('*line'); f2:close()
		if dev and dev ~= '' then
			return {full_text = 'BT+', color = '#9ccfd8'}
		end
		return {full_text = 'BT', color = '#9ccfd8'}
	end,
	event = function(t)
		if t.button == 1 then
			os.execute('foot -e bluetui &')
		end
	end,
}