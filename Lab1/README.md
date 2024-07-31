# Financial Engineering - Assignment 1

This assignment for the Financial Engineering course at Politecnico Milano focuses on pricing a European Call Option with specific market parameters.
The task involves using various methods to determine the option's price and analyzing the results to understand the behavior and accuracy of these methods.

The assignment begins with pricing the option using the `blkprice` function in Matlab, a Cox-Ross-Rubinstein (CRR) binomial tree approach, and a Monte-Carlo (MC) simulation. 
It then examines the numerical errors associated with the CRR and MC methods, demonstrating how these errors scale with the number of intervals or simulations.
Additionally, the assignment includes pricing a European Call Option with a barrier using both tree and MC techniques, and comparing these results with a closed-form solution if available. 

The Vega of the barrier option is analyzed across a range of underlying prices to study its sensitivity to volatility.

Optional tasks explore advanced topics such as the impact of using antithetic variables to reduce MC error, pricing Bermudan options with multiple exercise opportunities, and comparing prices with varying dividend yields.
The provided Matlab function signatures must be used as specified, ensuring consistency and clarity in the implementation. 

The analysis and results will offer insights into option pricing techniques and their practical applications in financial engineering.
