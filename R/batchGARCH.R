

# Objective: batch estimate ARCH and GARCH models
# Author: Grant Coble-Neal

# install.packages("broom")
# install.packages("dynlm")
# install.packages("strucchange")
#install.packages("purrr")

library(devtools)
library(githubinstall)
#githubinstall("purrr")

library(broom)
library(data.table)
library(dplyr)
library(dynlm)
library(magrittr)
library("purrr")
library(stringr)
library(strucchange)
library(tidyr)

df$Installations <- ts(df$Installations)

df.0 <- unique(df$Area)

df.1 <- df[df$Area == df.0[1],] # select just the first block of data

# inspect the time series
hist(df.1$Installations, main="", breaks=20, freq=FALSE, col="grey")

plot.ts(df.1$Installations)

# search for break points
bp_ts <- breakpoints(as.ts(df.1$Installations)~1)
ci_ts <-confint(bp_ts)
summary(bp_ts)
plot.ts(df.1$Installations)
lines(bp_ts)
lines(ci_ts)

# get mean of time series after last identified break point
df.result <- dynlm(df.1$Installations[79:length(df.1$Installations)] ~ 1)

# get the residuals
residuals <- as.numeric(df.result$residuals)

# given residuals, fit an ARCH model
ehatsq <- ts(resid(df.result)^2)
LGA.ARCH <- dynlm(ehatsq~L(ehatsq))
summary(LGA.ARCH)
LGA.ARCH$coefficients[1]


# batch process to get mean for each local government area
fitted_means_models <- df %>% group_by(Area) %>% do(df_means = dynlm(df$Installations[79:163] ~ 1)) 

resids <-   unlist(fitted_means_models[[1,2]])
resids.1 <- as.data.frame(resids)

check.1 <- fitted_means_models[[1,2]]  
length(check.1) # get number of list elements
length(fitted_means_models[[2]]) # 113 items in the second list

# use map function to extract components of the nested lists: https://community.rstudio.com/t/extract-nested-list-from-all-elements-levels/60733
test.1 <- fitted_means_models %>% unnest(c(Area, df_means))
test.2 <- map(test.1$df_means, ~ keep(.x, .p = str_detect(names(.x), "residuals")))
test.3 <- as.data.frame(map(test.2, ~ keep(.x, .p = str_detect(names(.x), "coefficients"))))

Results <- data.frame(Area = rep(df.0, each = 85))
Results$Residuals <- (unlist(lapply(fitted_means_models[[2]], "[", 2))) # get the residuals for each area


class(unlist(test.1))
length(rep(df.0, 85)) # get the area list
length(unlist(lapply(fitted_means_models[[2]], "[", 2)))

check.1[[1:1]]$residuals # extract residuals
fitted_means_models[[1]][[1:2]]

df2 <- (unlist(fitted_means_models[[2]]) )
df2.1 <-df2[][]

df2 <- (unlist(fitted_means_models$df_means)  )
df3 <- df2$`coefficients.(Intercept)`
df2$LGA <- as.factor(c(df.0[1]))
names(df2) <- c("")
