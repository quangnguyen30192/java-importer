command! JavaSyncImportSources execute "terminal " . g:installedJavaImportPluginPath . "/bin/sync_import_sources.sh " . g:javaImportPluginMonoRepo
command! JavaImport lua require('java-importer').run()
