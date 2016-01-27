all: slides.pdf

slides.pdf: arch.markdown template.latex
	pandoc arch.markdown -t beamer --latex-engine xelatex -o slides.pdf --template=template.latex

clean:
	rm slides.pdf
