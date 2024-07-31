# Financial Engineering - Lab2EPFL

## Overview

The focus of this assignment was on optimizing hyperparameters for a gradient descent algorithm used in deep neural networks (DNN). The goal was to find the best settings for these hyperparameters to minimize the loss function, which helps improve model performance.

## 1. Random Hyperparameter Search

### Objective
To determine the optimal hyperparameters for gradient descent by performing a random search.

### Approach
- We conducted experiments with different numbers of trials to find the best hyperparameters.
- Two different trial counts were tested: 10 trials and 50 trials.

### Observations
- **Performance**: With more trials, the model's loss value (a measure of prediction error) decreased, suggesting better hyperparameter settings were found.
- **Computational Time**: Increasing the number of trials significantly increased the computation time. Specifically, the time to run the experiments grew approximately fivefold when the number of trials increased from 10 to 50.
- **Model Accuracy**: The accuracy of the model's predictions, specifically in approximating the actual price, was not necessarily improved with more trials. The results from 50 trials did not show a clear benefit in terms of approximation accuracy compared to 10 trials.

### Additional Considerations
- **Experiment Management**: It was important to delete previous experiments from the dashboard to avoid clutter and potential inaccuracies in the results.
- **Variability**: Each run of the code with a random test set yielded slightly different results, indicating some variability in the outcomes.

## Conclusion

Running more trials in the random hyperparameter search generally helps in finding better hyperparameter settings, but this comes at the cost of increased computation time. Additionally, more trials do not always guarantee improved model accuracy. It's crucial to balance the number of trials with computational resources and consider other factors that might influence model performance.
