## require(docopt)
## require(stringr)
## require(glue)
## library(futile.logger)
## library(magrittr) ## for %>% and %T>%
## require(checkmate)
## require(zzz) ## Mur's package

DOCOPT <- function(progname, args = commandArgs(trailingOnly = TRUE)) {
    ##--------------------------------------------------------------------------------
    ## Docopt doc:
    ##--------------------------------------------------------------------------------
    optdoc <- "
Boilerplate program description

Usage:
  {progname} (command1|command2) <arg-name>... [options]
  {progname} -h | --help

Options:
  --opt-name=VAL [default: default-val]
" %>% stringr::str_trim()

    
    ##--------------------------------------------------------------------------------
    ## Parse raw args:
    ##--------------------------------------------------------------------------------
    flog.info("parsing raw CLI args")
    PARSED_ARGS <- docopt::docopt(doc = glue::glue(optdoc), args, strict = TRUE) %T>%
        { flog.debug(zzz::sstr(., .name = "parsed args")) }

    
    ##--------------------------------------------------------------------------------
    ## Processing functions:
    ##--------------------------------------------------------------------------------
    process_arg1 <- function(argname = "--arg-name") {
        if(is.null(PARSED_ARGS[[argname]])) return(character(0))
        PARSED_ARGS[[argname]] %T>%
            checkmate::assertString(pattern = "^foo|bar$", .var.name = argname)
    }
    process_db_user <- function(argname) {
        PARSED_ARGS[[argname]] %T>%
            checkmate::assertString(min.chars = 1, .var.name = argname)
    }
        

    ##--------------------------------------------------------------------------------
    ## Process and return args:
    ##--------------------------------------------------------------------------------
    list(
        command = if(PARSED_ARGS[["command-1"]]) {
                      "command-1"
                  } else if(PARSED_ARGS[["command-2"]]) {
                      "command-2"
                  } else {
                      stop("unrecognized subcommand")
                  }
       ,arg1 = process_arg1()
       ,db_user_1 = process_db_user("--db-user-1")
       ,db_user_2 = process_db_user("--db-user-2")
    ) %T>%
        { flog.debug(sstr(., .name = "processed CLI args")) } %>%
        return()
}
