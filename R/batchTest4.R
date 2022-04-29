

# Objective: conduct a batch ARCH test for each local government area
# Author: Grant Coble-Neal

library(aTSA)
library(broom)
library(dplyr)
library(purrr)
library(tidyr)

df <- as_tibble(df)  %>% # dependency: run importFile.R to get the 'df' object
  mutate(DateTime = as.Date(DateTime,  "%m-%d-%Y"))

ARCH.test <- df %>%
  tidyr::nest(data = -Area) %>%
  mutate(
    arch = map(data, ~ arch.test(Installations)),
    tidied = map(arch, tidy)
    
  )
