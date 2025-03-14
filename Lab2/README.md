# Financial Engineering - Assignment 2

This assignment focuses on constructing **discount factor curves** using the **bootstrap** method, evaluating interest rate swap sensitivities, pricing coupon bonds, and implementing the Garman-Kohlhagen formula for option pricing.

1. **Bootstrap**

The first task involves constructing a discount factors curve using the bootstrap method within a single-curve model. Starting with mid deposit rates up to 3 months, the initial discount factors are obtained and used to interpolate the zero rate for the first future's settlement date. For swap rates, an interpolation procedure derives the one-year discount factor, which is then used to iteratively compute discounts for subsequent swaps.

2. **Portfolio analysis**

Using the obtained discount curve, a portfolio consisting of a single 6-year plain vanilla IRS versus Euribor 3m is analyzed. The following sensitivities are calculated:

- DV01-parallel shift
- DV01Z-parallel shift
- BPV

3. **Bond Pricing**

4. **Call Option Pricing**
