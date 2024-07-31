# Financial Engineering - Assignment 4

This assignment focuses on computing risk measures for various portfolios, evaluating potential losses of a derivative portfolio, and pricing a Cliquet option using different methods.

### Exercise 0

A linear portfolio composed of shares from Adidas, Allianz, Munich Re, and L’Oréal is analyzed. Daily Value at Risk (VaR) and Expected Shortfall (ES) are computed using a 5-year estimation and a t-Student parametric approach. The stocks' log-returns are calculated to estimate their mean and covariance. Given the equally weighted portfolio and log-returns distributed as t-Student, the analytical formulas for VaR and ES are applied. The results are:
- VaR: 563,223.32
- ES: 787,977.23

### Exercise 1

Non-parametric approaches are used to evaluate risk measures for a set of portfolios as of March 20, 2019.

**Portfolio 1**: Composed of shares from Total, AXA, Sanofi, and Volkswagen. Log-returns are calculated using a 5-year time window. The Historical Simulation (HS) technique with a 95% confidence level is applied, both with and without bootstrap. Results:
- HS (no bootstrap): VaR: 94,610.75, ES: 141,276.87
- HS (bootstrap): VaR: 95,521.53, ES: 177,225.34

**Portfolio 2**: An equally weighted portfolio with shares from Adidas, Airbus, BBVA, BMW, and Deutsche Telekom. Weighted Historical Simulation (WHS) is used, where recent losses have more influence. Results:
- WHS: VaR: 0.015936, ES: 0.021544

**Portfolio 3**: An equally weighted portfolio with shares from 18 companies (excluding Adyen). Principal Component Analysis (PCA) is applied to reduce dimensionality. Results:
- VaR and ES are computed for different numbers of principal components, showing slight variations.

**Plausibility Check**: A rule of thumb check is applied to confirm the order of magnitude of the portfolio VaR. Results:
- Portfolio 1: 89,558.42
- Portfolio 2: 0.019219
- Portfolio 3: 0.054631

### Exercise 2

**Full Monte Carlo**: Used for derivative portfolios to estimate potential losses over a brief period (10 days). The portfolio value fluctuation is examined using a 2-year Weighted Historical Simulation. Results:
- VaR: 51,407.86

**Delta-Normal**: A simplified method using a first-order approximation of the Greeks to calculate portfolio loss. Results:
- VaR: 1,437,823.16

### Exercise 3

A Cliquet option, also known as a Ratchet option, is priced. The option provides periodic payouts based on the performance of an underlying asset. Using Monte Carlo (MC) simulations, the underlying asset is modeled as a Geometric Brownian Motion (GBM). The antithetic variables technique is used to expedite the process, and the mean of simulated payoffs is used to approximate the option’s cash flows.

**Monte Carlo Results**:
- Risk-free price: 0.66, Notional 30 million: 19.8 million
- Risky price: 0.64, Notional 30 million: 19.2 million

**Analytical Formula**: Derived using assumptions from the Black '76 model, adjusting for counterparty risk:
- Risk-free exact price: 0.57, Notional 30 million: 17.1 million
- Risky exact price: 0.56, Notional 30 million: 16.8 million

The discrepancies between the MC simulations and the analytical formula suggest potential inaccuracies in the computational method or unique characteristics of the Cliquet option not fully captured by the Black '76 model. The py vollib library in Python is used to compute the call prices with the Black formula.
