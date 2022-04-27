

# Objective: test batch forecasting process
# Source: https://www.r-bloggers.com/2016/02/batch-forecasting-in-r-2/

# Supporting workflows:
#                      https://tidyr.tidyverse.org/articles/nest.html
#                      https://broom.tidymodels.org/articles/broom_and_dplyr.html

# This is a test example demonstrating a workflow of estimating multivariate linear regression models in a batch process
# variations from batchTest2.R

library(broom)
library(dplyr)
library(dynlm)
library(purrr)
library(tidyr)
library(tseries)


df <- as_tibble(df)  %>% # dependency: run importFile.R to get the 'df' object
  mutate(DateTime = as.Date(DateTime,  "%m-%d-%Y")) # %>%
  # filter(DateTime >= as.Date("01-01-2013",  "%m-%d-%Y"))

models.1 <- df %>%
  nest(data = -Area) %>%
  mutate(
    fit = map(data, ~ dynlm(Installations ~ 1, data = .x)),
    tidied = map(fit, tidy),
    glanced = map(fit, glance),
    augmented = map(fit, augment)
  )

models.2 <- models.1 %>%
  unnest(augmented) %>%
  select(Area, .resid)
  
ARCH.data <- models.2 %>%
  mutate(e_hatsq = ts(.resid)^2) %>%
  select(Area, e_hatsq)

# given residuals, fit an ARCH model
ARCH.models <- ARCH.data %>%
  nest(data = -Area) %>%
  mutate(
    fit = map(data, ~ dynlm(e_hatsq ~ L(e_hatsq), data = .x)),
    tidied = map(fit, tidy),
    glanced = map(fit, glance),
    augmented = map(fit, augment) 
  )
    
summary <- ARCH.models %>%
  unnest(tidied) %>%
  select(Area, term, estimate) %>%
  pivot_wider(names_from = term, values_from = estimate)

