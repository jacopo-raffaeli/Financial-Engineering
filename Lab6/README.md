# Financial Engineering - Assignment 6

**Introduction**

This assignment involved the analysis and hedging of a structured bond issued by Bank XX on February 16, 2024. The main tasks included:

- Bootstrapping market discounts to construct swap rates.
- Calculating the upfront pricing and spot volatilities.
- Determining risk measures such as Delta-bucket sensitivities and total Vega.
- Implementing Delta and Vega hedging strategies using swaps and caps.

**Bootstrap**

To derive market discounts for February 16, 2024, we created a full set of swap rates using spline interpolation on mid rates. We then bootstrapped these rates to obtain the necessary discount factors. The resulting curve showed a descending trend, indicating market expectations of future rate normalization.

**Upfront**

Caplet spot volatilities were computed by assuming uniform flat volatilities for periods under one year. An iterative procedure was used to determine the spot volatilities for subsequent years. The upfront value of the structured bond was determined by calculating the Net Present Value of cash flows, focusing on fixed spreads and caps due to the offsetting nature of Euribor payments.

**Delta-Bucket Sensitivities**

Delta-bucket sensitivities were calculated by shifting deposits, futures, and swaps by 1 basis point and updating the upfront values accordingly. DV01 (Delta value for 1 basis point shift) was determined as the difference between the updated and original upfront values.

**Total Vega**

Total Vega was computed by incrementing the entire flat volatilities matrix by 1 basis point to generate a new spot volatility surface. The total Vega was then calculated as the difference between the new and original upfront values.

**Vega-Bucket Sensitivities**

Vega-bucket sensitivities were determined similarly to Delta-bucket sensitivities. Each volatility in the flat volatilities matrix was increased by 1 basis point, and the corresponding new upfront values were computed. The sum of the Vega-bucket sensitivities was verified against the total Vega.

**Course-Grained Buckets Delta Hedge**

Course-grained bucket sensitivities were calculated for four periods: 0-2 years, 2-5 years, 5-10 years, and 10-15 years. Using linear interpolation, weights were assigned to simplify the calculations. Delta hedging was performed based on these course-grained buckets, determining the appropriate swap notionals to hedge the portfolio's delta risk.

**Vega Hedge**

To hedge the total Vega, an ATM 5-year cap was used. The new portfolio, consisting of the structured product and the 5-year cap, was then Delta-hedged using the same methodology as before. The notionals for the cap and the swaps were adjusted to manage the Vega risk.

**Course-Grained Buckets Vega Hedge**

Vega hedging was approached using different buckets: 0-5 years and 5-15 years. A new spot volatility surface was calculated for these buckets, and Vega was hedged using the corresponding flows.

**Notes & Issues**

1. **Flat Volatility Surface Misinterpretation**: An error occurred by including volatilities at 18 months, which were to be excluded. This oversight impacted multiple parts of the code but did not significantly alter the final results.

2. **Time-Consuming Spot Volatility Bootstrap**: Bootstrapping the spot volatilities was time-intensive due to calibrating on 60 dates. A more efficient method would involve calibrating on fewer dates and then bootstrapping the remaining dates.
