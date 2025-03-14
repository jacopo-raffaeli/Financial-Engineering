# Financial Engineering - Assignment 1

This assignment focuses on pricing a European Call Option using various market models, analyzing numerical errors, and exploring advanced pricing techniques.

### Exercise 1: Option Pricing Methods

The first task involves pricing a European Call Option using three different approaches:

- **Black-Scholes model:** Using the `blkprice` function in Matlab to obtain a closed-form solution.
- **Cox-Ross-Rubinstein (CRR) binomial tree:** Approximating the option price by modeling the price evolution as a binomial tree.
- **Monte-Carlo (MC) simulation:** Estimating the option price through randomized price paths and averaging the payoffs.

### Exercise 2: Error Analysis

Numerical errors arise in the CRR and MC methods due to discretization and randomness. This section involves:

- **Error scaling in CRR:** Studying how the price converges as the number of tree intervals increases.
- **Error scaling in MC:** Analyzing the impact of the number of simulations on price accuracy and the role of the standard error.

### Exercise 3: Barrier Option Pricing

The third part extends the analysis to a **Barrier Call Option**, priced using:

- **Tree-based methods:** Adapting the CRR model to account for barrier conditions.
- **Monte-Carlo simulations:** Simulating paths and discarding those that breach the barrier.

Results are compared with a **closed-form solution**, assessing the accuracy and efficiency of each method.

### Exercise 4: Sensitivity Analysis

This section explores the option’s sensitivity to volatility through **Vega analysis**:

- **Vega computation:** Calculating the change in option price with respect to volatility.
- **Price sensitivity visualization:** Plotting Vega against the underlying price to observe how sensitivity evolves.

### Exercise 5: Advanced Topics

The final section covers more sophisticated techniques and pricing scenarios:

- **Variance reduction in MC:** Implementing **antithetic variables** to reduce Monte-Carlo error.
- **Bermudan option pricing:** Extending the CRR tree to handle multiple exercise opportunities.
- **Dividend yield effects:** Pricing options under different dividend yields and comparing results.
