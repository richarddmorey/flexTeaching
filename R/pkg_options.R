# Variable, global to package's namespace. 
# This function is not exported to user space and does not need to be documented.
MYPKGOPTIONS <- settings::options_manager(
  date_format_yaml = "%Y-%m-%d %H:%M:%S %z",
  date_format_prnt = "%A, %d %B %Y at %X %z",
  initial_seed = "s33d",
  start_practice_message = "Switching to practice mode.",
  start_assignment_message = "Switching to assignment mode.",
  secret_filename = "secret",
  assignment_pkg = "flexTeaching"
)

# User function that gets exported:

#' Set or get options for my package
#' 
#' @param ... Option names to retrieve option values or \code{[key]=[value]} pairs to set options.
#'
#' @section Supported options:
#' The following options are supported
#' \itemize{
#'  \item{\code{date_format_yaml}}{(\code{character}) Format from which to parse dates in YAML for assignments }
#'  \item{\code{date_format_prnt}}{(\code{character}) Format in which to print dates (e.g., in error messages) }
#'  \item{\code{initial_seed}}{(\code{character}) Default seed to put in the seed box, if no query string is used }
#'  \item{\code{start_practice_message}}{(\code{character}) Message to give when switching to practice mode }
#'  \item{\code{start_assignment_message}}{(\code{character}) Message to give when switching to assignment mode }
#'  \item{\code{secret_filename}}{(\code{character}) Filename that contains the secret (in the last line of the file) }
#'  \item{\code{assignment_pkg}}{(\code{character}) Installed package to use for the assignments }

#' }
#'
#' @export
#' @importFrom settings options_manager
pkg_options <- function(...){
  # protect against the use of reserved words.
  settings::stop_if_reserved(...)
  MYPKGOPTIONS(...)
}