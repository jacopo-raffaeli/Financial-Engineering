# Financial Engineering - Assignment 3

This assignment focuses on computing discount factors, analyzing credit default swap (CDS) spreads, and pricing a First to Default (FTD) contract using a Gaussian copula model. The tasks enhance the understanding of advanced financial modeling techniques.

### Exercise 1

Using discounts obtained from the bootstrap method on 15th February 2008 at 10:45 C.E.T., the discount at 1 year is computed through interpolation. The vector of asset swap (ASW) discounts for 1y, 2y, and 3y is constructed. With this data, the price of a risk-free coupon bond is computed, and the asset swap spread is determined using the given formula. The result obtained is -0.3510.

### Exercise 2

A complete set of CDS spreads and dates is created using spline interpolation, resulting in CDS spreads for various dates from 2009 to 2015. Using these CDS spreads, a bootstrap method computes survival probabilities and piecewise constant hazard rates (λ) for each time step, both neglecting and considering the accrual term, as well as using the Jarrow-Turnbull (JT) approximation. The survival probabilities and intensities from the approximate and exact methods show negligible differences. Similarly, the comparison between the exact method and the JT approximation indicates minor differences.

### Exercise 3

A complete set of CDS spreads and dates is created using spline interpolation for the obligor UCG, resulting in CDS spreads for various dates from 2009 to 2015. Survival probabilities for UCG are computed using the approximation that neglects the accrual term. The price of a First To Default (FTD) contract with UCG and ISP as observed obligors is calculated using the Li model and a Gaussian copula. This involves simulating Gaussian random variables, generating correlated Gaussian variables, and computing default times through reverse interpolation of survival probabilities.

The mean CDS spread obtained through Monte Carlo (MC) simulation defines the fair price of the FTD contract, resulting in an FTD fee of 85.45 basis points (bp) with a standard deviation of 5.32%. The FTD price is plotted against different values of the correlation coefficient (rho), showing that the FTD fee increases with the absolute value of rho, indicating that higher correlation leads to higher prices due to increased probability of simultaneous defaults.
