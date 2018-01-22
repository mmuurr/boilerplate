PROGNAME <- "boilerplate"

.DEBUG_ARGS <- character(0)
if(interactive()) {
    RAW_CLI_ARGS <- .DEBUG_ARGS
} else {
    RAW_CLI_ARGS <- commandArgs(trailingOnly = TRUE)
    library <- function(...) suppressPackageStartupMessages(base::library(...))
}

library(methods)
##library(magrittr)
##library(tidyverse)
##library(futile.logger); invisible(flog.threshold(if(interactive()) TRACE else INFO))
##library(zzz)

## source any additional R code:
purrr::walk(c("docopt.R"), source)

## parse & process CLI args:
ARGS <- DOCOPT(PROGNAME, RAW_CLI_ARGS) %T>%
    { flog.info(zzz::sstr(., .name = "ARGS")) }
