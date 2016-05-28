NULL =

bildungsurlaub.pdf:

LATEXMK = latexmk -xelatex  ${@:.pdf=}
#-pdflatex="pdflatex -interaction=nonstopmode" -use-make MyDoc.tex

%.pdf: %.tex
	$(LATEXMK)

%.eps: %.svg
	inkscape --export-eps=$@ $<


%.eps: %.dia
	dia --export=$@ $<

PANDOC = 	pandoc $< -t beamer -s -o $@ --smart \
	-V classoption:aspectratio=169 --slide-level 2 \
	--highlight-style kate
PANDOC += -V theme:guadec
#PANDOC += -V theme:Lisbon
#PANDOC += -V theme:Frankfurt


%.tex: %.md
	$(PANDOC)
	@echo "Done!"

%.tex: %.rst
	$(PANDOC)
	@echo "Done!"

continuous:
	@echo "The PDF will be updated automatically when you save the $(PANDOC_SRC) document. Press Ctrl+C to abort."
	@make; while inotifywait -q .; do sleep 0.1; make --no-print-directory; done
.PHONY: continous

clean:
	rm -Rf *.aux *.log *.nav *.toc *.snm *.out *.vrb
	latexmk -CA

.PHONY: all clean

.DELETE_ON_ERROR:
