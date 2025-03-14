# Financial Engineering - Assignment 2

This assignment focuses on constructing discount factor curves using the **bootstrap method**, evaluating **interest rate swap sensitivities**, pricing coupon bonds, and implementing the Garman-Kohlhagen formula for option pricing.

### Exercise 1: Bootstraping

The first task involves constructing a discount factors curve using the bootstrap method within a single-curve model. Starting with mid deposit rates up to 3 months, the initial discount factors are obtained and used to interpolate the zero rate for the first future's settlement date. This process is repeated for each future’s settlement day, extending the curve to the expiry date of the seventh future. For swap rates, an interpolation procedure derives the one-year discount factor, which is then used to iteratively compute discounts for subsequent swaps.

### Exercise 2: IRS analysis

Using the obtained discount curve, a portfolio consisting of a single 6-year plain vanilla IRS versus Euribor 3m is analyzed. The following sensitivities are calculated:

- DV01-parallel shift
- DV01Z-parallel shift
- BPV (Basis Point Value)

Additionally, the Macaulay Duration for an IB coupon bond with the same parameters as the IRS is computed, confirming the relationship between DV01Z and Macaulay Duration.

### Exercise 3: Coupon Bond Pricing

A 6-year InterBank coupon bond is priced. The bond price is evaluated by summing the discounted coupons and the discounted face value.

### Exercise 4: Garman-Kohlhagen Formula

The value of a call option is derived using the Garman-Kohlhagen formula. 
