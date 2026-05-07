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

xtra<-read.csv("california.dat", comment.char="@", header = FALSE)

names(xtra) <-c("Longitude", "Latitude", "HousingMedianAge",
                "TotalRooms", "TotalBedrooms", "Population", "Households",
                "MedianIncome", "MedianHouseValue")

dat <- read_lines("../data/autoMPG6.dat")
start <- which(dat == "@data") + 1
csv_text <- c("Displacement,Horse_power,Weight,Acceleration,Model_year,Mpg",
              dat[start:length(dat)])

write_lines(csv_text, "../data/autoMPG6.csv")

df <- read_csv("../data/autoMPG6.csv",
               col_types = cols(
                 Displacement = col_double(),
                 Horse_power = col_integer(),
                 Weight = col_integer(),
                 Acceleration = col_double(),
                 Model_year = col_integer(),
                 Mpg = col_double()
               ))
glimpse(df)

anyNA(df) # no NA values
missmap(df)

names(df) == make.names(names(df)) # All column names are valid

summary(df)
skim(df)

df_long <- df %>% pivot_longer(all_of(c("Displacement","Horse_power","Weight","Acceleration","Model_year","Mpg")), 
                               names_to = "name", values_to = "value")
ggplot(df_long, aes(y = value, x = name, color = name)) + geom_boxplot(outlier.alpha = 0.5) +
  facet_wrap(~ name, scales = "free", ncol = 3) + theme_minimal()

kurtosis(df)
anscombe.test(df$Horse_power)
anscombe.test(df$Acceleration)
shapiro.test(df$Horse_power)
shapiro.test(df$Acceleration)

# Univariate bar plots
ggplot(df_long, aes(x = value, fill = name)) + geom_histogram(bins = 30) + 
  facet_wrap(~ name, scales = "free") + theme_minimal()
skewness(df, na.rm = TRUE)
agostino.test(df$Horse_power)
agostino.test(df$Mpg)
agostino.test(df$Acceleration)

ggplot(df_long, aes(sample = value, color = name)) + stat_qq(alpha = 0.5) + stat_qq_line(color = "black") + 
  facet_wrap(~ name, scales = "free") + theme_minimal()

ggplot(df_long, aes(x = value, fill = name)) + geom_histogram(aes(y = after_stat(density)), bins = 30) + 
  geom_density(color = "black", linewidth = 0.5) +
  facet_wrap(~ name, scales = "free") + theme_minimal()

# Bivariate scatter plots
df_long2 <- df %>% pivot_longer(all_of(c("Displacement","Horse_power","Acceleration","Model_year","Mpg")), 
                               names_to = "name", values_to = "value")
ggplot(df_long2, aes(y = value, x = Weight, color = name)) + geom_point() + 
  facet_wrap(~ name, scales = "free") + theme_minimal()

df_long3 <- df %>% pivot_longer(all_of(c("Displacement","Horse_power","Acceleration","Weight","Mpg")), 
                               names_to = "name", values_to = "value")
ggplot(df_long3, aes(y = value, x = Model_year, color = name)) + geom_point() + 
  facet_wrap(~ name, scales = "free") + theme_minimal()
