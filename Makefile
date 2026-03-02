SHELL := /bin/bash
.DEFAULT_GOAL := help

REPO_DIR := $(shell pwd)


PORTAGE_ITEMS := \
  make.conf \
  package.use \
  package.accept_keywords \
  package.mask \
  package.unmask \
  package.license

SYNC_FILES := \
  /etc/default/grub \
  /etc/fstab \
  /etc/hosts \
  /etc/locale.gen \
  /etc/nsswitch.conf \
  /etc/vconsole.conf \
  /etc/avahi/avahi-daemon.conf \
  /etc/cups/cupsd.conf \
  /etc/pam.d/login \
  /etc/eselect/repository.conf \
  /var/lib/portage/world

SYNC_DIRS := \
  /etc/avahi/services \
  /etc/modules-load.d \
  /etc/portage/repos.conf

LOG_COMMANDS := \
  "dmesg:dmesg --color=never" \
  "lsmod:lsmod" \
  "lspci:sudo lspci -v" \
  "lsusb:sudo lsusb -v" \
  "rfkill:rfkill list"

.PHONY: help sync logs diff clean

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	  awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-10s\033[0m %s\n", $$1,$$2}'

sync: ## Sync system configs into repo
	@echo "=== Syncing portage ==="
	@for item in $(PORTAGE_ITEMS); do \
	  src="/etc/portage/$$item"; \
	  dest="$(REPO_DIR)/etc/portage/$$item"; \
	  if [ -d "$$src" ]; then \
	    mkdir -p "$$dest"; \
	    rsync -a --delete "$$src/" "$$dest/"; \
	  elif [ -f "$$src" ]; then \
	    mkdir -p "$$(dirname "$$dest")"; \
	    cp "$$src" "$$dest"; \
	  else \
	    rm -rf "$$dest"; \
	  fi; \
	done

	@echo "=== Syncing config files ==="
	@for f in $(SYNC_FILES); do \
	  dest="$(REPO_DIR)$$f"; \
	  if [ -f "$$f" ]; then \
	    mkdir -p "$$(dirname "$$dest")"; \
	    cp "$$f" "$$dest"; \
	  fi; \
	done

	@echo "=== Syncing config directories ==="
	@for d in $(SYNC_DIRS); do \
	  dest="$(REPO_DIR)$$d"; \
	  if [ -d "$$d" ]; then \
	    mkdir -p "$$dest"; \
	    rsync -a --delete "$$d/" "$$dest/"; \
	  fi; \
	done

	@echo "=== Syncing kernel config ==="
	@mkdir -p "$(REPO_DIR)/usr/src/linux"
	@if [ -f "/usr/src/linux/.config" ]; then \
	  cp "/usr/src/linux/.config" "$(REPO_DIR)/usr/src/linux/.config"; \
	elif [ -f "/proc/config.gz" ]; then \
	  zcat /proc/config.gz > "$(REPO_DIR)/usr/src/linux/.config"; \
	else \
	  echo "Warning: no kernel config found"; \
	fi
	@echo "=== Done ==="

logs: ## Capture hardware/system logs
	@mkdir -p "$(REPO_DIR)/var/logs"
	@for entry in $(LOG_COMMANDS); do \
	  name="$${entry%%:*}"; \
	  cmd="$${entry#*:}"; \
	  echo "Capturing $$name..."; \
	  eval "$$cmd" > "$(REPO_DIR)/var/logs/$$name" 2>&1 || true; \
	done
	@echo "=== Done ==="

diff: ## Show diff between live system and repo
	@echo "=== Portage ==="
	@for item in $(PORTAGE_ITEMS); do \
	  src="/etc/portage/$$item"; \
	  dest="$(REPO_DIR)/etc/portage/$$item"; \
	  if [ -d "$$src" ]; then \
	    diff -rq "$$src" "$$dest" 2>/dev/null || true; \
	  elif [ -f "$$src" ]; then \
	    diff -u "$$dest" "$$src" 2>/dev/null || true; \
	  fi; \
	done

	@echo "=== Config files ==="
	@for f in $(SYNC_FILES); do \
	  dest="$(REPO_DIR)$$f"; \
	  if [ -f "$$f" ] && [ -f "$$dest" ]; then \
	    diff -u "$$dest" "$$f" 2>/dev/null || true; \
	  fi; \
	done

	@echo "=== Kernel config ==="
	@if [ -f "/usr/src/linux/.config" ]; then \
	  diff -u "$(REPO_DIR)/usr/src/linux/.config" "/usr/src/linux/.config" 2>/dev/null | head -50 || true; \
	fi

clean: ## Remove stale files that no longer exist on the system
	@echo "=== Checking for stale package.use files ==="
	@for f in $(REPO_DIR)/etc/portage/package.use/*; do \
	  name="$$(basename "$$f")"; \
	  if [ ! -f "/etc/portage/package.use/$$name" ]; then \
	    echo "Removing stale: $$name"; \
	    rm -f "$$f"; \
	  fi; \
	done

	@echo "=== Checking for stale modules-load.d files ==="
	@for f in $(REPO_DIR)/etc/modules-load.d/*; do \
	  name="$$(basename "$$f")"; \
	  if [ ! -f "/etc/modules-load.d/$$name" ]; then \
	    echo "Removing stale: $$name"; \
	    rm -f "$$f"; \
	  fi; \
	done

	@echo "=== Done ==="
