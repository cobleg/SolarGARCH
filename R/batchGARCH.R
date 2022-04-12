

# Objective: batch estimate ARCH and GARCH models
# Author: Grant Coble-Neal

install.packages("broom")
install.packages("dynlm")

library(broom)
library(dplyr)
library(dynlm)

df$Installations <- ts(df$Installations)

fitted_means_models <- df %>% group_by(Area) %>% do(df_means = dynlm(df$Installations ~ 1)) %>%
  rowwise() %>% tidy(model)
