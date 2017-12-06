PROGNAME <- "boilerplate"

.DEBUG <- interactive() || FALSE
if(.DEBUG) {
    warning("WARNING! DEBUG MODE IS ON!")
    RAW_CLI_ARGS <- character(0)
} else {
    library <- function(...) suppressPackageStartupMessages(base::library(...))
    RAW_CLI_ARGS <- commandArgs(trailingOnly = TRUE)
}

library(methods)
library(zzz)
library(futile.logger); invisible(flog.threshold(DEBUG))
library(magrittr); library(tidyverse)

source("docopt.R")

ARGS <- DOCOPT(PROGNAME, RAW_CLI_ARGS)
