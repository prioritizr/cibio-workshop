all: clean data test pdf site

clean:
	@rm -rf _book
	@rm -rf _bookdown_files
	@rm -f data.zip
	@rm -rf data

clean_temp:
	@rm -f prioritizr-workshop-manual.Rmd
	@rm -f prioritizr-workshop-manual-teaching.Rmd

data:
	mkdir -p data
	Rscript -e "library(prioritizrdata);library(raster);data(tas_pu,tas_features);rgdal::writeOGR(tas_pu,'data','pu',overwrite=TRUE,driver='ESRI Shapefile');writeRaster(tas_features,'data/vegetation.tif',NAflag=-9999)"
	zip -r data.zip data
	rm -rf data

site: clean_temp
	Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"

pdf: student_pdf teacher_pdf

teacher_pdf: clean_temp
	export MANUALVERSION=TEACHER; \
	Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::pdf_book', config_file='_bookdown2.yml')"
	rm -f prioritizr-workshop-manual-teacher.log

student_pdf: clean_temp
	Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::pdf_book')"
	rm -f prioritizr-workshop-manual.log

test:
	R -e "source('verify-solutions.R')"

.PHONY: data clean test website site data
