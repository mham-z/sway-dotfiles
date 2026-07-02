widget = {
	plugin = 'timer';
	opts = {period = 2; make_self_pipe = true};
	cb = function()
		local f = io.popen('makoctl mode 2>/dev/null', 'r')
		if not f then return end
		
		local mode = f:read('*all'); f:close()
		local dnd = mode and mode:match('dnd')
		if dnd then
			return {full_text = '󰂛'; color = '#f6c177'; seperator = false; seperator_block_width = 12;}
		end
		return {full_text = '󰂚'; color = '#ebbcba'; seperator = false; seperator_block_width = 12;}
	end;
	event = function(t)
		if t.button == 1 then
			os.execute('makoctl mode -t dnd')
			luastatus.plugin.wake_up()
		end
	end;
}