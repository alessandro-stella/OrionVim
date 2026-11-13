return {
	"neovim/nvim-lspconfig",
	config = function()
		-- TypeScript / ESLint rules
		local vtsls_ignored_codes = { [6133] = true, [6192] = true, [6196] = true, [6198] = true }
		local vtsls_ignored_js_codes = { [80001] = true, [7044] = true }

		local default_publish_diagnostics = function(err, result, ctx, config)
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
					preferences = { includePackageJsonAutoImports = "on", importModuleSpecifierPreference = "relative" },
				},
				typescript = {
					validate = true,
					preferences = { includePackageJsonAutoImports = "on", importModuleSpecifierPreference = "relative" },
				},
			},
		})

		vim.lsp.config("cssls", { settings = { css = { lint = { unknownAtRules = "ignore" } } } })

		-- Fix for C/C++ headers on NixOs
		vim.lsp.config("clangd", {
			cmd = {
				"clangd",
				"--background-index",
				"--query-driver=/run/current-system/sw/bin/gcc,/run/current-system/sw/bin/clang,/nix/store/*/bin/*gcc*,/nix/store/*/bin/*clang*",
			},
		})

		-- Change diagnostic's graphic
		vim.diagnostic.config({
			virtual_text = {
				format = function(d)
					return d.message:match("^[^\n]*")
				end,
			},
			underline = true,
			update_in_insert = false,
			severity_sort = true,
			float = { border = "rounded", source = true },
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "󰅙 ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.INFO] = "󰋼 ",
					[vim.diagnostic.severity.HINT] = "󰌵 ",
				},
			},
		})
	end,
}
