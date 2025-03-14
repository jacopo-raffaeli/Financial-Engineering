# Financial Engineering - Assignment 5

This assignment involves determining the **participation coefficient** for a **certificate**, comparing **digital option pricing** methods, pricing a **European call option** using different methods, and calibrating a **volatility surface model**.

### Exercise 1: Certificate Pricing

Determine the **participation coefficient (α)** for a **certificate** with a payoff structure involving two stocks: **ENEL** and **AXA**.

- Calculate **discount factors** using **Bootstrap** and **Interpolation** methods.
- Estimate **forward interest rates** for stock simulations.
- Perform a **Monte Carlo simulation** to determine the **average payoff**.
- Solve for **α** by ensuring positive discounted cash flows equal negative discounted cash flows at **time t=0**.

### Exercise 2: Pricing Digital Option

Compare the price of a **digital option** using the **Black model** and the **implied volatility approach**.

- **Black Model**: Use the **closed formula** to compute the price of the **digital option**.
- **Implied Volatility Approach**: Adjust the price considering the **volatility smile** and the impact of its **slope**.

### Exercise 3: Pricing European Call Option

Calculate the price of a **European call option** using **FFT (Fast Fourier Transform)**, **Quadrature**, and **Monte Carlo** methods.

- **FFT**: Apply **Fast Fourier Transform** to approximate the price, calibrating **free parameters** for accuracy.
- **Quadrature**: Use **numerical integration** to approximate the **integral** in the **Lewis formula**.
- **Monte Carlo**: Simulate the **option price** directly based on the **forward dynamics**.

### Exercise 4: Volatility Surface Calibration

Calibrate a **Normal Mean-Variance Mixture model** for the **S&P 500 implied volatility surface**.

- Compute **option prices** using the **Black model** and the **Lewis formula**.
- **Optimize parameters** to minimize the difference between **theoretical prices** and **market prices** using the **fmincon function**.
