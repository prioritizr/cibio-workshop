#!/bin/sh

set -ev

Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"
# Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::pdf_book')"
# export MANUALVERSION=TEACHER
# Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::pdf_book', config_file='_bookdown2.yml')"
