
# Objective: set up worked examples from the "Principles of Econometrics"
#              https://bookdown.org/ccolonescu/RPoE4/time-varying-volatility-and-arch-models.html#the-arch-model


install.packages("remotes")  # if not already installed
library(remotes)
install_git("https://github.com/ccolonescu/PoEdata")

data("byd", package = "PoEdata")
rTS <- ts(byd$r)
