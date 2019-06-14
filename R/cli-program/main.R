#!/usr/bin/R
PROGNAME <- "boilerplate"  ## <-- set program name


##------------------------------------------------------------------------------
## interactive == debug mode
##------------------------------------------------------------------------------
.DEBUG_ARGS <- character(0)
.DEBUG <- interactive() || FALSE

if(.DEBUG) {
    warning("WARNING: DEBUG MODE IS ON!")
    RAW_CLI_ARGS <- .DEBUG_ARGS
} else {
    library <- function(...) suppressPackageStartupMessages(base::library(...))  ## quiet library()
    RAW_CLI_ARGS <- commandArgs(trailingOnly = TRUE)
}


##------------------------------------------------------------------------------
## default logger setup
##------------------------------------------------------------------------------
library(futile.logger)
if(.DEBUG) {
    invisible(flog.threshold(TRACE))
    invisible(flog.layout(layout.format("[~l ~t ~n:::~f] ~m", "%FT%T%z"), "ROOT"))
} else {
    invisible(flog.threshold(INFO))
    invisible(flog.layout(layout.format("[~l ~t] ~m", "%FT%T%z"), "ROOT"))
}


##------------------------------------------------------------------------------
## rest of preamble (library, source, import::from, etc.)
##------------------------------------------------------------------------------
library(methods)


##------------------------------------------------------------------------------
## cli args
##------------------------------------------------------------------------------
source("docopt.R")
ARGS <- DOCOPT(RAW_CLI_ARGS, PROGNAME)


