-- Tab and indentation settings
vim.opt.tabstop = 4        -- The width of a TAB is set to 4
vim.opt.shiftwidth = 4     -- Indents will have a width of 4
vim.opt.softtabstop = 4    -- Sets the number of columns for a TAB
vim.opt.expandtab = true   -- Expand TABs to spaces

-- Search settings
vim.opt.hlsearch = true    -- Highlight search results

-- Enable syntax highlighting
vim.cmd('syntax on')

-- Disable mouse
vim.opt.mouse = ""

-- Key mapping: ö to : (useful for non-US keyboards)
vim.keymap.set('n', 'ö', ':', { noremap = true })

-- Set colorscheme
vim.cmd('colorscheme unokai')

-- Line numbers
vim.opt.number = true      -- Show line numbers

-- Function to toggle between absolute and relative line numbers
local function number_toggle()
    if vim.opt.number:get() then
        vim.opt.number = false
        vim.opt.relativenumber = true
    else
        vim.opt.relativenumber = false
        vim.opt.number = true
    end
end

-- Key mapping for number toggle
vim.keymap.set('n', '<C-n>', number_toggle, { noremap = true, silent = true })
