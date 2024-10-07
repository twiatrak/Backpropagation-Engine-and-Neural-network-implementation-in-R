# Module class - Grandpere class pour le reseau entier
new_module <- function(nin) {
  structure(
    list(
      nin = nin,
      params = list()  # La liste de tous les valeurs
    ),
    class = "module"
  )
}

# Neuron class 
new_neuron <- function(nin) {
  neuron <- new_module(nin)
  
  # Initialisation des poids
  weights <- lapply(1:nin, function(i) {
    Value(runif(1, -1, 1), name = paste0("w", i))
  })
  bias <- Value(runif(1, -1, 1), name = "bias")
  
  neuron$weights <- weights
  neuron$bias <- bias
  neuron$params <- c(weights, list(bias))  # collection des parameters pour la backpropagation
  
  class(neuron) <- c("neuron", "module")
  return(neuron)
}

# Forward method pour neuron
forward.neuron <- function(self, x) {
  # Verifier si le nombre des inputs est egal a nin
  if (length(x) != self$nin) {
    stop(sprintf("Attendu %d inputs, recu %d", self$nin, length(x)))
  }
  
  # Calculer la somme: x1*w1 + x2*w2 + ... + xn*wn + bias
  sum <- self$bias  # On commence avec le bias
  for (i in 1:self$nin) {
    sum <- sum + (x[[i]] * self$weights[[i]])
  }
  
  # Appliquer sigmoid activation
  out <- sigmoid(sum)
  return(out)
}

# Layer class
new_layer <- function(nin, nout) {
  layer <- new_module(nin)
  
  # Creer e nout neurons
  neurons <- lapply(1:nout, function(i) new_neuron(nin))
  layer$neurons <- neurons
  
  # tous les params de neuron
  layer$params <- unlist(lapply(neurons, function(n) n$params), recursive = FALSE)
  
  class(layer) <- c("layer", "module")
  return(layer)
}

# Forward method pour un layer
forward.layer <- function(self, x) {
  # appliquer chaque neuron aux inputs
  outputs <- lapply(self$neurons, function(n) forward(n, x))
  return(outputs)
}

# MLP (Multi-Layer Perceptron) class
new_mlp <- function(nin, hidden_layers, nout) {
  mlp <- new_module(nin)
  
  # Create les tailles des layers
  layer_sizes <- c(nin, hidden_layers, nout)
  
  # creer des layers
  layers <- list()
  for (i in 1:(length(layer_sizes)-1)) {
    layers[[i]] <- new_layer(layer_sizes[i], layer_sizes[i+1])
  }
  
  mlp$layers <- layers
  
  # Prendre tous les params de tous les layers
  mlp$params <- unlist(lapply(layers, function(l) l$params), recursive = FALSE)
  
  class(mlp) <- c("mlp", "module")
  return(mlp)
}

# Forward method pour MLP
forward.mlp <- function(self, x) {
  # Convert inputs to Value objects if they're not already
  x <- lapply(x, function(xi) if(inherits(xi, "Value")) xi else Value(xi))
  
  # Forward pass pour chacun des layers
  current <- x
  for (layer in self$layers) {
    current <- forward(layer, current)
  }
  
  return(current)
}


forward <- function(obj, ...) {
  UseMethod("forward")
}

# Get all the params
get_parameters <- function(obj) {
  obj$params
}

# Example d'usage
train_step <- function(model, x_batch, y_batch, learning_rate = 0.1) {
  # Forward pass
  pred <- forward(model, x_batch)
  
  # Calculer la fonction de perte (loss function)
  if (!is.list(pred)) pred <- list(pred)
  if (!is.list(y_batch)) y_batch <- list(y_batch)
  
  loss <- Value(0)
  for (i in 1:length(pred)) {
    diff <- pred[[i]] - y_batch[[i]]
    loss <- loss + (diff * diff)
  }
  loss <- loss * (1/length(pred))
  
  # Zero gradients
  params <- get_parameters(model)
  for (p in params) {
    p$grad <- 0
  }
  
  # Backward pass
  backward(loss)
  
  # Mettre a jour les parametres
  for (p in params) {
    p$data <- p$data - learning_rate * p$grad
  }
  
  return(loss$data)
}
