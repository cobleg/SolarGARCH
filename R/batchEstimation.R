

# Objective: develop a batch estimation process for multivariate statistical model fitting
# Author: Grant Coble-Neal

# reference: https://stackoverflow.com/questions/62466711/can-i-fit-different-regression-models-using-mapply
# reference: https://www.r-bloggers.com/2017/02/how-to-create-a-loop-to-run-multiple-regression-models/

library(stats)

dependent<-c("Sepal.Length","Sepal.Width")
independent<-c("Sepal.Width","Sepal.Length")

reg<- function(dependent,independent) {
  lm(paste0(dependent,"~",independent),data=iris)
}

model <- Map(reg, dependent, independent)

model <- lm(paste0(dependent[1]~independent), data = iris)
model.coefficients <- model[1]
model.coefficients$Sepal.Length$coefficients[1]

library(lme4)
for (i in out_start:out_end){
  outcome = colnames(dat)[i]
  for (j in exp_start:exp_end){
    exposure = colnames(dat)[j]
    model <- lmer(get(outcome) ~ get(exposure) + v1 + (1|v2) + (1|v3),
                  na.action = na.exclude,
                  data=dat)
  }
}