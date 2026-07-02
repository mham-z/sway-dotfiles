widget = {
	plugin = "timer";
	opts = {period = 1};
	cb = function()
		return {
			full_text = os.date('%w-%Y-%m-%d %I:%M:%S %p');
			color = '#c4a7e7';
			separator = false;
			separator_block_width = 12;
		}
	end;
	event = function(t)
		if t.button == 1 then
			os.execute('wl-copy $(date)')
		end
	end;
}