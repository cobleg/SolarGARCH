

# Objective: import data
wd <- getwd()
subdirectory <- c("data")
file <- c("PV_Installs_LGA.csv")
filePath <- file.path(wd, subdirectory, file)
df <- read.csv(filePath, header = T)
names(df) <- c("Area", "DateTime", "Capacity", "Installations")

df$Area <- as.factor(df$Area)
