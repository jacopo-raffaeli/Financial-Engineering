# Financial Engineering - LabEPFL3

## 1. Implement Johnson’s SU Distributional DNN

### Objective
To implement the Johnson’s SU model for deep neural networks (DNN). This model is used for predicting data that deviates from normal distribution, particularly when dealing with skewness and heavy tails.

### Approach
- We adapted existing code to incorporate the Johnson’s SU distribution, enhancing the DNN's ability to handle non-normal data distributions.

## 2. Model Comparison

### Models Compared
- **Quantile Regression DNN (QR-DNN)**
- **Normal Distribution DNN (Normal-DNN)**
- **Johnson’s SU Distribution DNN (JSU-DNN)**

### Evaluation Criteria
We assessed each model based on the Pinball score, a metric used to measure the accuracy of predictions across different quantiles.

### Observations
- **Prediction Quality**: The QR-DNN showed poorer results in predicting data compared to the Normal-DNN and JSU-DNN. The JSU-DNN was found to be the most effective in providing accurate quantile predictions.
- **Graphical Analysis**: Graphs of predicted values showed that the JSU-DNN consistently provided better approximations of actual values than the other methods.

## 2.1 Random Hyperparameter Search

### Objective
To improve the model performance by exploring different hyperparameters randomly.

### Observations
- **Pinball Scores**: Random search did not significantly alter the Pinball scores' distribution or values compared to grid search.
- **Model Performance**: There was a slight improvement observed in the QR-DNN model with random hyperparameters.

## 2.2 Test Recalibration

### Objective
To evaluate the model performance with a single trial and an extended prediction period for the entire month of May.

### Observations
- **Results**: We analyzed predictions and Pinball scores for a one-month period, but did not find any notable improvement or significant differences from earlier tests.

## 3. Performance Evaluation with Winkler Score

### Objective
To assess the models' prediction intervals using Winkler's score, which evaluates the accuracy of probabilistic forecasts.

### Observations
- **Score Interpretation**: The Winkler score helps in understanding the reliability of prediction intervals. Models with higher scores indicate more accurate intervals, while lower scores reflect less reliable predictions.

## 4. Data Preprocessing with Arcsinh Transformation

### Objective
To preprocess the data using the arcsinh transformation to improve model performance by making the data distribution more even.

### Approach
- Applied the arcsinh transformation to the data, then retransformed the predictions back using the inverse transformation.
- **Observations**: Despite implementing standard and alternative preprocessing methods, no significant improvement was observed in model performance.
