-- Use custom jdtls setup
vim.lsp.config("jdtls", {
	autostart = false,
})

-- Diagnostics duplicated between vtsls (TypeScript) and ESLint.
local vtsls_ignored_codes = {
	[6133] = true, -- 'x' is declared but its value is never read
	[6192] = true, -- All imports in import declaration are unused
	[6196] = true, -- 'x' is declared but never used (types)
	[6198] = true, -- All destructured elements are unused
}

-- Diagnostics ignored only in plain JavaScript files
local vtsls_ignored_js_codes = {
	[80001] = true, -- File is a CommonJS module; it may be converted to an ES module
	[7044] = true, -- Parameter implicitly has an 'any' type, but a better type may be inferred
}

local default_publish_diagnostics = vim.lsp.handlers["textDocument/publishDiagnostics"]

vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
	if result and result.diagnostics then
		local client = vim.lsp.get_client_by_id(ctx.client_id)

		if client and client.name == "vtsls" then
			local bufnr = vim.uri_to_bufnr(result.uri)
			local filetype = vim.bo[bufnr].filetype
			local is_js = filetype == "javascript" or filetype == "javascriptreact"

			result.diagnostics = vim.tbl_filter(function(diagnostic)
				if vtsls_ignored_codes[diagnostic.code] then
					return false
				end
				if is_js and vtsls_ignored_js_codes[diagnostic.code] then
					return false
				end
				return true
			end, result.diagnostics)
		end
	end

	default_publish_diagnostics(err, result, ctx, config)
end

vim.lsp.config("vtsls", {
	settings = {
		javascript = {
			validate = true,
			preferences = {
				includePackageJsonAutoImports = "on",
				importModuleSpecifierPreference = "relative",
			},
		},
		typescript = {
			validate = true,
			preferences = {
				includePackageJsonAutoImports = "on",
				importModuleSpecifierPreference = "relative",
			},
		},
	},
})

-- Tailwind v4 directives (@theme, @apply, ...) are unknown to the CSS server
vim.lsp.config("cssls", {
	settings = {
		css = { lint = { unknownAtRules = "ignore" } },
	},
})

-- Fix for header path on NixOS
vim.lsp.config("clangd", {
	cmd = {
		"clangd",
		"--background-index",
		"--query-driver=/run/current-system/sw/bin/gcc,/run/current-system/sw/bin/clang,/nix/store/*/bin/*gcc*,/nix/store/*/bin/*clang*",
	},
})

-- Custom diagnostics
vim.diagnostic.config({
	virtual_text = {
		format = function(d)
			-- show only the first line of multi-line messages (e.g. ESLint)
			return d.message:match("^[^\n]*")
		end,
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅙 ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.INFO] = "󰋼 ",
			[vim.diagnostic.severity.HINT] = "󰌵 ",
		},
	},
})
