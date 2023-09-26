Poor man neovim way to add the line of import in Java file
Useful when doing code review, find source of a java symbol without the need of lsp or intellij opened

### Dependencies

```vim
Plug 'nvim-telescope/telescope.nvim'
```

### Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'quangnguyen30192/java-importer', { 'for': 'java' }
```

## Quick Start
Config learn path, which point to your set of source code to learn import lines
```vim
let g:javaImportPluginMonoRepo = $HOME . "/all-your-java-projects"
let g:installedJavaImportPluginPath = "your-path-to-the-installed-plugins"

```
Run JavaSyncImportSources to build import dictionary cache from library
```vim
```
And map key to use it
```vim
nnoremap <space>ip :JavaImport<cr>
