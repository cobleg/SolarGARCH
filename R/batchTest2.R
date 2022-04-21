

# Objective: test batch forecasting process
# Source: https://www.r-bloggers.com/2016/02/batch-forecasting-in-r-2/

# Supporting workflows:
#                      https://tidyr.tidyverse.org/articles/nest.html
#                      https://broom.tidymodels.org/articles/broom_and_dplyr.html

# This is a test example demonstrating a workflow of estimating multivariate linear regression models in a batch process



library(broom)
library(dplyr)
library(dynlm)
library(purrr)
library(tidyr)

data()

Orange <- as_tibble(Orange)
Orange

nested <- Orange %>% 
  nest(data = -Tree)


data(mtcars)
mtcars <- as_tibble(mtcars)  # to play nicely with list-cols

regressions <- mtcars %>%
  nest(data = -am) %>% 
  mutate(
    fit = map(data, ~ lm(wt ~ mpg + qsec + gear, data = .x)),
    tidied = map(fit, tidy),
    glanced = map(fit, glance),
    augmented = map(fit, augment)
  )

reg2 <- regressions %>% 
  unnest(tidied)
