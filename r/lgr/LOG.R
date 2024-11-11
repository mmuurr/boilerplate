LOG <- (function() {
  logger <- lgr::get_logger("app")
  function(level, msg = "", ...) {
    try(logger$log(level, msg, ...))
  }
})()
