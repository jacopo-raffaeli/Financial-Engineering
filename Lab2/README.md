# Financial Engineering - Assignment 2

This assignment for the Financial Engineering course focuses on constructing discount factor curves using the bootstrap method, evaluating interest rate swap (IRS) sensitivities, pricing coupon bonds, and implementing the Garman-Kohlhagen formula for option pricing. The tasks are designed to deepen the understanding of financial modeling techniques and their practical applications.

### Exercise 1

The first task involves implementing the bootstrap method to construct a discount factors curve using a single-curve model. We started by using mid deposit rates up to 3 months to obtain the initial discount factors for interpolating the zero rate for the first future's settlement date. This process was repeated for each future’s settlement day, extending the curve to the expiry date of the seventh future. For swap rates, we used an interpolation procedure to derive the one-year discount factor and iteratively computed the discounts for subsequent swaps up to the 50th swap. The resulting discount factors and zero rates were plotted to visualize the curve.

### Exercise 2

Using the discount curve obtained, we analyzed a portfolio consisting of a single 6-year plain vanilla IRS versus Euribor 3m with a fixed rate of 2.817% and a notional of 10 million euros. We calculated the following sensitivities:

- DV01-parallel shift
- DV01Z-parallel shift
- BPV (Basis Point Value)

We observed that DV01 and BPV values are quite similar for a plain vanilla par swap at trade date, as both metrics quantify interest rate sensitivity on slightly different scales. Additionally, we computed the Macaulay Duration for an IB coupon bond with the same parameters as the IRS and confirmed the theoretical relationship between DV01Z and Macaulay Duration.

### Coupon Bond Pricing

Next, we priced a 6-year InterBank coupon bond issued on 15th February 2008 with a coupon rate equal to the corresponding mid-market 7-year swap rate of 2.8173%. Assuming a 30/360 European day count for the coupons and a face value of 1, we evaluated the bond price by summing the discounted coupons and the discounted face value.

### Garman-Kohlhagen Formula

Finally, we derived the value of a call option using the Garman-Kohlhagen formula, which models the dynamics of the underlying asset using a Geometric Brownian Motion. By integrating the underlying's dynamics and computing the call option value, we provided a detailed mathematical formulation and explanation of the steps involved.

The assignment enhances the understanding of constructing discount factor curves, pricing interest rate swaps and bonds, and applying advanced option pricing models, offering valuable insights into financial engineering practices.
