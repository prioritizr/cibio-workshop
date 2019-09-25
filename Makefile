all: clean data pdf site

clean:
	rm -rf _book
	rm -rf _bookdown_files
	rm -f data.zip

data:
	mkdir -p data
	Rscript -e "library(prioritizrdata);library(raster);data(tas_pu,tas_features);rgdal::writeOGR(tas_pu,'data','pu',overwrite=TRUE,driver='ESRI Shapefile');writeRaster(tas_features,'data/vegetation.tif',NAflag=-9999)"
	zip -r data.zip data
	rm -rf data

site:
	Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"

pdf:
	Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::pdf_book')"

.PHONY: data clean website site data
