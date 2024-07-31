# Financial Engineering - Assignment 1

This assignment for the Financial Engineering course at Politecnico Milano focuses on pricing a European Call Option using different market parameters. Various methods are utilized to determine the option's price and analyze the behavior and accuracy of these methods.

The assignment includes:

1. **Option Pricing Methods**:
   - Using the `blkprice` function in Matlab.
   - Cox-Ross-Rubinstein (CRR) binomial tree approach.
   - Monte-Carlo (MC) simulation.

2. **Error Analysis**:
   - Numerical errors associated with CRR and MC methods.
   - Examination of how these errors scale with the number of intervals or simulations.

3. **Barrier Option Pricing**:
   - Pricing a European Call Option with a barrier using both tree and MC techniques.
   - Comparison with a closed-form solution if available.

4. **Sensitivity Analysis**:
   - Analyzing the Vega of the barrier option across a range of underlying prices to study its sensitivity to volatility.

5. **Optional Advanced Topics**:
   - Impact of using antithetic variables to reduce MC error.
   - Pricing Bermudan options with multiple exercise opportunities.
   - Comparing prices with varying dividend yields.
