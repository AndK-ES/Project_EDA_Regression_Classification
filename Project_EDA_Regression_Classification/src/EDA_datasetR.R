## ------------------------------------------------------------------------------------------------------------------
library(readr)
library(tidyverse)
library(janitor)
library(skimr)
library(e1071)
library(GGally)
library(vcd)
library(corrplot)
library(dplyr)
library(Amelia)
library(moments)


## ------------------------------------------------------------------------------------------------------------------
df <- read.csv("../data/autoMPG6.dat", comment.char="@", header = FALSE)

names(df) <- c("Displacement", "Horse_power", "Weight",
                 "Acceleration", "Model_year", "Mpg")
head(df)


## ------------------------------------------------------------------------------------------------------------------
glimpse(df) # dataset summary


## ------------------------------------------------------------------------------------------------------------------
anyNA(df) # check for missing values
missmap(df) # graphical check for missing values


## ------------------------------------------------------------------------------------------------------------------
# Outlier analysis
summary(df)

vars <- c("Displacement", "Horse_power", "Weight", "Acceleration", "Model_year", "Mpg")

calc_iqr <- function(x) {
  Q1 <- quantile(x, .25)
  Q3 <- quantile(x, .75)
  IQR <- Q3 - Q1
  outlier_inf <- Q1 - 1.5 * IQR
  outlier_sup <- Q3 + 1.5 * IQR
  length(which(x < outlier_inf | x > outlier_sup))
}

outlier_list <- lapply(df[,vars], calc_iqr)
outlier_list 


## ------------------------------------------------------------------------------------------------------------------
# Boxplot visualization to show outliers

df %>% ggplot(aes(x = "", y = Horse_power)) + geom_boxplot(outlier.color = "red", width = 0.3) + 
  labs(title = "Boxplot de Horse Power", y = "Horse power") + theme_minimal()

df %>% ggplot(aes(x = "", y = Acceleration)) + geom_boxplot(outlier.color = "red", width = 0.3) + 
  labs(title = "Boxplot de Acceleration", y = "Time to 60mph") + theme_minimal()


## ------------------------------------------------------------------------------------------------------------------
# Data summary
# Calculate mean, median, sd, min, max

medidas <- df %>% summarise(across(everything(), list(media = mean, 
                                                          desviación = sd,
                                                          mínimo = min,
                                                          máximo = max)))

medidas %>% pivot_longer(cols = everything(), names_to  = c("variable", "estadistico"),
                                          names_pattern = "(.*)_(.*)",
                                          values_to = "valor") %>% 
  pivot_wider(names_from  = "estadistico", values_from = "valor")



## ------------------------------------------------------------------------------------------------------------------
# Univariate plots (histograms)

for(i in vars) {
  print(df %>% ggplot(aes_string(x = i)) + 
        geom_histogram(aes(y = (..density..)), bins = 30, fill = "steelblue", color = "black") + 
        geom_density(alpha = .2, fill = "red") + labs(title = paste("Histograma de ", i), y = "Frecuencia"))
}


## ------------------------------------------------------------------------------------------------------------------
# Calculate correlation matrix for numeric variables
M <- cor(df, use = "complete.obs", method = "pearson") 
round(M, 3)

# Visualización de heat map con la función corrplot
corrplot(M, method = "circle", type = "upper", tl.col = "black", tl.srt = 45) 


## ------------------------------------------------------------------------------------------------------------------
# Bivariate plots

df %>% ggplot(aes(x = Displacement, y = Mpg)) +
  geom_point(alpha = .6) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Displacement vs Mpg")

df %>% ggplot(aes(x = Horse_power, y = Mpg)) +
  geom_point(alpha = .6) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Horse power vs Mpg")

df %>% ggplot(aes(x = Weight, y = Mpg)) +
  geom_point(alpha = .6) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Weight vs Mpg")

df %>% ggplot(aes(x = Model_year, y = Mpg)) +
  geom_point(alpha = .6) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Model year vs Mpg")


## ------------------------------------------------------------------------------------------------------------------
# Remove the variable
df_reduced <- subset(df, select = -Displacement)
str(df_reduced)


## ------------------------------------------------------------------------------------------------------------------
# QQ-plots to check normality

new_vars = c("Horse_power", "Weight", "Acceleration", "Model_year", "Mpg")

for(i in new_vars) {
  print(df_reduced %>% ggplot(aes_string(sample = i)) +
          stat_qq() + stat_qq_line() +
          labs(title = paste("QQ-plot de", i)))
}



