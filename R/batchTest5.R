

# Objective: test batch forecasting process
# Source: https://www.r-bloggers.com/2016/02/batch-forecasting-in-r-2/

# Supporting workflows:
#                      https://tidyr.tidyverse.org/articles/nest.html
#                      https://broom.tidymodels.org/articles/broom_and_dplyr.html

# This is a test example demonstrating a workflow of estimating multivariate linear regression models in a batch process
# variations from batchTest4.R:
#    1. trying the garch in the tseries library

library(broom)
library(dplyr)
library(purrr)
library(tidyr)
library(tseries)
library(zoo)


df.1 <- df %>%
  dplyr::group_by(Area) %>%
  dplyr::mutate(
    Installations = log(Installations)
    )  %>%
  dplyr::mutate(
     Installations = ifelse(is.infinite(Installations), 0, Installations)  
    ) %>%
  dplyr::mutate(
    Installations = tidyr::replace_na(Installations, 0)
    ) %>%
   filter(DateTime >= as.Date("01-01-2013",  "%m-%d-%Y"), !(Area == "Menzies (S)"))

models.1 <- df.1 %>%
  tidyr::nest(data = -Area) %>%
  dplyr::mutate(
    fit = purrr::map(data, ~ tseries::garch( .x$Installations, order = c(0,2)), data = .x),
    tidied = purrr::map(fit, broom::tidy),
    glanced = purrr::map(fit, broom::glance) 
   ) 

models.2 <- models.1 %>%
  tidyr::unnest(tidied) %>%
  dplyr::select(Area, term, estimate) %>%
  tidyr::pivot_wider(names_from = term, values_from = estimate)
  
subdirectory <- c("data")
file <- c("solarGARCH.csv")
filePath <- file.path(getwd(), subdirectory, file)
write.csv(models.2, filePath, row.names = FALSE)


# We have a winner!
