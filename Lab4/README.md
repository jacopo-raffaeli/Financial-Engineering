# Financial Engineering - Assignment 4

This assignment focuses on computing risk measures, evaluating potential losses in derivative portfolios, and pricing a Cliquet option using different methods.

### Exercise 0: Parametric Risk Measures

A linear portfolio of stocks is analyzed. **Value at Risk (VaR)** and **Expected Shortfall (ES)** are computed using a **t-Student parametric approach**, with log-returns estimated over a 5-year window.

### Exercise 1: Non-Parametric Risk Measures

Risk measures are evaluated for multiple portfolios using **Historical Simulation (HS)**, **Weighted Historical Simulation (WHS)**, and **Principal Component Analysis (PCA)**:

- **Portfolio 1**: HS with and without bootstrap.
- **Portfolio 2**: WHS, emphasizing recent losses.
- **Portfolio 3**: PCA to reduce dimensionality and assess risk across components.

A **plausibility check** is performed to verify the order of magnitude of the VaR estimates.

### Exercise 2: Derivative Portfolio Loss Estimation

Two approaches are used to estimate potential losses over a short horizon:

- **Full Monte Carlo (MC)**: Simulating portfolio value fluctuations with **Weighted Historical Simulation**.
- **Delta-Normal**: Approximating portfolio loss with a **first-order Taylor expansion** based on option Greeks.

### Exercise 3: Cliquet Option Pricing

A **Cliquet option** is priced using **Monte Carlo simulations** and an **analytical formula**:

- **Monte Carlo (MC)**: Simulating asset paths as a **Geometric Brownian Motion (GBM)** with **antithetic variables** for variance reduction.
- **Analytical Formula**: Based on the **Black '76 model**, adjusted for counterparty risk.
