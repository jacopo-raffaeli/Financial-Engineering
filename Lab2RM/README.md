# Financial Engineering - LabRM2

## Overview

This lab focuses on assessing the risk associated with credit portfolios using various metrics and methodologies, including present value calculations, Value at Risk (VaR) analysis, and the impact of asset correlations and concentration risk.

## 1. Present Value and VaR Analysis

### Objective
Evaluate the present value of a bond under different credit ratings and assess the risk using Value at Risk (VaR).

### Method
1. **Present Value Calculation**:
   - Zero-coupon rates for specific maturities were determined using interpolation.
   - Forward values of the bond were computed based on the rating transition matrix and forward discounts.
   - The present value was calculated by averaging these forward values weighted by the probabilities of each rating state.

2. **VaR Calculation**:
   - Barriers to default and downgrade were computed, and losses for each state were assessed.
   - Monte Carlo simulation was used to generate standardized Asset Value Returns (AVRs).
   - VaR was calculated for both default-only and default & migration scenarios.

## 2. VaR Analysis with Varying Correlations

### Objective
Analyze how different correlation values among issuers impact VaR.

### Method
1. **VaR Calculation**:
   - VaR was computed for a portfolio with 200 issuers under varying correlation values.
   - Results demonstrated that as correlation increases, VaR also increases.

## 3. Concentration Risk Analysis

### Objective
Evaluate the impact of portfolio concentration on VaR.

### Method
1. **VaR Calculation**:
   - A portfolio with 20 issuers was analyzed for concentration risk.
   - VaR was computed under varying correlation values, showing that concentration risk increases VaR.

## 4. Discussion

1. **Impact of Migration Risk**:
   - Migration risk can significantly impact VaR, especially at high confidence levels, regardless of portfolio diversification.

2. **Sensitivity to Asset Correlations**:
   - Portfolio VaR is sensitive to asset correlations. High correlations increase VaR, while low correlations provide diversification benefits.

3. **Impact of Migration Risk on VaR**:
   - The effect of migration risk on VaR varies with correlation assumptions. Positive correlations generally increase VaR, while negative correlations may reduce it.

4. **Sensitivity to Concentration Risk**:
   - A Credit Portfolio Model, even if based on a single systematic factor, remains sensitive to concentration risk due to large exposures to specific issuers.
