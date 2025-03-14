# Financial Engineering - Assignment 6

### **Exercise 0: Introduction**

This assignment focuses on analyzing and hedging a **structured bond** issued by Bank XX on **Feb 16, 2024**. Key tasks:

- **Bootstrapping discounts** for swap rates.
- **Upfront pricing** and **spot volatilities** calculation.
- **Risk measures:** Delta-bucket sensitivities & total Vega.
- **Hedging strategies:** Delta & Vega hedging with swaps and caps.

### **Exercise 1: Bootstrap**

Market discounts were bootstrapped via **spline interpolation** on mid rates. The discount curve showed a **descending trend**, signaling expected **rate normalization**.

### **Exercise 2: Upfront Pricing**

**Caplet spot volatilities** were computed with flat assumptions (<1 year) and an iterative approach for longer periods. **Net Present Value (NPV)** of cash flows was calculated, considering **fixed spreads** and **caps**.

### **Exercise 3: Delta-Bucket Sensitivities**

Sensitivities were determined by shifting **deposits, futures, swaps** by **1 bp**, recalculating upfront values, and computing **DV01** as the difference.

### **Exercise 4: Total Vega**

**Vega** was computed by increasing the entire volatility matrix by **1 bp** and calculating the upfront value change.

### **Exercise 5: Vega-Bucket Sensitivities**

For each matrix element, volatilities were shifted by **1 bp**, and new upfront values were computed. **Total Vega** was verified as the sum of bucket sensitivities.

### **Exercise 6: Coarse-Grained Buckets Delta Hedge**

Buckets: **0-2y, 2-5y, 5-10y, 10-15y**. Using **linear interpolation**, swap notionals were determined to **hedge delta risk**.

### **Exercise 7: Vega Hedge**

A **5y ATM cap** was added to hedge **Vega risk**, followed by **Delta hedging**. Notionals were adjusted to balance the portfolio.

### **Exercise 8: Coarse-Grained Buckets Vega Hedge**

Buckets: **0-5y, 5-15y**. A new **volatility surface** was calculated, and flows were adjusted to hedge **Vega**.

### **Notes & Issues**

1. **Volatility Surface Error:** Including **18-month volatilities** mistakenly affected results, but with minimal impact.
2. **Slow Spot Volatility Bootstrap:** **60-date calibration** slowed bootstrapping; a hybrid approach could improve efficiency.

