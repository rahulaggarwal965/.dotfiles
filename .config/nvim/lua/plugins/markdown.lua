return {
    { "preservim/vim-markdown", ft = "markdown" },
    {
        "toppair/peek.nvim",
        ft = "markdown",
        build = "deno task --quiet build:fast",
        opts = function()
            vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
            vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
            return {
                app = "browser"
            }
        end,
        keys = {
            {
                "\\ll",
                function()
                    local peek = require("peek")
                    if peek.is_open() then
                        peek.close()
                    else
                        peek.open()
                    end
                end,
                desc = "Preview Markdown File"
            }
        }
    },
}
