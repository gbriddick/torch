Device <- R7Class(
  classname = "torch_device",
  public = list(
    ptr = NULL,
    initialize = function(type, index = NULL, ptr = NULL) {
      if (!is.null(ptr)) {
        return(ptr)
      }

      if (grepl(":", type, fixed = TRUE)) {
        if (!is.null(index)) {
          value_error("type {type} should not include any index because index was passed explicitly.")
        }

        spl <- strsplit(type, ":", fixed = TRUE)[[1]]
        type <- spl[1]
        index <- as.integer(spl[2])
      }

      cpp_torch_device(type, index)
    },
    print = function() {
      s <- paste0("torch_device(type='", self$type, "'")

      if (is.null(self$index)) {
        s <- paste0(s, ")")
      } else {
        s <- paste0(s, ", index=", self$index, ")")
      }

      cat(s, "\n")
    }
  ),
  active = list(
    index = function() {
      index <- cpp_device_index_to_int(self$ptr)

      if (index == -1) {
        return(NULL)
      }

      index
    },
    type = function() {
      cpp_device_type_to_string(self$ptr)
    },
    ptr = function() {
      self
    }
  )
)

#' @export
as.character.torch_device <- function(x, ...) {
  chr <- x$type
  if (!is.null(x$index)) {
    chr <- paste0(chr, ":", x$index)
  }
  chr
}

#' Create a Device object
#'
#' A `torch_device`  is an object representing the device on which a `torch_tensor`
#' is or will be allocated.
#'
#' @param type (character) a device type `"cuda"` or `"cpu"`
#' @param index (integer) optional device ordinal for the device type.  If the device ordinal
#' is not present, this object will always represent the current device for the device
#' type, even after `torch_cuda_set_device()` is called; e.g., a `torch_tensor` constructed
#' with device `'cuda'` is equivalent to `'cuda:X'` where X is the result of
#' `torch_cuda_current_device()`.
#'
#' A `torch_device` can be constructed via a string or via a string and device ordinal
#'
#' @concept tensor-attributtes
#'
#' @examples
#'
#' # Via string
#' torch_device("cuda:1")
#' torch_device("cpu")
#' torch_device("cuda") # current cuda device
#'
#' # Via string and device ordinal
#' torch_device("cuda", 0)
#' torch_device("cpu", 0)
#' @export
torch_device <- function(type, index = NULL) {
  Device$new(type, index)
}

#' Checks if object is a device
#'
#' @param x object to check
#' @concept tensor-attributes
#'
#' @export
is_torch_device <- function(x) {
  inherits(x, "torch_device")
}

is_cuda_device <- function(x) {
  x$type == "cuda"
}

is_cpu_device <- function(x) {
  x$type == "cpu"
}

is_meta_device <- function(x) {
  force(x)
  x$type == "meta"
}

#' @export
`==.torch_device` <- function(x, y) {
  if (!is_torch_device(y)) {
    runtime_error("y is not a torch_device")
  }
  x$type == y$type && identical(x$index, y$index)
}

#' @export
`!=.torch_device` <- function(x, y) {
  !(x == y)
}

#' Device contexts
#' @param device A torch device to be used by default when creating new tensors.
#' @param code The code to be evaluated in the modified environment.
#' @inheritParams local_autocast
#' @export
local_device <- function(device, ..., .env = parent.frame()) {
  current_device <- cpp_get_current_default_device()
  cpp_set_default_device(device)

  withr::defer({
    cpp_set_default_device(current_device)
  }, envir = .env)
}

#' @describeIn local_device Modifies the default device for the selected context.
#' @export
with_device <- function(code, ..., device) {
  local_device(device)
  force(code)
}
