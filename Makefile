
SHELL := /bin/bash

SUBDIRS = loopchain icon-rpc-server icon-service
SUBDIR_RC = rewardcalculator

BUILD_DIR = build
ASSETS_DIR = assets
DOCKER_TAG ?= latest

LOOPCHAIN_DIR = loopchain
CITIZEN_PACK_DIR = citizen_pack_$(DOCKER_TAG)

PACKAGE_INFO = package_info.txt
PACKAGE_CKSUM = package_$(DOCKER_TAG)_sha256sum.txt
PACKAGE_ASSET = $(DOCKER_TAG)_packages.tar.gz
CITIZEN_PACK = $(CITIZEN_PACK_DIR).tar.gz
CITIZEN_PACK_CKSUM = $(CITIZEN_PACK_DIR)_sha256sum.txt
# FIXME : download url
DOWNLOAD_URL = https://github.com/icon-project/icon-release/releases
ICON_RC = icon_rc


.PHONY: all build $(SUBDIRS) $(SUBDIR_RC)

all: build

build: $(SUBDIRS) $(SUBDIR_RC)

$(SUBDIRS):
	$(MAKE) -C $@ build
	@ cp $@/dist/*.whl ./$(BUILD_DIR)/

$(SUBDIR_RC):
	$(MAKE) -C $@
	$(MAKE) -C $@ install DST_DIR=$(abspath $(BUILD_DIR))


.ONESHELL:
assets: package generate-citizen-pack generate-packages-info
	@ echo "> show assets..."
	@ cat $(abspath $(BUILD_DIR))/$(PACKAGE_INFO)
	@ cat $(abspath $(ASSETS_DIR))/$(PACKAGE_CKSUM)
	@ cat $(abspath $(ASSETS_DIR))/$(CITIZEN_PACK_CKSUM)

.ONESHELL:
package:
	@ echo "> Generate package... "

	@ cd $(abspath $(BUILD_DIR))
	@ tar czf $(abspath $(ASSETS_DIR))/$(PACKAGE_ASSET) *.whl icon_rc
	@ rm -rf ./$(PACKAGE_CKSUM)
	@ sha256sum *.whl $(ICON_RC) > $(abspath $(ASSETS_DIR))/$(PACKAGE_CKSUM)

.ONESHELL:
generate-packages-info:
	@ echo "> Generate package info... "

	@ rm -rf $(abspath $(BUILD_DIR))/$(PACKAGE_INFO)
	@ printf "## Docker TAG \n\t$(DOCKER_TAG) \n" >> $(abspath $(BUILD_DIR))/$(PACKAGE_INFO)

	@ printf "\n## Packages \n" >> $(abspath $(BUILD_DIR))/$(PACKAGE_INFO)
	@ for PACKAGE in $(notdir $(wildcard $(BUILD_DIR)/*.whl)) ; do \
		printf "\t$${PACKAGE} \n" >> $(abspath $(BUILD_DIR))/$(PACKAGE_INFO) ; \
	done
	@ printf "\n## Extra binaries \n" >> $(abspath $(BUILD_DIR))/$(PACKAGE_INFO)
	@ printf "\t$(shell $(BUILD_DIR)/$(ICON_RC) -version) \n" >> $(abspath $(BUILD_DIR))/$(PACKAGE_INFO)

	@ printf "\n## Download package file \n\tcurl -O $(DOWNLOAD_URL)/$(PACKAGE_ASSET) \n" >> $(abspath $(BUILD_DIR))/$(PACKAGE_INFO)
	@ printf "\n## Download citizen pack \n\tcurl -O $(DOWNLOAD_URL)/$(CITIZEN_PACK) \n" >> $(abspath $(BUILD_DIR))/$(PACKAGE_INFO)
	@ printf "\n## Get package information \n\tcurl $(DOWNLOAD_URL)/$(PACKAGE_INFO) \n" >> $(abspath $(BUILD_DIR))/$(PACKAGE_INFO)
	@ printf "\n## Get package checksum file \n\tcurl $(DOWNLOAD_URL)/$(PACKAGE_CKSUM) \n" >> $(abspath $(BUILD_DIR))/$(PACKAGE_INFO)
	@ printf "\n## Get citizen_pack checksum file \n\tcurl $(DOWNLOAD_URL)/$(CITIZEN_PACK_CKSUM) \n" >> $(abspath $(BUILD_DIR))/$(PACKAGE_INFO)

.ONESHELL:
generate-citizen-pack:
	@ echo "> Generate citizen pack..."

	@ cd $(BUILD_DIR)
	@ mkdir -p $(CITIZEN_PACK_DIR)/whl
	@ cp $(abspath $(wildcard $(BUILD_DIR)/*.whl)) $(CITIZEN_PACK_DIR)/whl
	@ cp $(ICON_RC) $(CITIZEN_PACK_DIR)
	@ cp -a $(abspath $(LOOPCHAIN_DIR))/citizen/* $(CITIZEN_PACK_DIR)
	@ mv $(CITIZEN_PACK_DIR) $(abspath $(ASSETS_DIR))
	@ echo "Compress citizen pack!"
	@ cd $(abspath $(ASSETS_DIR))
	@ tar czf $(CITIZEN_PACK) $(CITIZEN_PACK_DIR)
	@ rm -rf $(CITIZEN_PACK_DIR) $(CITIZEN_PACK_CKSUM)
	@ sha256sum $(CITIZEN_PACK) > $(CITIZEN_PACK_CKSUM)
