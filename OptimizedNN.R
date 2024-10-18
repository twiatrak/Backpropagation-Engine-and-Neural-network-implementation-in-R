source("OptimizedEngine.R")
Neuron <- function(nin, activation = relu) {
  self <- structure(
    list(
      weights = lapply(1:nin, function(i) Value(rnorm(1, 0, 1/sqrt(nin)))),
      bias = Value(0),
      activation = activation,
      forward = function(x) {
        x <- lapply(x, function(xi) if (inherits(xi, "Value")) xi else Value(xi))
        act <- Reduce(`+`, Map(`*`, self$weights, x)) + self$bias
        self$activation(act)
      }
    ),
    class = "Neuron"
  )
  self
}

Layer <- function(nin, nout, activation = relu) {
  self <- structure(
    list(
      neurons = lapply(1:nout, function(i) Neuron(nin, activation)),
      forward = function(x) {
        lapply(self$neurons, function(neuron) neuron$forward(x))
      }
    ),
    class = "Layer"
  )
  self
}

MLP <- function(nin, hidden_layers, nout) {
  sizes <- c(nin, hidden_layers, nout)
  
  self <- structure(
    list(
      layers = lapply(1:(length(sizes)-1), function(i) {
        # if last layer - apply sigmoid else relu
        activation <- if(i == length(sizes)-1) sigmoid else relu
        Layer(sizes[i], sizes[i+1], activation)
      }),
      forward = function(x) {
        for (layer in self$layers) {
          x <- layer$forward(x)
        }
        if (length(x) == 1) x[[1]] else x
      },
      parameters = function() {
        params <- list()
        for (layer in self$layers) {
          for (neuron in layer$neurons) {
            params <- c(params, neuron$weights, list(neuron$bias))
          }
        }
        params
      }
    ),
    class = "MLP"
  )
  self
}
#adaptive learning rate
train <- function(model, xs, ys, epochs=100, learning_rate=0.1,max_lr=1.0, min_lr=1e-8) {
  losses <- numeric(epochs)
  
  for (epoch in 1:epochs) {
    # Forward pass
    ypred <- lapply(xs, function(x) model$forward(x))
    
    # Compute loss
    loss <- Value(0)
    for (i in 1:length(ys)) {
      diff <- ypred[[i]] - Value(ys[[i]])
      loss <- loss + diff * diff
    }
    loss <- loss * (1/length(ys))
    
    # Zero gradients
    params <- model$parameters()
    for (p in params) {
      p$grad <- 0
    }
    
    # Backward pass
    backward(loss)
    
    # Adaptive learning rate
    if (epoch > 1 && loss$data > losses[epoch-1]) {
      learning_rate <- min(learning_rate * 0.5, 1.1)
    } else if (epoch > 1 && loss$data < losses[epoch-1]) {
      learning_rate <- max(learning_rate * 1.05, 0.00000001)
    }
    
    for (p in params) {
      p$data <- p$data - learning_rate * p$grad
    }
    
    losses[epoch] <- loss$data
    
    if (epoch %% 10 == 0) {
      cat(sprintf("Epoch %d: loss = %.4f, lr = %.4f\n", epoch, loss$data, learning_rate))
    }
  }
}

