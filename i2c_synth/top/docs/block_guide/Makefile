DOC 	= main
BUILD 	= build
OUTPUTS = *.toc *.log *.lof *.lot *.aux *.nlo *.out *.nls *.ilg *.lol

all: compile 
	mv $(OUTPUTS) build/

compile:
	for i in 1 2 ; do \
		pdflatex $(DOC).tex; \
	done;
	
compile_error:
	pdflatex -interaction=nonstopmode $(DOC).tex

view:
	evince $(DOC).pdf

images:
	sh images/gen_images.sh
	
clean:
	rm -rf build/*
	rm -rf $(OUTPUTS)