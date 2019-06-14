## Imports: docopt, glue, stringr, checkmate, zzz, magrittr

DOCOPT <- function(raw_args = commandArgs(trailingOnly = TRUE), progname = "boilerplate") {
    ## selective infix imports:
    `%>%` <- magrittr::`%>%`
    `%T>%` <- magrittr::`%T>%`
    
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
    flog.debug("parsing raw CLI args")
    PARSED_ARGS <- docopt::docopt(doc = glue::glue(optdoc), raw_args, strict = TRUE) %T>%
        { flog.debug(zzz::sstr(., .name = "parsed args")) }

    
    ##--------------------------------------------------------------------------------
    ## Processing functions (that assert):
    ##--------------------------------------------------------------------------------
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
       ,arg1 = PARSED_ARGS[["--opt-name"]]
       ,db_user_1 = process_db_user("--db-user-1")
       ,db_user_2 = process_db_user("--db-user-2")
    ) %T>%
        { flog.debug(zzz::sstr(., .name = "processed CLI args")) } %>%
        return()
}
