
GOPATH?=$(shell go env GOPATH)
GOOS?=$(shell go env GOOS)
GOARCH?=$(shell go env GOARCH)
BINARY=htmleditor
VERSION=0.0.1
SIGNER=hankhill19580@gmail.com
SIGNER_DIR=$(HOME)/i2p-go-keys/
CONSOLEPOSTNAME=I2P Site Editor

#the binaries actually come from $GOPATH/src/github.com/eyedeekay/go-htmleditor

"$(GOPATH)/src/github.com/eyedeekay/go-htmleditor":
	git clone https://github.com/eyedeekay/go-htmleditor "$(GOPATH)/src/github.com/eyedeekay/go-htmleditor"; true

pull: "$(GOPATH)/src/github.com/eyedeekay/go-htmleditor"
	cd "$(GOPATH)/src/github.com/eyedeekay/go-htmleditor" && \
		git pull --all

build-all-arches: pull
	cd "$(GOPATH)/src/github.com/eyedeekay/go-htmleditor" && \
		make all

copy-all-arches: build-all-arches
	cp "$(GOPATH)/src/github.com/eyedeekay/go-htmleditor/htmleditor-"* .

plugin-all-arches:
	GOOS=linux GOARCH=amd64 make pluginsu3
	GOOS=linux GOARCH=386 make pluginsu3
	GOOS=windows GOARCH=amd64 make pluginsu3
	GOOS=windows GOARCH=386 make pluginsu3
	GOOS=darwin GOARCH=amd64 make pluginsu3

#if GOOS==windows, then DOTEXE=.exe
DOTEXE=$(shell bash -c '[ "$(GOOS)" == "windows" ] && echo ".exe" || echo ""')

pluginsu3:
	i2p.plugin.native -name=$(BINARY)-$(GOOS)-$(GOARCH) \
		-signer=$(SIGNER) \
		-signer-dir=$(SIGNER_DIR) \
		-version "$(VERSION)" \
		-author=$(SIGNER) \
		-autostart=true \
		-clientname=$(BINARY) \
		-consolename="$(BINARY) - $(CONSOLEPOSTNAME)" \
		-delaystart="1" \
		-desc="`cat desc`" \
		-exename=$(BINARY)-$(GOOS)-$(GOARCH)$(DOTEXE) \
		-icondata=icon/icon.png \
		-consoleurl="http://127.0.0.1:7685" \
		-updateurl="http://idk.i2p/$(BINARY)/$(BINARY)-$(GOOS)-$(GOARCH).su3" \
		-website="http://idk.i2p/$(BINARY)/" \
		-command="$(BINARY)-$(GOOS)-$(GOARCH) -dir=$$I2P/eepsite/docroot" \
		-license=MIT
	unzip -o $(BINARY)-$(GOOS)-$(GOARCH).zip -d $(BINARY)-$(GOOS)-$(GOARCH)-zip