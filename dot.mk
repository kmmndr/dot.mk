#!/usr/bin/env -S make -f

HOME_FOLDER?=$(shell echo $$HOME)
DOT_FOLDER?=$(shell echo ${HOME_FOLDER}/.dotfiles)

export_git_env=export GIT_DIR=${DOT_FOLDER}; export GIT_WORK_TREE=${HOME_FOLDER}; cd ${HOME_FOLDER}

define dot-checkout
	$(export_git_env); git checkout -- $(1)
endef

define dot-difftool
	$(export_git_env); for file in $(1); do echo $$file; folder=$$(dirname $$file); [ "$$folder" != "." ] && mkdir -p $$folder; done; touch $(1); git difftool -- $(1)
endef

.PHONY: help
help: ##- Show this help (default)
	@echo 'Usage: make <target> (see target list below)'
	@echo
	@sed -e '/#\{2\}-/!d; s/\\$$//; s/:[^#\t]*/:/; s/#\{2\}-*//' $(MAKEFILE_LIST)

-include ${HOME_FOLDER}/.dot.mk/*.mk

%-checkout:
	echo "checkout $*"
	$(call dot-checkout, ${$*_paths})

%-difftool:
	echo "difftool $*"
	$(call dot-difftool, ${$*_paths})

.PHONY: init
init: ##- Initialize dotfiles
init: \
	${DOT_FOLDER} \
	${DOT_FOLDER}/info/exclude \
	hide-untracked
	$(export_git_env); git reset --
	-$(export_git_env); git checkout -- .dot.mk

.PHONY: pull
pull: ##- Pull changes from repository
	@$(export_git_env); git fetch origin
	@$(export_git_env); git stash
	@$(export_git_env); git rebase FETCH_HEAD
	@$(export_git_env); git stash pop

.PHONY: push
push: ##- Push changes from repository
	@$(export_git_env); git push

${DOT_FOLDER}:
	@test ${DOTFILE_REPOSITORY} || (echo 'DOTFILE_REPOSITORY not set'; exit 1)
	@git clone --bare ${DOTFILE_REPOSITORY} ${DOT_FOLDER}

.PHONY: ${DOT_FOLDER}/info/exclude
${DOT_FOLDER}/info/exclude:
	@echo "Generating default exclude file..."
	@echo "# Ignore everything" > $@
	@echo "/*" >> $@
	@echo "# Allow dot files" >> $@
	@echo "!/\.*" >> $@
	@echo "# Allow dot directories" >> $@
	@echo "!/\.*/" >> $@
	@echo "# Except cache" >> $@
	@echo ".cache" >> $@

.PHONY: shell
shell: ##- Start dotfiles shell
	@$(export_git_env); cd ${HOME_FOLDER}; PS1="[dotfiles] " ${SHELL}
s: shell

.PHONY: tig
tig: ##- Start tig
	$(export_git_env); tig
t: tig

.PHONY: hide-untracked
hide-untracked: ##- Hide untracked files
	@echo "Hide untracked files"
	@$(export_git_env); git config status.showUntrackedFiles no

.PHONY: show-untracked
show-untracked: ##- Show untracked files
	@echo "Show untracked files"
	@$(export_git_env); git config status.showUntrackedFiles normal

.PHONY: difftool
difftool:
	$(export_git_env); git difftool
