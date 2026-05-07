# Project EDA Regression Classification

This project performs **Exploratory Data Analysis (EDA)**, **Regression**, and **Classification** on two datasets using R.

## Project Structure

```
Project_EDA_Regression_Classification/
├── src/                      # R scripts for EDA
│   ├── script_EDA.R          # EDA for autoMPG6 (alternative version)
│   ├── EDA_datasetR.R        # EDA for regression dataset (autoMPG6)
│   └── EDA_datasetC.R        # EDA for classification dataset (vowel)
├── reports/                  # Reports (R Markdown, HTML, PDF)
│   ├── regr_autompg6.Rmd     # Linear Regression & k-NN regression report
│   ├── clasific_vowel.Rmd    # k-NN, LDA, QDA classification report
│   ├── EDA_datasetR.Rmd      # EDA notebook for regression data
│   ├── EDA_datasetC.Rmd      # EDA notebook for classification data
│   ├── *.nb.html             # R Notebook HTML output
│   ├── *.pdf                 # PDF reports
│   └── plots/                # Generated plots
├── data/                     # Datasets
│   ├── autoMPG6.dat          # Auto MPG regression dataset
│   ├── autoMPG6.csv          # Auto MPG CSV version
│   ├── autoMPG6-5-*.dat      # 5-fold train/test splits for autoMPG6
│   ├── vowel.dat             # Vowel classification dataset
│   ├── vowel-10-*.dat        # 10-fold train/test splits for vowel
│   ├── regr_train_alumnos.csv
│   └── regr_test_alumnos.csv
├── Project_EDA_Regression_Classification.Rproj  # RStudio project
└── README.md
```

## Datasets

### autoMPG6 (Regression)
Fuel consumption data with 6 variables:
- **Displacement** — engine displacement
- **Horse_power** — engine power
- **Weight** — vehicle weight
- **Acceleration** — time to 60 mph
- **Model_year** — model year
- **Mpg** — miles per gallon (target)

### Vowel (Classification)
Acoustic vowel recognition data with 14 variables:
- **TT**, **SpeakerNumber**, **Sex** — categorical identifiers
- **F0–F9** — acoustic formant frequencies
- **Class** — vowel class to predict (target, 11 classes)

## Tasks

### 1. Exploratory Data Analysis (EDA)
- Summary statistics, missing value analysis, outlier detection via IQR
- Univariate plots: histograms, density curves, QQ-plots
- Bivariate plots: scatterplots, boxplots, violin plots
- Correlation matrix and heatmaps
- Normality tests (Shapiro-Wilk, skewness, kurtosis)

### 2. Regression (autoMPG6)
- **Simple Linear Regression** — evaluated each predictor individually
- **Multiple Linear Regression** — stepwise elimination, interaction terms, polynomial terms
- **k-NN Regression** — non-parametric regression using `kknn`
- **Comparison** — Wilcoxon signed-rank test and Friedman test across LM, k-NN, and M5P

### 3. Classification (Vowel)
- **k-NN Classification** — evaluated across k=1..15 on 10-fold splits
- **Linear Discriminant Analysis (LDA)**
- **Quadratic Discriminant Analysis (QDA)**
- **Comparison** — accuracy metrics and visualization

## Key Results

- **Regression**: The best linear model includes `Weight * Model_year + Weight^2 + Model_year^2` (R²adj ≈ 0.85). k-NN showed slightly higher test error than LM.
- **Classification**: k-NN (k=3) achieved the highest accuracy (~96%). LDA performed poorly (~60%) due to non-linear class boundaries. QDA improved over LDA but did not match k-NN.

## Requirements

- R (>= 4.0)
- Key R packages: `tidyverse`, `ggplot2`, `MASS`, `kknn`, `caret`, `corrplot`, `e1071`, `Amelia`, `moments`, `GGally`, `janitor`, `skimr`

## Usage

Open `Project_EDA_Regression_Classification.Rproj` in RStudio, then:

- Run `src/script_EDA.R` or `src/EDA_datasetR.R` for regression EDA
- Run `src/EDA_datasetC.R` for classification EDA
- Knit `reports/regr_autompg6.Rmd` for the regression report
- Knit `reports/clasific_vowel.Rmd` for the classification report

## Author

Andrei Kostin
