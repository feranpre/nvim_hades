return {
    {
        "nvim-telescope/telescope.nvim",

        cmd = "Telescope",

        dependencies = {
            "nvim-lua/plenary.nvim",
        },

        opts = {
            defaults = {
                sorting_strategy = "ascending",

                layout_config = {
                    prompt_position = "top",
                },

                mappings = {
                    i = {
                        ["<C-j>"] = "move_selection_next",
                        ["<C-k>"] = "move_selection_previous",
                    },
                },
            },
        },
    },
}
