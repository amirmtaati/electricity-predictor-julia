# Electricity Consumption Predictor

A Julia-based machine learning system for predicting hourly electricity consumption using time series analysis.

## Overview

This project predicts electricity consumption patterns using historical data from PJM Interconnection. It uses linear regression with engineered time-based features and lag variables.

## Features

- Time series forecasting with lag features
- Cyclical time encoding (hour, day, month)
- Model evaluation with multiple metrics
- Data visualization and plotting

## Quick Start

### Prerequisites
- Julia 1.8+
- CSV data file with `Datetime` and `PJME_MW` columns

### Installation
```bash
git clone <your-repo-url>
cd electricity-predictor-julia
julia --project=. -e 'using Pkg; Pkg.instantiate()'
```

### Usage
```bash
julia src/Main.jl data/PJME_hourly.csv
```

## Project Structure
```
src/
├── Main.jl           # Main application entry point
├── data_loading.jl   # CSV data loading utilities
├── features.jl       # Feature engineering functions
├── modeling.jl       # Linear regression model training
├── evaluation.jl     # Model evaluation metrics
└── plotting.jl       # Visualization functions
```

## Model Features

The system creates the following features for prediction:
- **Time features**: hour, day of week, month, weekend indicator
- **Lag features**: previous hour consumption, 24-hour lag
- **Target**: next hour consumption

## Evaluation Metrics

- **MSE**: Mean Squared Error
- **RMSE**: Root Mean Squared Error  
- **MAE**: Mean Absolute Error
- **R²**: Coefficient of determination

## Data Format

Input CSV should contain:
- `Datetime`: Format YYYY-MM-DD HH:MM:SS
- `PJME_MW`: Electricity consumption in megawatts
