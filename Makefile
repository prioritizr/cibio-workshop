all: clean pdf site

clean:
	rm -rf _book
	rm -rf _bookdown_files

site:
	Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"

pdf:
	Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::pdf_book')"

.PHONY: clean website site
