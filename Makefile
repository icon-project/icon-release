
SUBDIRS = loopchain icon-rpc-server icon-service
SUBDIR_RC = rewardcalculator

.PHONY: all build $(SUBDIRS) $(SUBDIR_RC)

all: build

build: $(SUBDIRS) $(SUBDIR_RC)

$(SUBDIRS):
	$(MAKE) -C $@ build

$(SUBDIR_RC):
	$(MAKE) -C $(SUBDIR_RC)