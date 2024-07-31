# Financial Engineering - Assignment 7

## Certificate Pricing

This assignment explores the pricing of certificates using different models and methods. The primary focus is on evaluating certificates under various scenarios, including maturity periods and pricing models.

### Models and Methods

1. **NIG Model**:
   - Utilized the Normal Inverse Gaussian (NIG) model with Monte Carlo simulations to compute the probability and price of the certificate.
   - Parameters were set based on calibration from prior assignments, and the resulting upfront value was compared with other models.

2. **VG Model**:
   - Applied the Variance Gamma (VG) model, which is similar to NIG but with a parameter adjustment. Monte Carlo simulations were used to estimate the price.
   - Compared the results with the NIG model, showing minimal deviation in the computed upfront values.

3. **Black Model**:
   - Implemented the Black model for pricing by simulating forward values and computing the upfront price.
   - Highlighted significant differences in accuracy compared to the NIG model due to limitations in handling digital risk.

4. **Three-Year Maturity**:
   - Extended the analysis to a structured bond with a three-year expiry using both NIG and VG models.
   - Found the upfront value to be consistent across models with minimal error, demonstrating stability in the pricing approach.

## Bermudian Swaption Pricing via Hull-White

This section focuses on pricing a Bermudian yearly payer swaption using the Hull-White model with a Trinomial tree.

### Trinomial Tree Method

1. **Tree Construction**:
   - Built a Trinomial tree to simulate the Ornstein-Uhlenbeck process within the Hull-White framework.
   - Utilized the tree to model the mean-reverting process and compute discount factors for the swaption pricing.

2. **Pricing and Verification**:
   - Estimated the swaption price by calculating expected discounted payoffs and considering early exercise opportunities.
   - Verified the tree's implementation by comparing with the Jamshidian Approach, noting discrepancies that suggest potential issues in the tree or parameter choices.

### Results

- The final price of the Bermudian swaption was obtained with reasonable accuracy, though comparisons with alternative methods revealed some inconsistencies that need further investigation.

The assignment demonstrates various pricing techniques and their practical implications in financial engineering, highlighting strengths and areas for improvement in model accuracy and implementation.
