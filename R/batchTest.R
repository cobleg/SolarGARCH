

# Objective: test batch forecasting process
# Source: https://www.r-bloggers.com/2016/02/batch-forecasting-in-r-2/

# install.packages("forecast")

library(forecast)

ddat <- data.frame(date = c(seq(as.Date("2010/01/01"), as.Date("2010/03/02"), by=1)),
                   value1 = abs(round(rnorm(61), 2)),
                   value2 = abs(round(rnorm(61), 2)),
                   value3 = abs(round(rnorm(61), 2)))
head(ddat)
tail(ddat)

lst.names <- c(colnames(data))
lst <- vector("list", length(lst.names))
names(lst) <- lst.names
lst

batch <- function(data, n_train=55){
  
  lst.names <- c(colnames(data))
  lst <- vector("list", length(lst.names))
  names(lst) <- lst.names    
  
  for( i in 2:ncol(data) ){  
    
    lst[[1]][["train_dates"]] <- data[1:(n_train),1]
    lst[[1]][["test_dates"]] <- data[(n_train+1):nrow(data),1]
    
    est <- auto.arima(data[1:n_train,i])
    fcas <- forecast(est, h=6)$mean
    acc <- accuracy(fcas, data[(n_train+1):nrow(data),i])
    fcas_upd <- data.frame(date=data[(n_train+1):nrow(data),1], forecast=fcas,                           actual=data[(n_train+1):nrow(data),i])
    
    lst[[i]][["estimates"]] <- est
    lst[[i]][["forecast"]] <- fcas
    lst[[i]][["forecast_f"]] <- fcas_upd
    lst[[i]][["accuracy"]] <- acc
    
    cond1 = diff(range(fcas[1], fcas[length(fcas)])) == 0
    cond2 = acc[,3] >= 0.025
    
    if(cond1|cond2){
      
      mfcas = forecast(ma(data[,i], order=3), h=5)        
      lst[[i]][["moving_average"]] <- mfcas
      
    } else {
      
      est2 <- auto.arima(data[,i])
      fcas2 <- forecast(est, h=5)$mean
      
      lst[[i]][["estimates_full"]] <- est2
      lst[[i]][["forecast_full"]] <- fcas2
      
    }  
  }  
  return(lst)
}

results <- batch(ddat)
