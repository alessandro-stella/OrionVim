local M = {}

function M:setup()
	-- Project name based on the current directory
	local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
	local workspace_dir = vim.fn.expand("~/.workspaces-java") .. "/" .. project_name

	-- Operating system
	local os_name = vim.loop.os_uname().sysname

	-- Mason path for jdtls
	local mason_jdtls = vim.fn.stdpath("data") .. "/mason/packages/jdtls"

	-- Automatically find the launcher jar
	local launcher_jar = vim.fn.glob(mason_jdtls .. "/plugins/org.eclipse.equinox.launcher_*.jar")
	if launcher_jar == "" then
		vim.notify("JDTLS launcher jar not found!", vim.log.levels.ERROR)
		return
	end

	-- JDTLS configuration
	local config = {
		cmd = {
			"java", -- use java from PATH
			"-Declipse.application=org.eclipse.jdt.ls.core.id1",
			"-Dosgi.bundles.defaultStartLevel=4",
			"-Declipse.product=org.eclipse.jdt.ls.core.product",
			"-Dlog.protocol=true",
			"-Dlog.level=ALL",
			"-Xmx1g",
			"--add-modules=ALL-SYSTEM",
			"--add-opens",
			"java.base/java.util=ALL-UNNAMED",
			"--add-opens",
			"java.base/java.lang=ALL-UNNAMED",
			"-jar",
			launcher_jar,
			"-configuration",
			mason_jdtls .. "/config_" .. (os_name == "Windows_NT" and "win" or os_name == "Linux" and "linux" or "mac"),
			"-data",
			workspace_dir,
		},

		-- Root directory of the project
		root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),

		-- Eclipse JDTLS specific settings
		settings = {
			java = {
				project = {
					sourcePaths = { "." }, -- Source all files to current directory
					referencedLibraries = { vim.fn.getcwd() .. "/lib/*.jar" }, -- Source .jar files inside project folder
				},
			},
		},

		-- Language server initialization options
		-- Extend bundles if you want to use additional Eclipse JDTLS plugins
		init_options = {
			bundles = {},
		},
	}

	-- Start a new client & server, or attach to an existing one based on root_dir
	require("jdtls").start_or_attach(config)
end

return M
