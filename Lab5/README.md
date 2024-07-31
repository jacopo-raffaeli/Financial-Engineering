# Financial Engineering - Assignment 5

This assignment involves determining the participation coefficient for a certificate, comparing digital option pricing methods, pricing a European call option using different methods, and calibrating a volatility surface model.

### Exercise 1: Certificate Pricing

**Objective**: Determine the participation coefficient (α) for a certificate with a payoff structure involving two stocks: ENEL and AXA.

**Approach**:
- Calculate discount factors using Bootstrap and Interpolation methods.
- Estimate forward interest rates for stock simulations.
- Perform a Monte Carlo simulation to determine the average payoff.
- Solve for α by ensuring positive discounted cash flows equal negative discounted cash flows at time t=0.

### Exercise 2: Pricing Digital Option

**Objective**: Compare the price of a digital option using the Black model and the implied volatility approach.

**Approach**:
- **Black Model**: Use the closed formula to compute the price of the digital option.
- **Implied Volatility Approach**: Adjust the price considering the volatility smile and the impact of its slope.

**Insight**: The price computed using the implied volatility approach reflects additional digital risk compared to the Black model.

### Exercise 3: Pricing European Call Option

**Objective**: Calculate the price of a European call option using FFT (Fast Fourier Transform), Quadrature, and Monte Carlo methods.

**Approach**:
- **FFT**: Apply Fast Fourier Transform to approximate the price, calibrating free parameters for accuracy.
- **Quadrature**: Use numerical integration to approximate the integral in the Lewis formula.
- **Monte Carlo**: Simulate the option price directly based on the forward dynamics.

**Observations**:
- **Complex Values**: Both FFT and Quadrature methods may produce small imaginary components due to numerical errors.
- **Price Curve Behavior**: The price curve shows a locally linear trend in extreme scenarios (OTM and ITM).

### Exercise 4: Volatility Surface Calibration

**Objective**: Calibrate a Normal Mean-Variance Mixture model for the S&P 500 implied volatility surface.

**Approach**:
- Compute option prices using the Black model and the Lewis formula.
- Optimize parameters to minimize the difference between theoretical prices and market prices using the fmincon function.

**Insight**: The calibrated model aims to provide a close fit to market data, with visual comparisons showing alignment between model and market implied volatilities.
