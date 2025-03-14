# Financial Engineering - Assignment 2

This assignment focuses on constructing **discount factor curves** using the **bootstrap** method, evaluating interest rate swap sensitivities, pricing coupon bonds, and implementing the Garman-Kohlhagen formula for option pricing.

### Exercise 1

The first task involves constructing a discount factors curve using the bootstrap method within a single-curve model. Starting with mid deposit rates up to 3 months, the initial discount factors are obtained and used to interpolate the zero rate for the first future's settlement date. For swap rates, an interpolation procedure derives the one-year discount factor, which is then used to iteratively compute discounts for subsequent swaps.

### Exercise 2

Using the obtained discount curve, a portfolio consisting of a single 6-year plain vanilla IRS versus Euribor 3m is analyzed. The following sensitivities are calculated:

- DV01-parallel shift
- DV01Z-parallel shift
- BPV

### Coupon Bond Pricing

A 6-year InterBank coupon bond issued on 15th February 2008 with a coupon rate equal to the corresponding mid-market 7-year swap rate of 2.8173% is priced. Assuming a 30/360 European day count for the coupons and a face value of 1, the bond price is evaluated by summing the discounted coupons and the discounted face value.

### Garman-Kohlhagen Formula

The value of a call option is derived using the Garman-Kohlhagen formula, which models the dynamics of the underlying asset using a Geometric Brownian Motion. The mathematical formulation and explanation of the steps involved in computing the call option value are provided.


