
import pandas as pd
import numpy as np
import scipy as sc
import keras as k
import tensorflow as tf
import matplotlib.pyplot as plt
import statsmodels.api as sm
from scipy import stats
from scipy.optimize import minimize
from FE_Library import yearfrac

# Load Time Series
quotes = pd.read_csv("DatasetPythonAss3.csv")
quotes["Date"] = pd.to_datetime(quotes["Date"], format="%d/%m/%Y")
quotes = quotes.set_index("Date")
AAPL = quotes["AAPL"]
SPX = quotes["SPX"]

# Plot Time Series

plt.plot(AAPL, label='AAPL')
plt.title('AAPL Time-Series')
plt.xlabel('Date')
plt.ylabel('Price')
plt.legend()
plt.savefig('AAPL.png')
plt.show()

plt.plot(SPX, label='SPX')
plt.title('SPX Time-Series')
plt.xlabel('Date')
plt.ylabel('Price')
plt.legend()
plt.savefig('SPX.png')
plt.show()

# Compute Log_returns and plot them
log_ret_AAPL = np.log(AAPL / AAPL.shift(1)).dropna()
log_ret_SPX = np.log(SPX / SPX.shift(1)).dropna()

plt.figure(figsize=(10, 5))
plt.plot(log_ret_AAPL, label='AAPL Log-Returns')
plt.plot(log_ret_SPX, label='SPX Log-Returns')
plt.title('AAPL and SPX Log-Returns')
plt.xlabel('Date')
plt.ylabel('Log-Returns')
plt.legend()
plt.savefig('LOG.png')
plt.show()

# Regressions
X = sm.add_constant(log_ret_SPX) # Add a constant term to the independent variable
model = sm.OLS(log_ret_AAPL, X).fit() # Fit the linear regression model
slope = model.params['SPX'] # Get the slope of the regression line
print("Slope of regression AAPL on SPX:", slope)

# YearFrac
year_frac = yearfrac(quotes.index[0], quotes.index[-1], basis=3)
print("Year Fraction between first and last date in AAPL dataset:", year_frac)

# Interpolate
x = np.array([0, 1, 2, 3, 4])
f = np.array([1, 2, 3.5, 4, 2])
f_interpolate = np.interp(2.7, x, f)
print(f"The linearly interpolated value at x = {2.7} is: {f_interpolate:.2f}")

#Simulate

num_simulations = [10, 50, 100, 1000, 5000, 10000, 100000]  # Number of simulations to test
variances = []  # Initialize an empty list to store variances

for num_sim in num_simulations:

    simulated_data = np.random.normal(size=num_sim)  # Simulate standard normal random variable

    variance = np.var(simulated_data)  # Compute variance of simulated data
    variances.append(variance)  # Append the computed variance to the list

    print(f"Number of simulations: {num_sim}")
    print(f"Variance of simulated data: {variance}")

    # Check convergence to unit variance with tolerance 0.1
    if np.isclose(variance, 1, atol=0.1):
        print("Variance converges to one within tolerance.")
    else:
        print("Variance does not converge to one within tolerance.")

    # Compute quantile 0.9
    quantile_90 = np.percentile(simulated_data, 90)

    # Compute CDF at quantile 0.9
    cdf_90 = stats.norm.cdf(quantile_90)
    print("cdf_90", cdf_90)

    # Check if the computed CDF matches the expected value
    expected_cdf_90 = 0.9
    tolerance = 0.1

    if abs(cdf_90 - expected_cdf_90) < tolerance:
        print("Gaussian CDF at quantile 0.9 matches the expected value within tolerance.")
    else:
        print("Gaussian CDF at quantile 0.9 does not match the expected value within tolerance.")

    print()
# Plot
plt.figure(figsize=(10, 6))
plt.plot(num_simulations, variances, marker='o', linestyle='-')
plt.axhline(y=1, color='r', linestyle='--', label='Expected Variance (1)')
plt.xscale('log')
plt.xlabel('Number of Simulations')
plt.ylabel('Variance')
plt.title('Convergence of Variance to 1')
plt.legend()
plt.savefig('Variance')
plt.grid(True)
plt.show()

# Minimization
def func_to_minimize(xy):
    x, y = xy
    return (x - 3) ** 2 + (y - 7) ** 2

initial_guess = [0, 0]
minimum = minimize(func_to_minimize, initial_guess)
print("Minimum of (x-3)^2+(y-7)^2 (numerical):", minimum.x)
print("Value of the function in the minimum:", func_to_minimize(minimum.x))