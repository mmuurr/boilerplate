## require(docopt)
## require(stringr)
## require(glue)
## library(futile.logger)
## library(magrittr) ## for %>% and %T>%
## require(checkmate)
## require(zzz) ## Mur's package

## Will use commandArgs(trailingOnly = TRUE) if .debug_args is NULL.
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
    ## Parse CLI:
    ##--------------------------------------------------------------------------------
    flog.info("parsing CLI args")
    cli_args <- docopt::docopt(doc = glue::glue(optdoc), args, strict = TRUE) %T>%
        { flog.debug(zzz::sstr(., .name = "parsed cli args")) }

    ##--------------------------------------------------------------------------------
    ## Parsing functions:
    ##--------------------------------------------------------------------------------
    parse_string <- function(vname) {
        if(is.null(cli_args[[vname]])) return(NULL)
        cli_args[[vname]] %T>%
            checkmate::assertString(min.chars = 1, .var.name = vname)
    }
    parse_flag <- function(vname) {
        if(is.null(cli_args[[vname]])) return(NULL)
        cli_args[[vname]] %>%
            as.logical() %T>%
            checkmate::assertFlag(.var.name = vname)
    }
    parse_int <- function(vname) {
        if(is.null(cli_args[[vname]])) return(NULL)
        cli_args[[vname]] %>%
            as.integer() %T>%
            checkmate::assertInt(.var.name = vname)
    }
    parse_time <- function(vname) {
        if(is.null(cli_args[[vname]])) return(NULL)
        val <- cli_args[[vname]] %>%
            lubridate::ymd_hms(tz = "America/Denver", truncated = 3, quiet = TRUE)
        stopifnot(!is.na(val))
        stopifnot(lubridate::is.POSIXt(val))
        return(val)
    }
    parse_filepath <- function(vname) {
        cli_args[[vname]] %T>%
            checkmate::assertFileExists(access = "r")
    }
        

    ##--------------------------------------------------------------------------------
    ## Returned arg list:
    ##--------------------------------------------------------------------------------
    list(
        command = if(cli_args[["window"]]) "window" else "update"
       ,config_file = parse_filepath("--config-file")
       ,config_names = cli_args[["<config-name>"]]
       #,servicedb_name = parse_string("--servicedb-name")
       #,servicedb_schema = parse_string("--servicedb-schema")
       #,servicedb_table = parse_string("--servicedb-table")
       #,servicedb_pk = parse_string("--servicedb-pk")
       ,servicedb_env = parse_string("--servicedb-env")
       ,servicedb_user = parse_string("--servicedb-user")
       ,redshift_schema = parse_string("--redshift-schema")
       #,redshift_table = parse_string("--redshift-table")
       #,redshift_pk = parse_string("--redshift-pk")
       ,redshift_user = parse_string("--redshift-user")
       ,redshift_copy_iam_role_arn = parse_string("--redshift-copy-iam-role-arn")
       ,chunk_size = parse_int("--chunk-size")
       ,from_dt__incl = parse_time("--from")
       ,to_dt__excl = parse_time("--to")
    ) %T>%
        {flog.debug(sstr(., .name = "processed cli args"))} %>%
        return()
}
