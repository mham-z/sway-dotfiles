widget = luastatus.require_plugin('backlight-linux').widget{
    cb = function(brightness)
		if not brightness then return end
        local percentage = math.floor(brightness * 100)
        return {full_text = string.format("[BKL: %d%%]", percentage); color = "#ebbcba"}
    end
}