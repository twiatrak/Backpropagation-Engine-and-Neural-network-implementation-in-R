
# Neural Network Backpropagation Engine

This repository contains an implementation of a backpropagation engine for neural networks in R, alongside a neural network script. It includes the following main files:

- `FinalBackpropagationEngine.R`: The core engine for implementing backpropagation in a neural network.
- `nn.R`: A script that defines the neural network structure and includes utilities for training and evaluating the network.

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
  - [Example Usage](#example-usage)
- [File Descriptions](#file-descriptions)
- [Contributing](#contributing)
- [Version française](#version-française)

## Overview
This project implements a neural network and a backpropagation engine using R. It is designed for educational purposes and to demonstrate the basic principles of training a neural network through backpropagation.

## Features
- **Backpropagation**: Implements the backpropagation algorithm for training a neural network.
- **Custom Neural Network**: Allows users to define the structure of a neural network.
- **Performance Tracking**: Can track and visualize the performance metrics during training.

## Installation
1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/NeuralNetworkBackpropagation.git
   cd NeuralNetworkBackpropagation
   ```


## Usage
To run the neural network backpropagation engine, follow these steps:

1. Load the `FinalBackpropagationEngine.R` and `nn.R` files in your R environment:
   ```r
   source("FinalBackpropagationEngine.R")
   source("nn.R")
   ```

2. Initialize your neural network by following the structure provided in `nn.R`. You can customize the number of layers, neurons, and activation functions.

3. Train the neural network using backpropagation by calling the appropriate functions in the `FinalBackpropagationEngine.R` file.

4. Analyze the performance metrics and visualize the results.

### Example Usage

Here is a basic example of how to use the backpropagation engine with a simple neural network:

```r
# Create a neural network with 2 inputs, one hidden layer of 3 neurons, and 1 output
nn <- new_mlp(2, c(3), 1)

# Example training data
x <- list(Value(1.0), Value(0.5))
y <- list(Value(1.0))  # Target output

# Single training step
loss <- train_step(nn, x, y, learning_rate = 0.1)

# Training loop
for (epoch in 1:1000) {
    loss <- train_step(nn, x, y)
    if (epoch %% 100 == 0) {
        cat(sprintf("Epoch %d: loss = %f
", epoch, loss))
    }
}
```

## File Descriptions

### `FinalBackpropagationEngine.R`
This script contains the implementation of the backpropagation algorithm for training the neural network. It includes:
- **Forward Pass**: Computes the output of the neural network.
- **Backward Pass (Backpropagation)**: Updates weights and biases based on the error using gradient descent.

### `nn.R`
This script defines the architecture of the neural network. It allows you to configure:
- **Input layer**
- **Hidden layers** (number of layers, neurons per layer, activation functions)
- **Output layer**
- **Training parameters** (learning rate, epochs, etc.)

## Contributing
If you'd like to contribute to this project, feel free to open an issue or submit a pull request. Contributions such as bug fixes, enhancements, and documentation improvements are welcome!

---

## Version française

# Moteur de Rétropropagation pour Réseau de Neurones

Ce dépôt contient une implémentation d’un moteur de rétropropagation pour les réseaux de neurones en R, avec un script pour définir la structure du réseau de neurones. Il inclut les fichiers suivants :

- `FinalBackpropagationEngine.R` : Le moteur central pour implémenter la rétropropagation dans un réseau de neurones.
- `nn.R` : Un script qui définit la structure du réseau de neurones et contient des outils pour l'entraînement et l'évaluation du réseau.

## Table des matières
- [Aperçu](#aperçu)
- [Fonctionnalités](#fonctionnalités)
- [Installation](#installation)
- [Utilisation](#utilisation)
  - [Exemple d'utilisation](#exemple-dutilisation)
- [Description des fichiers](#description-des-fichiers)
- [Contribuer](#contribuer)

## Aperçu
Ce projet implémente un réseau de neurones et un moteur de rétropropagation en R. Il est conçu à des fins éducatives et pour démontrer les principes de base de l'entraînement d'un réseau de neurones via la rétropropagation.

## Fonctionnalités
- **Rétropropagation** : Implémente l'algorithme de rétropropagation pour l'entraînement d'un réseau de neurones.
- **Réseau de neurones personnalisable** : Permet aux utilisateurs de définir la structure du réseau de neurones.
- **Suivi des performances** : Peut suivre et visualiser les métriques de performance pendant l'entraînement.



## Installation
1. Clonez ce dépôt :
   ```bash
   git clone https://github.com/yourusername/NeuralNetworkBackpropagation.git
   cd NeuralNetworkBackpropagation
   ```

## Utilisation
Pour exécuter le moteur de rétropropagation, suivez ces étapes :

1. Chargez les fichiers `FinalBackpropagationEngine.R` et `nn.R` dans votre environnement R :
   ```r
   source("FinalBackpropagationEngine.R")
   source("nn.R")
   ```

2. Initialisez votre réseau de neurones en suivant la structure définie dans `nn.R`. Vous pouvez personnaliser le nombre de couches, de neurones, et les fonctions d'activation.

3. Entraînez le réseau en utilisant la rétropropagation avec les fonctions appropriées du fichier `FinalBackpropagationEngine.R`.

4. Analysez les métriques de performance et visualisez les résultats.

### Exemple d'utilisation

Voici un exemple simple d'utilisation du moteur de rétropropagation avec un réseau de neurones basique :

```r
# Créez un réseau de neurones avec 2 entrées, une couche cachée de 3 neurones, et 1 sortie
nn <- new_mlp(2, c(3), 1)

# Exemple de données d'entraînement
x <- list(Value(1.0), Value(0.5))
y <- list(Value(1.0))  # Sortie cible

# Étape unique d'entraînement
loss <- train_step(nn, x, y, learning_rate = 0.1)

# Boucle d'entraînement
for (epoch in 1:1000) {
    loss <- train_step(nn, x, y)
    if (epoch %% 100 == 0) {
        cat(sprintf("Époque %d : perte = %f
", epoch, loss))
    }
}
```

## Description des fichiers

### `FinalBackpropagationEngine.R`
Ce script contient l'implémentation de l'algorithme de rétropropagation pour l'entraînement du réseau de neurones. Il inclut :
- **Propagation avant** : Calcule la sortie du réseau de neurones.
- **Rétropropagation** : Met à jour les poids et les biais en fonction de l'erreur à l'aide de la descente de gradient.

### `nn.R`
Ce script définit l'architecture du réseau de neurones. Il permet de configurer :
- **Couche d'entrée**
- **Couches cachées** (nombre de couches, neurones par couche, fonctions d'activation)
- **Couche de sortie**
- **Paramètres d'entraînement** (taux d'apprentissage, époques, etc.)

## Contribuer
Si vous souhaitez contribuer à ce projet, n'hésitez pas à ouvrir une issue ou à soumettre une pull request. Les contributions, comme la correction de bugs, les améliorations et l'amélioration de la documentation sont les bienvenues !


