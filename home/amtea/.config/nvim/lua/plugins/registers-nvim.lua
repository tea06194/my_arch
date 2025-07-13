return {
	"tversteeg/registers.nvim",
	cmd = "Registers",
	config = true,
	keys = {
		{ "\"",    mode = { "n", "v" }, desc = "open registers" },
		{ "<C-R>", mode = "i",          desc = "open registers" }
	},
	name = "registers",
}
