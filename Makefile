all: slides.pdf
debug: slides.tex slides.pdf

slides.pdf: arch.markdown template.latex
	pandoc arch.markdown -t beamer --latex-engine xelatex -o slides.pdf --template=template.latex

# Useful for debugging
slides.tex: arch.markdown template.latex
	pandoc arch.markdown -t beamer --latex-engine xelatex -o slides.tex --template=template.latex

clean:
	rm slides.pdf
