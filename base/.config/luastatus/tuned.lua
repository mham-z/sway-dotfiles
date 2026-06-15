local profiles = {
	["powersave"] = "balanced-battery";
	["balanced-battery"] = "balanced";
	["balanced"] = "desktop";
	["desktop"] = "throughput-performance";
	["throughput-performance"] = "powersave";
}

local translate = {
	["powersave"] = "SAV";
	["balanced-battery"] = "ECO";
	["balanced"] = "BAL";
	["desktop"] = "WRK";
	["throughput-performance"] = "MAX";
}

widget = {
	plugin = "timer",
	opts = {interval = 2};
	cb = function()
		local profile
		local file = io.open("/etc/tuned/active_profile", "r")
		if file then
			local content = file:read("*a")
			file:close()
			profile = content:gsub("%s+", "")
		else
			profile = "balanced"
		end

		return {full_text = "" .. (translate[profile] or profile) .. ""; instance = profile; color = '#ebbcba'; seperator = false; seperator_block_width = 12}
	end;
	event = function(ctx)
		if ctx.button == 1 then
			local current_profile = ctx.instance or "balanced"
			local next_profile = profiles[current_profile] or "balanced"
			os.execute("tuned-adm -a profile " .. next_profile)
		end
	end;
}
