return {
	'Wansmer/langmapper.nvim',
	enabled = true,
	lazy = false,
	config = function()
		local lm = require("langmapper")
		lm.setup()
		lm.hack_get_keymap()
	end,
}
