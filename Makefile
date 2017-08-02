# 
# Use make BRANCH=something to build specific branch
# Upstrimv version is by default set to build date.
# Use make VERSION= something to override
#
BRANCH=master
VERSION := $(shell date +%Y%m%d)
PKGNAME=libengine-gost-openssl1.1
ARCH := $(shell dpkg --print-architecture)
all: $(PKGNAME)_$(VERSION)-1_$(ARCH).deb

tar: $(PKGNAME)_$(VERSION).orig.tar.bz2

#
# This rule updates GIT repository and creates tarball with
# original (upstream, i.e. distribution-agnostic) sources of engine
#
$(PKGNAME)_$(VERSION).orig.tar.bz2: engine/README.md
	cd engine; git pull
	cd engine; git archive --format tar \
		--prefix=$(PKGNAME)-$(VERSION)/ \
		master |bzip2 > ../$(PKGNAME)_$(VERSION).orig.tar.bz2
#
# This rule does intital clone of engine git repository should it be
# absent
#
engine/README.md:
	git clone https://github.com/gost-engine/engine.git

#
# This rule actually build source and binare package starting with
# unpacked debian source directory
#

$(PKGNAME)_$(VERSION)-1_$(ARCH).deb: $(PKGNAME)-$(VERSION)/debian/changelog
	cd $(PKGNAME)-$(VERSION); debuild
#
# This rule creates unpacked Debian source by copiing debian
# subdirectory from this git module into unpacked distribution-agnostic
# source.
# Note - change debian subdirectory here and not inside
# $(PKGNAME)-$(VERSION) if you want you changes survive invocation of
# this rule
#
$(PKGNAME)-$(VERSION)/debian/changelog: $(PKGNAME)_$(VERSION).orig.tar.bz2 $(wildcard debian/*)	
		rm -rf $(PKGNAME)-$(VERSION)
		tar xf $(PKGNAME)_$(VERSION).orig.tar.bz2
		cp -r debian $(PKGNAME)-$(VERSION)/debian
		cd $(PKGNAME)-$(VERSION); dch -v $(VERSION)-1 "Build for $(ARCH)"

