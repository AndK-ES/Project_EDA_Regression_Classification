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
df <- read.csv("D:/UGR/Introduction to DS/Tarea final/vowel/vowel.dat", comment.char="@", header = FALSE)

names(df) <- c("TT", "SpeakerNumber", "Sex",
               "F0","F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", 
               "Class")
head(df)


## ------------------------------------------------------------------------------------------------------------------
str(df) # la observación de las variables del conjunto de datos


## ------------------------------------------------------------------------------------------------------------------
# Cambio del tipo de las variables numéricas al factór

df$TT <- factor(df$TT)
df$SpeakerNumber <- factor(df$SpeakerNumber)
df$Sex <- factor(df$Sex)
df$Sex <- fct_collapse(df$Sex, 
             male = "0",
             female = "1")
df$Class <- factor(df$Class)

glimpse(df)


## ------------------------------------------------------------------------------------------------------------------
# comprobación de los valores perdidos

anyNA(df)
missmap(df)


## ------------------------------------------------------------------------------------------------------------------
# Análisis de todos los anomalías
summary(df)

vars_num <- c("F0","F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9")

calc_iqr <- function(x) {
  Q1 <- quantile(x, .25)
  Q3 <- quantile(x, .75)
  IQR <- Q3 - Q1
  outlier_inf <- Q1 - 1.5 * IQR
  outlier_sup <- Q3 + 1.5 * IQR
  length(which(x < outlier_inf | x > outlier_sup))
}

outlier_list <- lapply(df[,vars_num], calc_iqr)
outlier_list 


## ------------------------------------------------------------------------------------------------------------------
# Visualisación de boxplots para demostrar los ouliers

df %>% ggplot(aes(x = "", y = F2)) + geom_boxplot(outlier.color = "red", width = 0.3) + 
  labs(title = "Boxplot del formante F2") + theme_minimal()

df %>% ggplot(aes(x = "", y = F4)) + geom_boxplot(outlier.color = "red", width = 0.3) + 
  labs(title = "Boxplot del formante F4") + theme_minimal()

df %>% ggplot(aes(x = "", y = F5)) + geom_boxplot(outlier.color = "red", width = 0.3) + 
  labs(title = "Boxplot del formante F5") + theme_minimal()

df %>% ggplot(aes(x = "", y = F6)) + geom_boxplot(outlier.color = "red", width = 0.3) + 
  labs(title = "Boxplot del formante F6") + theme_minimal()

df %>% ggplot(aes(x = "", y = F8)) + geom_boxplot(outlier.color = "red", width = 0.3) + 
  labs(title = "Boxplot del formante F8") + theme_minimal()


## ------------------------------------------------------------------------------------------------------------------
# Resumen de los datos
# Cálculo de media, mediana, desviación, mínimo, máximo

df_num <- df %>% select(F0:F9)
medidas <- df_num %>% summarise(across(everything(), list(media = mean, 
                                                          desviación = sd,
                                                          mínimo = min,
                                                          máximo = max)))

medidas %>% pivot_longer(cols = everything(), names_to  = c("variable", "estadistico"),
                                          names_sep = "_",
                                          values_to = "valor") %>% 
  pivot_wider(names_from  = "estadistico", values_from = "valor")






## ------------------------------------------------------------------------------------------------------------------
# Gráficos univariables (histogramas)

for(i in vars_num) {
  print(df %>% ggplot(aes_string(x = i)) + 
        geom_histogram(aes(y = (..density..)), bins = 30, fill = "steelblue", color = "black") + 
        geom_density(alpha = .2, fill = "red") + labs(title = paste("Histograma de ", i), y = "Frecuencia"))
}


## ------------------------------------------------------------------------------------------------------------------
# Gráficos univariables (diagramas de baras)

df %>% ggplot(aes(x = TT, fill = TT)) + geom_bar(width = 0.3) + 
  labs(title = "Frecuencias de TT", x = "TT", y = "Frecuencia")

df %>% ggplot(aes(x = Sex, fill = Sex)) + geom_bar(width = 0.3) + 
  labs(title = "Frecuencias de Sex", x = "Sex", y = "Frecuencia")

df %>% ggplot(aes(x = Class)) + geom_bar(fill = "steelblue") + 
  labs(title = "Frecuencias de Class", x = "Class", y = "Frecuencia")


## ------------------------------------------------------------------------------------------------------------------
# Gráficos bivariables
# Representación de boxplots de todos los formantes por clase de vocal

for(i in vars_num){
  print(
    ggplot(df, aes(x = Class, y = .data[[i]], fill = Class)) + geom_boxplot(alpha = .4) + 
      labs(title = paste(i, "por clase de vocal"), x = "Class", y = i) +  theme(legend.position = "none")
  )
}


## ------------------------------------------------------------------------------------------------------------------
# Scatterplot F1 vs F2 por clase de vocal

df %>% ggplot(aes(x = F2, y = F1, color = Class)) +
  geom_point(alpha = .6) + labs(title = "Dispersión F2 vs F1 por clase de vocal")


## ------------------------------------------------------------------------------------------------------------------
# Los violin plots para ver la influencia de sexo a formantes

df %>% ggplot(aes(x = Sex, y = F1, fill = Sex)) +
  geom_violin(trim = FALSE, alpha = .7) +
  geom_jitter(height = 0, width = .1) +
  labs(title = "Distribución del formante F1 por sexo", x = "Sexo", y = "F1") +
  theme(legend.position = "none")

df %>% ggplot(aes(x = Sex, y = F2, fill = Sex)) +
  geom_violin(trim = FALSE, alpha = .7) +
  geom_jitter(height = 0, width = .1) +
  labs(title = "Distribución del formante F2 por sexo", x = "Sexo", y = "F2") +
  theme(legend.position = "none")



## ------------------------------------------------------------------------------------------------------------------
# Calculación de la matriz de correlación de las variables numéricas
M <- cor(df_num, use = "complete.obs", method = "pearson") 
round(M, 3)

# Visualización de heat map con la función corrplot
corrplot(M, method = "circle", type = "upper", tl.col = "black", tl.srt = 45) 


## ------------------------------------------------------------------------------------------------------------------
# Representación de QQ-plots para ver la normalidad de nuevo
for(i in vars_num) {
  print(df %>% ggplot(aes_string(sample = i)) +
          stat_qq() + stat_qq_line() +
          labs(title = paste("QQ-plot de", i)))
}

# Shapiro-Wilk test
res_shapiro <- sapply(df_num, function(x) {
  muestra <- sample(x, size = min(500, length(x)))
  shapiro.test(muestra)$p.value
})

data.frame(variable = names(res_shapiro), p_value  = as.numeric(res_shapiro))



