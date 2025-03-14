# Financial Engineering - Assignment 7

### **Exercise 0: Certificate Pricing**

This assignment explores **certificate pricing** with different models and maturity periods.

### **Exercise 1: Pricing Models**

- **NIG Model**
   - Used **Normal Inverse Gaussian (NIG)** model with **Monte Carlo (MC)** simulations.
   - **Calibrated parameters** from previous assignments.
   - Computed **upfront value**, compared with other models.

- **VG Model**
   - Applied **Variance Gamma (VG)** model, similar to NIG.
   - **MC simulations** for price estimation.
   - Compared results with NIG, showing **minimal deviation**.

- **Black Model**
   - Implemented **Black model** for pricing.
   - Simulated **forward values**, computed upfront price.
   - **Less accurate** than NIG due to handling **digital risk**.

- **Three-Year Maturity**
   - Extended analysis to a **3-year structured bond**.
   - Used both **NIG and VG** models.
   - Found **consistent upfront values** with **minimal error**.

### **Exercise 2: Bermudian Swaption Pricing via Hull-White**

- **Tree Construction**
   - Built a **Trinomial tree** to simulate the **Ornstein-Uhlenbeck process**.
   - **Mean-reverting** process.
   - **Discount factors** calculated for pricing.

- **Pricing and Verification**
   - Estimated **swaption price** via **expected discounted payoffs**.
   - **Early exercise** opportunities considered.
   - **Compared with Jamshidian Approach** — found **discrepancies**.

- **Results**
   - **Final price** obtained with **reasonable accuracy**.
   - **Inconsistencies** with alternative methods need **further investigation**.

