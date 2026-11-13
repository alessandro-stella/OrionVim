return {
	"mfussenegger/nvim-jdtls",
	ft = "java",
	config = function()
		print("Java file detected, starting JDTLS...")

		local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
		local workspace_dir = vim.fn.expand("~/.workspaces-java") .. "/" .. project_name
		local mason_jdtls = vim.fn.stdpath("data") .. "/mason/packages/jdtls"

		local launcher_jar = vim.fn.glob(mason_jdtls .. "/plugins/org.eclipse.equinox.launcher_*.jar", true)
		if launcher_jar == "" then
			vim.notify(">>> [JDTLS ERROR] Launcher jar not found! <<<", vim.log.levels.ERROR)
			return
		end
		launcher_jar = vim.split(launcher_jar, "\n")[1]

		local lombok_jar = mason_jdtls .. "/lombok.jar"

		local config = {
			cmd = {
				"java",
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
				"-javaagent:" .. lombok_jar,
				"-jar",
				launcher_jar,
				"-configuration",
				mason_jdtls .. "/config_linux",
				"-data",
				workspace_dir,
			},
			root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml" }) or vim.fn.getcwd(),
			settings = {
				java = {
					project = {
						sourcePaths = { "." },
						referencedLibraries = {
							vim.fn.getcwd() .. "/lib/*.jar",
						},
					},
				},
			},
			on_attach = function(client, _)
				client.server_capabilities.semanticTokensProvider = nil
			end,
		}

		require("jdtls").start_or_attach(config)
	end,
}
