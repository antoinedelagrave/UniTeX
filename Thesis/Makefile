MAIN = main
SHELL = /bin/bash
PROJECT = UniTeX_Thesis
DATE = $(shell date +"%F-%H")

# Retreiving all source files
BIB = $(shell find . -name "*.bib" -type f)
FIGS = $(shell find . -name "figs/*" -type f)
STY = $(shell find . -name "*.sty" -type f)
BST = $(shell find . -name "*.bst" -type f)
XMP = $(MAIN).xmpdata
TEX = $(shell find . -name "*.tex" -type f)

SOURCE = $(BIB) $(STY) $(BST) $(XMP) $(TEX) $(FIGS)
GARBAGE = {bbl,synctex.gz,aux,fdb_latexmk,fls,log,xmpi,brf}

# Setting LaTeX compile (latexmk) options & flags
MK = latexmk

# Generate pdf version of document using pdflatex
OUT = pdf

# Run a file previewer and continually update the files
OUT_MODE = pvc

# Sets the generation of pdf files by pdflatex
GENERATOR = pdflatex
OPT = -interaction=batchmode

HIDE = @
MAKE = make

# OS commands specific part
ifeq ($(OS), Windows_NT)
    RM = del /F /Q
    RMDIR = -RMDIR /S /Q
    MKDIR = -mkdir
else
    RM = -rm -f
    RMDIR = -rm -rf
    MKDIR = -mkdir -p
endif

.PHONY: all $(MAIN).pdf clean targz zip

all: $(MAIN).pdf

$(MAIN).pdf: $(SOURCE)
	$(MK) -$(OUT) -$(OUT_MODE) -$(GENERATOR)="pdflatex $(OPT)" $(MAIN)
	$(MK) -c

dry: $(SOURCE)
	$(MK) -$(OUT) -$(GENERATOR)="pdflatex $(OPT)" $(MAIN)

clean:
	$(HIDE)$(RM) *.$(GARBAGE)
	$(MK) -c
	$(HIDE)echo -e "\n'Thesis' template cleaned !"

targz:
	$(MAKE) clean
	$(MAKE) dry
	$(MAKE) clean
	tar czf $(PROJECT)_$(DATE).tgz $(SOURCE) ./figs

zip:
	$(MAKE) clean
	$(MAKE) dry
	$(MAKE) clean
	zip -q -r $(PROJECT)_$(DATE).zip $(SOURCE) ./figs
