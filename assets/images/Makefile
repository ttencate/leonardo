SVGS=$(wildcard *.svg)
PNGS=$(patsubst %.svg,%.png,$(SVGS))

.PHONY: all
all: $(PNGS)

%.png: %.svg
	inkscape --export-area-page --without-gui $< --export-png=$@
