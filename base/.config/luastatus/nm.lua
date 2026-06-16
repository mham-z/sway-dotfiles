widget = {
	plugin = 'timer',
	opts = {period = 5, make_self_pipe = true},
	cb = function()
		local fe = io.popen("nmcli -t -f type,state dev 2>/dev/null | grep '^ethernet:connected'", 'r')
		local enet = fe:read('*line'); fe:close()

		if enet and enet ~= '' then
			return {full_text = 'ENET', color = '#9ccfd8'}
		end

		local fw = io.popen("nmcli -t -f active,ssid,signal dev wifi 2>/dev/null | grep '^yes'", 'r')
		local line = fw:read('*line'); fw:close()

		if line and line ~= '' then
			local ssid, signal = line:match('^yes:(.+):(%d+)$')
			local rssi = tonumber(signal) or 0
			local name = ssid or '?'
			if #name > 5 then name = name:sub(1, 5) .. '…' end
			return {full_text = 'WLAN ' .. name .. ' ' .. rssi .. '%', color = '#9ccfd8'}
		end

		return {full_text = 'NET', color = '#9ccfd8'}
	end,
	event = function(t)
		if t.button == 1 then
			os.execute('foot -e nmtui &')
		end
	end,
}