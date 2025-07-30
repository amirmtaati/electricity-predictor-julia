# ⚡ Electricity Consumption Predictor

A machine learning system for predicting hourly electricity consumption using time series analysis and feature engineering. Built with Julia for high performance and designed with both interactive analysis and command-line usage in mind.

![Julia](https://img.shields.io/badge/Julia-9558B2?style=for-the-badge&logo=julia&logoColor=white)
![Machine Learning](https://img.shields.io/badge/ML-Time%20Series-blue?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

## 🎯 Overview

This project predicts electricity consumption patterns using historical data from PJM Interconnection, one of the largest electric grid operators in North America. The system uses advanced time series techniques including lag features, cyclical encoding, and seasonal pattern recognition.

### Key Features

- **🔮 Accurate Predictions**: Time series forecasting with multiple lag features
- **⚙️ CLI Interface**: Easy-to-use command line tools for training and prediction
- **📊 Rich Analysis**: Interactive Pluto notebook for exploratory data analysis
- **🏗️ Modular Design**: Clean, maintainable code structure
- **📈 Comprehensive Metrics**: Multiple evaluation metrics for model assessment

## 🚀 Quick Start

### Prerequisites

- Julia 1.8+ 
- Required packages (automatically installed via Project.toml)

### Installation

```bash
git clone https://github.com/yourusername/electricity-predictor-julia.git
cd electricity-predictor-julia
julia --project=. -e 'using Pkg; Pkg.instantiate()'
```

### Basic Usage

1. **Train a model:**
```bash
julia src/train.jl --data data/PJME_hourly.csv --output models/my_model.jld2
```

2. **Make predictions:**
```bash
# Single prediction
julia src/predict.jl --datetime "2024-01-15 14:00:00"

# Range prediction
julia src/predict.jl --start "2024-01-15 00:00:00" --end "2024-01-16 00:00:00" --output predictions.csv
```

3. **Interactive analysis:**
```bash
julia notebooks/analysis.jl  # Opens Pluto notebook
```

## 📊 Sample Output

```
Datetime                | Predicted MW
------------------------|-------------
2024-01-15T14:00:00     | 45,234.5
2024-01-15T15:00:00     | 47,891.2
2024-01-15T16:00:00     | 52,156.8
```

## 🛠️ CLI Reference

### Training (`train.jl`)

```bash
julia src/train.jl [OPTIONS]

Options:
  -d, --data PATH          Path to training data CSV (default: data/PJME_hourly.csv)
  -o, --output PATH        Output model file path (default: models/electricity_model.jld2)
  -r, --train-ratio FLOAT  Training data ratio 0.0-1.0 (default: 0.8)
  --validate               Run validation after training
  -h, --help               Show help message
```

### Prediction (`predict.jl`)

```bash
julia src/predict.jl [OPTIONS]

Options:
  -d, --datetime STRING    Single datetime to predict (YYYY-MM-DD HH:MM:SS)
  -s, --start STRING       Start datetime for range prediction
  -e, --end STRING         End datetime for range prediction
  -m, --model PATH         Path to trained model file (default: models/electricity_model.jld2)
  -o, --output PATH        Output CSV file path (optional)
  -f, --format FORMAT      Output format: table, csv, json (default: table)
  -h, --help               Show help message
```

## 📁 Project Structure

```
electricity-predictor-julia/
├── Project.toml                 # Package dependencies
├── README.md                    # This file
├── src/
│   ├── main.jl                 # Original analysis pipeline
│   ├── predict.jl              # CLI prediction interface
│   ├── train.jl                # CLI training interface
│   ├── ElectricityPredictor.jl # Core module
│   └── utils.jl                # Utility functions
├── models/                     # Trained models (created during training)
├── data/
│   └── PJME_hourly.csv        # Historical consumption data
├── notebooks/
│   └── analysis.jl            # Interactive Pluto notebook
├── docs/
│   └── examples.md            # Usage examples
└── test/
    └── runtests.jl            # Unit tests
```

## 🔬 Technical Details

### Model Architecture

The system uses a **Linear Regression** model with carefully engineered features:

#### Time-based Features
- **Hour of day** (0-23): Captures daily consumption patterns
- **Day of week** (1-7): Identifies weekday vs weekend patterns  
- **Month** (1-12): Captures seasonal variations
- **Weekend indicator**: Boolean flag for Saturday/Sunday
- **Business hours**: Peak consumption periods

#### Lag Features
- **Previous hour**: Immediate consumption history
- **24-hour lag**: Same hour previous day
- **168-hour lag**: Same hour previous week (optional)

#### Cyclical Encoding
Time features are encoded as sine/cosine pairs to capture cyclical nature:
```
hour_sin = sin(2π × hour / 24)
hour_cos = cos(2π × hour / 24)
```

### Performance Metrics

The model is evaluated using multiple metrics:
- **RMSE**: Root Mean Square Error (primary metric)
- **MAE**: Mean Absolute Error  
- **R²**: Coefficient of determination
- **MAPE**: Mean Absolute Percentage Error
- **Directional Accuracy**: Trend prediction accuracy

### Data Requirements

Input data should be a CSV file with columns:
- `Datetime`: Timestamp in YYYY-MM-DD HH:MM:SS format
- `PJME_MW`: Electricity consumption in megawatts

## 🎓 Educational Resources

This project demonstrates several important concepts:

### Machine Learning
- Time series forecasting
- Feature engineering for temporal data
- Cross-validation for time series
- Model evaluation and metrics

### Software Engineering  
- Command-line interface design
- Module architecture in Julia
- Error handling and validation
- Documentation and testing

### Data Science
- Exploratory data analysis
- Visualization techniques
- Statistical analysis
- Domain knowledge application

## 📈 Example Results

Training on 1 year of PJM data typically achieves:
- **RMSE**: ~2,500 MW
- **MAPE**: ~8-12%
- **R²**: ~0.85-0.90

Performance varies based on:
- Data quality and completeness
- Seasonal patterns in training period
- Model hyperparameters
- Feature selection

*Built with ❤️ and Julia for accurate electricity consumption forecasting*
