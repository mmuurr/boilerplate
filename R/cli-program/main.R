.DEBUG <- interactive() || FALSE
if(.DEBUG) {
    warning("WARNING! DEBUG MODE IS ON!")
} else {
    library <- function(...) suppressPackageStartupMessages(base::library(...))
    ##reg.finalizer(globalenv(), function(env) print(sessioninfo::session_info()), onexit = TRUE)
}

library(methods)
library(zzz)
library(futile.logger); invisible(flog.threshold(DEBUG))
library(tidyverse); library(magrittr)

source("docopt.R")

PROGNAME <- "boilerplate"
ARGS <- DOCOPT(PROGNAME, .DEBUG)
