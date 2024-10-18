Value <- function(data, children = list(), op = '') {
  self <- new.env()
  
  self$data <- as.numeric(data)
  self$grad <- 0
  self$backward <- function() {}
  self$prev <- children
  self$op <- op
  self$id <- paste0("node_", sample(1000000, 1))
  
  class(self) <- "Value"
  
  if (length(children) > 0) {
    if (op == '+') {
      self$backward <- function() {
        self$prev[[1]]$grad <- self$prev[[1]]$grad + self$grad
        self$prev[[2]]$grad <- self$prev[[2]]$grad + self$grad
      }
    } else if (op == '*') {
      self$backward <- function() {
        self$prev[[1]]$grad <- self$prev[[1]]$grad + (self$prev[[2]]$data * self$grad)
        self$prev[[2]]$grad <- self$prev[[2]]$grad + (self$prev[[1]]$data * self$grad)
      }
    }
  }
  
  self
}

# Operator overloading
`+.Value` <- function(a, b) {
  if (!inherits(b, "Value")) b <- Value(b)
  Value(a$data + b$data, list(a, b), '+')
}

`*.Value` <- function(a, b) {
  if (!inherits(b, "Value")) b <- Value(b)
  Value(a$data * b$data, list(a, b), '*')
}

# Activation functions
relu <- function(x) {
  out <- Value(max(0, x$data), list(x), 'relu')
  out$backward <- function() {
    x$grad <- x$grad + (ifelse(out$data > 0, 1, 0) * out$grad)
  }
  out
}

sigmoid <- function(x) {
  out <- Value(1 / (1 + exp(-x$data)), list(x), 'sigmoid')
  out$backward <- function() {
    s <- out$data
    x$grad <- x$grad + (s * (1 - s) * out$grad)
  }
  out
}

# Backward pass
backward <- function(root) {
  # Topological sort
  topo <- list()
  visited <- new.env()
  
  build_topo <- function(v) {
    if (!exists(v$id, visited)) {
      assign(v$id, TRUE, envir = visited)
      for (child in v$prev) {
        build_topo(child)
      }
      topo[[length(topo) + 1]] <<- v
    }
  }
  
  build_topo(root)
  
  # reset gradients
  for (v in topo) {
    v$grad <- 0
  }
  
  # Backward pass
  root$grad <- 1
  for (v in rev(topo)) {
    v$backward()
  }
}

print.Value <- function(x, ...) {
  cat(sprintf("Value(data=%.4f, grad=%.4f)\n", x$data, x$grad))
}
