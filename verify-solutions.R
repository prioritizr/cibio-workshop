# create temporary directory
td <- file.path(tempdir(), basename(tempfile()))

# find Rmd files
src_rmd_paths <- dir(".", "^.*\\.Rmd", full.names = TRUE)

# copy Rmd files to temporary directory
file.copy(src_rmd_paths, td)

# find copied Rmd files
tmp_rmd_paths <- dir(td, "^.*\\.Rmd", full.names = TRUE)

# iterate over text in Rmd files and remove block2 chunks and replace
# specify that code in back ticks should be treated as code
# i.e. convert `print(1)` to `r print(1)`
result <- sapply(tmp_rmd_paths, function(x) {
  ## ingest rmarkdown file
  r <- readLines(x)
  ## find block2 chunks
  b2_line_idx <- which(startsWith(r, "```{block2"))
  ## find backticks
  all_backticks_idx <- which(r == "```")
  b2_backticks <- numeric(length(b2_line_idx))
  for (i in seq_along(b2_line_idx)) {
    ### remove backticks before the b2 line
    j <- all_backticks_idx[all_backticks_idx > b2_line_idx[i]]
    ### find nearest backtick
    b2_backticks[i] <- min(all_backticks_idx)
  }
  ## convert inline chunks without r inside the backtick region to
  ## inline r chunks
  for (i in seq_along(b2_line_idx)) {
    r[seq(b2_line_idx[i] + 1, b2_backticks[i] - 1)] <-
      gsub("`", "`r ", fixed = TRUE, r[seq(b2_line_idx[i], b2_backticks[i])])
  }
  ## remove b2 lines and their backticks
  r <- r[-1 * c(b2_line_idx, b2_backticks)]
  ## save result
  writeLines(r, x)
})

# purl R code
for (x in tmp_rmd_paths)
  knitr::purl(x)
