Value <- function(data, children = list(), op = '', name = NULL) {
  self <- new.env(parent = emptyenv())
  
  self$data <- data
  self$grad <- 0
  self$prev <- children
  self$op <- op
  self$id <- if (!is.null(name)) name else paste0("node_", sample(1000, 1))
  self$op_params <- list()
  
  class(self) <- "Value"
  
  self$compute_grad <- function() {}
  # Definir le calcul des gradients pour chacun des operateurs
  if (length(children) > 0) {
    if (op == '+') {
      child1 <- children[[1]]
      child2 <- children[[2]]
      
      self$compute_grad <- function() {
        child1$grad <- child1$grad + self$grad
        child2$grad <- child2$grad + self$grad
      }
    } else if (op == '*') {
      child1 <- children[[1]]
      child2 <- children[[2]]
      
      self$compute_grad <- function() {
        child1$grad <- child1$grad + (child2$data * self$grad)
        child2$grad <- child2$grad + (child1$data * self$grad)
      }
    } else if (op == '^') {
      child1 <- children[[1]]
      power <- self$op_params$power
      
      self$compute_grad <- function() {
        child1$grad <- child1$grad + (power * (child1$data ^ (power - 1)) * self$grad)
      }
    } else if (op == '/') {
      child1 <- children[[1]]
      child2 <- children[[2]]
      
      self$compute_grad <- function() {
        child1$grad <- child1$grad + (self$grad / child2$data)
        child2$grad <- child2$grad + (-child1$data * self$grad / (child2$data^2))
      }
    } else if (op == 'sigmoid') {
      child <- children[[1]]
      self$compute_grad <- function() {
        dsigm <- self$data * (1 - self$data)
        child$grad <- child$grad + (self$grad * dsigm)
      }
    }
  }
  
  return(self)
}
##Operator overloading functions
`+.Value` <- function(self, other) {
  other <- if (inherits(other, "Value")) other else Value(other)
  Value(self$data + other$data, list(self, other), '+')
}

`*.Value` <- function(self, other) {
  other <- if (inherits(other, "Value")) other else Value(other)
  Value(self$data * other$data, list(self, other), '*')
}

`-.Value` <- function(self, other) {
  if(missing(other)) {  # Unary minus
    return(self * (-1))
  }
  # Binary minus
  other <- if (inherits(other, "Value")) other else Value(other)
  self + (other * (-1))
}

`/.Value` <- function(self, other) {
  other <- if (inherits(other, "Value")) other else Value(other)
  if (other$data == 0) {
    stop("Division by zero")
  }
  Value(self$data / other$data, list(self, other), '/')
}

sigmoid <- function(self) {
  sigm <- 1 / (1 + exp(-self$data))
  Value(sigm, list(self), 'sigmoid')
}

`^.Value` <- function(self, other) {
  if (inherits(other, "Value")) {
    stop("Erreur, La puissance est supporte que pour les valeurs scalaires")
  }
  result <- Value(self$data ^ other, list(self), '^')
  result$op_params$power <- other
  return(result)
}
#Backward - pass, 
backward <- function(v) {
  # Initialisation d'environnement
  topo <- list()
  visited <- new.env(hash = TRUE)
  
  # topological sort de noeuds enfants
  build_topo <- function(v) {
    if (!(v$id %in% ls(visited))) {
      visited[[v$id]] <- TRUE
      for (child in v$prev) {
        build_topo(child)
      }
      topo[[length(topo) + 1]] <<- v
    }
  }
  
  # Perform topological sort
  build_topo(v)
  
  # Remettre tous les gradients a zero
  for (node in topo) {
    node$grad <- 0
  }
  
  # Mettre le gradient final a 1
  v$grad <- 1
  
  # Backpropagation
  for (i in length(topo):1) {
    topo[[i]]$compute_grad()
  }
}

print.Value <- function(x, ...) {
  cat(sprintf("Value(data=%f, grad=%f)\n", x$data, x$grad))
}
