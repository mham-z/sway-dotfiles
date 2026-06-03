widget = {
	plugin = 'timer',
	opts = {period = 1, make_self_pipe = true},
	cb = function()
		local fm = io.popen("pactl get-sink-mute @DEFAULT_SINK@ 2>/dev/null", 'r')
		local mute = fm:read('*line'); fm:close()
		local fv = io.popen("pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null", 'r')
		local vol = fv:read('*line'); fv:close()
		local pct = vol and vol:match('(%d+)%%') or '?'
		if mute and mute:match('yes') then
			return {full_text = '[VOL: mute]', color = '#908caa'}
		end
		return {full_text = '[VOL: ' .. pct .. '%]', color = '#ebbcba'}
	end,
	event = function(t)
		if t.button == 1 then
			os.execute('pactl set-sink-mute @DEFAULT_SINK@ toggle')
		elseif t.button == 3 then
			os.execute("foot -e pulsemixer &")
		elseif t.button == 4 then
			os.execute('pactl set-sink-volume @DEFAULT_SINK@ +5%')
		elseif t.button == 5 then
			os.execute('pactl set-sink-volume @DEFAULT_SINK@ -5%')
		end
		luastatus.plugin.wake_up()
	end,
}