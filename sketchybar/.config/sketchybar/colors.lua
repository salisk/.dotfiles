return {
	black = 0xff282828,
	white = 0xffebdbb2,
	red = 0xffcc241d,
	green = 0xff98971a,
	blue = 0xff458588,
	yellow = 0xffd79921,
	orange = 0xffd65d0e,
	magenta = 0xffb16286,
	grey = 0xffa89984,
	sky = 0xff83a598,
	pink = 0xffd3869b,
	item = 0xff32302f,
	transparent = 0x00000000,

	bar = {
		bg = 0xf03c3836,
		border = 0xff665c54,
	},
	popup = {
		bg = 0xff282828,
		border = 0xff665c54,
	},
	bg1 = 0x607c6f64,
	bg2 = 0x60494d64,

	with_alpha = function(color, alpha)
		if alpha > 1.0 or alpha < 0.0 then
			return color
		end
		return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
	end,
}
