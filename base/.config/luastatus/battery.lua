-- Uses the battery-linux derived plugin (reads /sys/class/power_supply via udev)
widget = luastatus.require_plugin('battery-linux').widget{
	cb = function(t)
		if not t.capacity then return {full_text = ""} end
		local perc = t.capacity
		
		local icon = ""
		if t.status == "Charging" or t.status == "Full" then
			icon = "+"
		end

		local str = string.format("│ BAT0 %s%d%%", icon, perc)

		local color = "#9ccfd8"

		if perc <= 10 then
			if t.status ~= "Charging" then
				os.execute(string.format(
					'notify-send -u critical -t 3000 -h string:x-canonical-private-synchronous:battery-alert "%d%% left" "Very low battery. Charge immediately, or the device will shut down!" && pw-play /usr/share/sounds/freedesktop/stereo/dialog-warning.oga',
					perc
				))
			end

			color = "#eb6f92"
		elseif perc <= 20 then
			color = "#f6c177"
		end

		return {full_text = str; color = color}
	end,
}