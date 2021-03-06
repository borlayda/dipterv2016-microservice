# constants for defining the author, title, etc.
FILENAME = microservice
TITLE = Mikroszolgáltatás alapú architektúra fejlesztésének és tesztelésének támogatása
AUTHOR = Borlay Dániel
ADVISOR = Szatmári Zoltán
UNIVERSITY = Budapesti Műszaki és Gazdaságtudományi Egyetem
DEPARTMENT = Méréstechnika és Információs Rendszerek Tanszék
THESIS_TYPE = Diplomaterv
DOCUMENT_LANG = magyar
SOURCE_FILES = abstract.md intro.md background.md advantages.md technologies.md communication.md design.md implementation.md summary.md
APPENDIX_FILE = appendix.md

# variables for the PDF/HTML compiler
ARGS = \
	$(SOURCE_FILES) \
	--from=markdown \
	--variable=lang:"$(DOCUMENT_LANG)" \
	--variable=title:"$(TITLE)" \
	--variable=author:"$(AUTHOR)" \
	--variable=advisor:"$(ADVISOR)" \
	--variable=university:"$(UNIVERSITY)" \
	--variable=department:"$(DEPARTMENT)" \
	--variable=thesis-type:"$(THESIS_TYPE)" \
	--variable=lof \
	--variable=lot \
	--standalone \
	--table-of-contents \
	--bibliography=bibliography.bib \

LATEX_ARGS = \
	$(ARGS) \
	--include-after-body=$(APPENDIX_FILE).tex \
	--template=template.latex \
	--variable=documentclass:report \
	--variable=fontsize:11pt \
	--variable=papersize:a4paper \
	--variable=sides:twoside \
	--variable=numbersections \
	--natbib \
	--variable=biblio-files:"bibliography" \
	--variable=biblio-style:"plain" \

HTML_ARGS = \
	--mathjax \
	--filter pandoc-citeproc \

# rules

## rules for compiling the document

pdf: latex build-latex


latex: compile-appendix-tex
	pandoc \
		$(LATEX_ARGS) \
		--to=latex \
		--output=$(FILENAME).tex \

html: compile-guideline-html compile-appendix-html
	pandoc \
		$(FILES) \
		$(ARGS) \
		$(HTML_ARGS) \
		--include-before-body=$(BEFORE_FILE).html \
		--include-after-body=$(APPENDIX_FILE).html \
		--to=html \
		--output=$(FILENAME).html \
		--css=buttondown.css \

epub: compile-guideline-html compile-appendix-html
	pandoc \
		$(FILES) \
		$(ARGS) \
		--include-before-body=$(BEFORE_FILE).html \
		--include-after-body=$(APPENDIX_FILE).html \
		--output=$(FILENAME).epub \
		--css=buttondown.css \
		--epub-metadata=metadata.xml \

build-latex:
	sed -i s/begin{figure}\[[htbp]*\]/begin{figure}[H]/g $(FILENAME).tex
	pdflatex $(FILENAME).tex
	bibtex $(FILENAME).aux
	pdflatex $(FILENAME).tex
	pdflatex $(FILENAME).tex

## rules for compiling the guideline

compile-guideline-tex:
	pandoc \
		$(BEFORE_FILE) \
		--from=markdown \
		--to=latex \
		--variable=documentclass:report \
		--output=$(BEFORE_FILE).tex \

compile-guideline-html:
	pandoc \
		$(BEFORE_FILE) \
		--from=markdown \
		--to=html \
		--output=$(BEFORE_FILE).html \

## rules for compiling the appendix

compile-appendix-tex:
	pandoc \
		$(APPENDIX_FILE) \
		--from=markdown \
		--to=latex \
		--variable=documentclass:report \
		--output=$(APPENDIX_FILE).tex \

compile-appendix-html:
	pandoc \
		$(APPENDIX_FILE) \
		$(HTML_ARGS) \
		--from=markdown \
		--to=html \
		--output=$(APPENDIX_FILE).html \

## misc rules

open:
	gnome-open \
		$(FILENAME).pdf \

clean:
	rm -f *.tex *.aux *.dvi *.log *.pdf *.html *.mobi *.out *.epub
