

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


df <- as_tibble(df)  # dependency: run importFile.R to get the 'df' object

regressions <- df %>%
  nest(data = -Area) %>% 
  mutate(
    fit = map(data, ~ dynlm(Installations[79:163] ~ 1, data = .x)),
    tidied = map(fit, tidy),
    glanced = map(fit, glance),
    augmented = map(fit, augment)
  )

regressions2 <- regressions %>% 
  unnest(tidied)
