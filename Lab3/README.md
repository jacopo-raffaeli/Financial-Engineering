# Financial Engineering - Assignment 3

This assignment focuses on analyzing **credit default swap (CDS) spreads**, and pricing a **First to Default (FTD) contract** using a Gaussian copula model.

### Exercise 1: Discount Factor Computation

Using discount factors obtained in **Lab 2**, this exercise involves:

- **1-year discount factor interpolation:** Estimating the discount at 1 year via interpolation.
- **Asset swap (ASW) discount curve construction:** Building a discount vector for maturities of 1, 2, and 3 years.
- **Coupon bond pricing:** Computing the price of a risk-free coupon bond.
- **ASW spread calculation:** Determining the asset swap spread using the given formula, yielding a result of **-0.3510**.

### Exercise 2: CDS Spread and Survival Probability Analysis

This exercise involves building a complete set of **CDS spreads** and computing survival probabilities:

- **Spline interpolation of CDS spreads:** Generating spreads for various dates.
- **Bootstrap of survival probabilities:** Deriving survival probabilities and **piecewise constant hazard rates**.
- **Accrual and Jarrow-Turnbull adjustments:** Computing hazard rates with and without accrual terms, and comparing the results with the JT approximation.
- **Result comparison**

### Exercise 3: FTD Contract Pricing

The final exercise focuses on pricing a **FTD contract** using a **Gaussian copula model**:

- **Survival probability computation:** Using the approximation neglecting accrual terms.
- **Gaussian copula simulation:** Simulating Gaussian random variables and generating **correlated default times** through reverse interpolation.
- **Monte-Carlo pricing:** Estimating the fair price of the FTD contract with obligors **UCG** and **ISP**, resulting in an **FTD fee of 85.45 bp** with a **5.32% standard deviation**.
- **Correlation impact analysis:** Plotting the FTD fee against different values of the correlation coefficient.

