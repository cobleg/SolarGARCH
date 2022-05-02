# SolarGARCH
Fitting GARCH models to monthly solar power system installation data by local government area

# Problem statement
I have a need to calibrate simulation models rapidly and with minimal manual intervention. I usually apply a statistical process, i.e. fit a statistical model to data to estimate unknown model parameters.

On many such occasions, I have dozens of models to fit and sometimes hundreds and thousands of models. Doing this the 'old fashioned way' is error-prone and time consuming.

This problem is compounded by the need to fit GARCH models; GARCH is a type of timeseries model.

Other aspects of this specific problem are:
1. There are 113 areas with each one requiring its own fitted model
2. The received data is monthly timeseries of solar power system installations
3. The received data exhibits time-varying volatility

# Approach to solution
There are many ways to approach this. Software tools such as R, Python & SAS can be used. I have chosen R because I know there are a few GARCH libraries. Also, I know there are useful libraries such as auto.arima in the 'forecast' library (https://www.rdocumentation.org/packages/forecast/versions/8.16/topics/auto.arima) that assist with fitting multiple timeseries models quickly.

In using R, I discovered other helpful libraries in the Tidyverse system that allow use of the nest-map-unnest workflow: https://cran.r-project.org/web/packages/broom/vignettes/broom_and_dplyr.html

# Other comments
- This would have been easy in SAS using the 'by' statement
- I receive 50+ warnings when I use the 'dynlm' and 'tseries' libraries with 'broom'
- The output CSV file is an input to a Ventity simulation model: https://ventity.biz/  
- The journey led me deeper into the Tidyverse: https://youtu.be/rz3_FDVt9eg
