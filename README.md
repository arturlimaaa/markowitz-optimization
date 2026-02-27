# Portfolio Optimization Project

## Overview

This repository contains the implementation and documentation for the Portfolio Optimization Project as part of Math 4235: Mathematical Optimization - C Term 2026. The project simulates real-world portfolio management using Markowitz constrained portfolio optimization. It involves selecting assets, optimizing portfolios, constructing an efficient frontier, simulating performance with rebalancing, and analyzing results against benchmarks like the S&P 500.

The goal is to provide hands-on experience in optimization techniques that could be applied in personal or professional investment scenarios post-graduation.

## Project Objectives

1. **Asset Selection and Data Collection**:
   - Select 10 stocks, ETNs, or ETFs traded on American exchanges.
   - Download 2 years of daily historical data (2024 and 2025) from an Interactive Brokers paper trading account.

2. **Portfolio Optimization**:
   - Use 2024 data to construct an efficient portfolio via Markowitz optimization.
   - Apply user-defined upper and lower bounds on portfolio weights based on investment preferences.
   - Programming language: MATLAB (recommended) or any preferred alternative (e.g., Python with libraries like NumPy, SciPy, or CVXPY).

3. **Efficient Frontier Construction**:
   - Vary the expected return parameter (μ_P) to generate the efficient frontier for the 10 assets.

4. **Portfolio Simulation**:
   - Select one efficient portfolio from the frontier.
   - Simulate its value trajectory from January 1, 2025, to December 31, 2025.
   - Rebalance monthly on the last trading day:
     - Add the latest month's data.
     - Remove the oldest month's data.
     - Update expected returns (μ) and covariance matrix (Ω).
     - Recompute weights.
     - Adjust the portfolio to match new weights.
   - Suggested tool for simulation: MS Excel for trajectory tracking.

5. **Performance Analysis**:
   - Calculate the one-year return.
   - Compare performance to the S&P 500 index over the same period.
   - Discuss satisfaction with results and potential changes for real-money scenarios.
   - Note: Grading focuses on process, not actual performance.

## Repository Structure

- **`code/`**: Contains the main optimization scripts.
  - `optimize_portfolio.m` (or `.py`): Script for Markowitz optimization and efficient frontier generation.
  - `simulate_trajectory.xlsx` (or similar): Excel file for simulating and visualizing portfolio performance.

- **`data/`**: Historical data files.
  - `historical_data_2024.csv`: Daily data for 2024.
  - `historical_data_2025.csv`: Daily data for 2025.
  - `sp500_2025.csv`: S&P 500 benchmark data for comparison.

- **`report/`**: Written documentation.
  - `project_report.pdf`: Detailed report including methodology, visualizations (e.g., efficient frontier plots, performance charts), and conclusions.

- **`video/`**: Presentation materials.
  - `project_video.mp4`: 5+ minute video explaining the process and results for a general audience (or provide a link if hosted externally, e.g., YouTube).

- **`assets/`**: Supporting files like plots or additional visualizations.

- **`README.md`**: This file.

## Setup and Requirements

### Prerequisites
- Interactive Brokers paper trading account (invitation sent on January 22, 2026).
- Programming environment:
  - MATLAB (preferred for optimization).
  - Alternative: Python 3.x with libraries: `numpy`, `pandas`, `scipy`, `matplotlib`, `cvxpy`.
- Microsoft Excel for simulation.

### Installation
1. Clone the repository:
   ```
   git clone https://github.com/yourusername/portfolio-optimization-project.git
   ```
2. Install dependencies (if using Python):
   ```
   pip install numpy pandas scipy matplotlib cvxpy
   ```
3. Download historical data from Interactive Brokers and place in the `data/` folder.

## Usage

1. **Run Optimization**:
   - Execute the optimization script with 2024 data to generate weights and the efficient frontier.
   - Example (MATLAB):
     ```
     run optimize_portfolio.m
     ```
   - Adjust bounds in the script based on preferences (e.g., no short-selling: weights ≥ 0).

2. **Generate Efficient Frontier**:
   - The script will output plots and data for varying μ_P.

3. **Simulate Trajectory**:
   - Open `simulate_trajectory.xlsx`.
   - Input optimized weights and monthly data updates.
   - Track value changes with rebalancing.

4. **Analyze Results**:
   - Compute returns and compare to S&P 500.
   - Update the report with findings.

## Conclusions and Insights

In this project, we [briefly summarize your findings, e.g., "achieved a X% return vs. Y% for S&P 500"]. Performance analysis highlights the importance of diversification and regular rebalancing. For real money, consider [e.g., incorporating transaction costs or alternative risk measures].

## Contributors
- [Your Name/Team Members]
- Course: Math 4235, Worcester Polytechnic Institute (assuming based on location).

## License
This project is for educational purposes. No license is specified; use at your own risk for personal learning.
