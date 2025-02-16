return {
	"saghen/blink.cmp",
	event = "InsertEnter",
	version = "*",
	opts = {
		keymap = { preset = "enter" },
		completion = {
			menu = {
				draw = {
					columns = {
						{ "label", "label_description", gap = 1 },
						{ "kind_icon", "kind", gap = 1 },
					},
				},
			},
		},
		sources = { cmdline = {} },
	},
}
