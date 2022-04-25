

# Objective: test batch forecasting process
# Source: https://www.r-bloggers.com/2016/02/batch-forecasting-in-r-2/

# Supporting workflows:
#                      https://tidyr.tidyverse.org/articles/nest.html
#                      https://broom.tidymodels.org/articles/broom_and_dplyr.html

# This is a test example demonstrating a workflow of estimating multivariate linear regression models in a batch process
# variations from batchTest2.R:
#   1. swapped lm for dynlm
#   2. swapped mtcars for df
#   3. swapped dependent variable wt for Installations[79:163]

library(broom)
library(dplyr)
library(dynlm)
library(purrr)
library(tidyr)


df <- as_tibble(df)  %>% # dependency: run importFile.R to get the 'df' object
  mutate(DateTime = as.Date(DateTime,  "%m-%d-%Y")) %>%
  filter(DateTime >= as.Date("01-01-2013",  "%m-%d-%Y"))

regressions <- df %>%
  nest(data = -Area) %>% 
  mutate(
    fit = map(data, ~ dynlm(Installations ~ 1, data = .x)),
    # residuals = map_dbl(.fitted)
    tidied = map(fit, tidy),
    glanced = map(fit, glance),
    augmented = map(fit, augment) 
  ) 

residuals <- regressions %>%
  unnest(augmented) %>%
  select(!Installations) %>%
  unnest(data)
#  select(Area, data$DateTime, .resid)

# given residuals, fit an ARCH model
ehatsq <- ts(resid(df.result)^2)
LGA.ARCH <- dynlm(ehatsq~L(ehatsq))
summary(LGA.ARCH)
LGA.ARCH$coefficients[1]
