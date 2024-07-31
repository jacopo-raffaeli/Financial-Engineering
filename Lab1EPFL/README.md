# Financial Engineering - LabEPFL1

## Overview

This assignment investigates different methods for improving forecasts of day-ahead electricity prices using regularization techniques. The methods analyzed include LASSO (L1 regularization), Ridge (L2 regularization), and Elastic Net (a mix of L1 and L2 regularization). The aim is to determine how these methods impact the accuracy of forecasts.

## 1. LASSO (L1 Regularization)

### Objective
To understand how LASSO regularization affects model performance when different levels of regularization are applied.

### Approach
- Various settings of the regularization parameter were tested.
- The focus was on evaluating how well the model predicts the electricity prices and how the weights of the features are distributed.

### Observations
- Using higher levels of regularization might lead to less accurate predictions by making the model too simple.
- Finding the right level of regularization is key to balancing model accuracy and complexity.

## 2. Ridge (L2 Regularization)

### Objective
To evaluate the performance of Ridge regularization under different levels of regularization.

### Approach
- Different settings of the regularization parameter were analyzed to see how they affect the model’s performance.
- Ridge regularization aims to prevent the model from overfitting and to stabilize predictions.

### Observations
- Ridge regression showed stable performance across different levels of regularization, indicating its robustness.

## 3. Elastic Net (Combination of L1 and L2 Regularization)

### Objective
To assess how combining L1 and L2 regularization affects model performance with various settings for both types of regularization.

### Approach
- Multiple combinations of the regularization parameters were tested.
- The goal was to find the best balance between the benefits of L1 and L2 regularization.

### Observations
- Combining both types of regularization can balance sparsity and stability, leading to effective model performance.

## 4. Comments

### LASSO
- Effective regularization involves choosing a parameter setting that provides a good balance between prediction accuracy and model simplicity.

### Ridge
- Ridge regression was less affected by changes in the regularization parameter, showing consistent performance.

### Elastic Net
- The combination of L1 and L2 regularization can optimize model performance by balancing both types of regularization.

## 5. Extra Points

### Evaluation Metrics
- Several metrics were used to evaluate the accuracy of the predictions: Mean Absolute Error, Root Mean Squared Error, and Symmetric Mean Absolute Percentage Error.

### Approach
- These metrics were calculated for predictions made at each hour and for the overall time period.
- The best results were obtained with specific settings of the regularization parameters, showing improved model performance.
