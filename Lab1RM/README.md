# Financial Engineering - LabRM1

## Overview

This lab explores credit risk analysis with a focus on hazard rates, Z-spreads, and rating transition matrices for different issuer categories.

## 1. Hazard Rate Curves

### Objective
The goal was to derive hazard rate curves for investment grade (IG) and high yield (HY) issuers using a piecewise constant hazard rate approach.

### Method
1. **Curve Bootstrapping**: Risk-free discount factors were extracted from zero-coupon bond rates.
2. **Interpolation**: Missing data points for certain maturities were estimated using linear interpolation.
3. **Calculation**: Hazard rates were derived by pricing defaultable bonds and determining how they vary over time.

## 2. Z-Spread

### Objective
To calculate the Z-spread for both IG and HY bonds.

### Method
1. **Risk-Free Rates**: Discounts were calculated from zero-coupon bond rates.
2. **Spread Calculation**: The Z-spread was determined by evaluating the difference between bond prices and their theoretical values using risk-free rates.

## 3. Rating Transition Matrix

### Objective
To construct a rating transition matrix for IG and HY issuers.

### Method
1. **Default Probabilities**: Default probabilities were derived for both issuer types over one-year and two-year periods.
2. **Matrix Construction**: Transition probabilities between different rating categories were computed using these default probabilities and specific mathematical principles.

This lab demonstrates the application of various credit risk metrics and models, providing insights into hazard rates, Z-spreads, and rating transitions for different types of issuers.
