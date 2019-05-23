install:
	@echo Install dotfiles
	sh ./scripts/install.sh

anyanv:
	@echo Install anyanv
	sh ./scripts/install_anyenv.sh

vim:
	@echo Install Vim
	sh ./scripts/install_vim.sh
	sh ./scripts/fix_vimproc.sh
