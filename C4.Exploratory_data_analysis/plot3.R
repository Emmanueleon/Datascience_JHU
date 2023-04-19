## Project 1: Energy sub metering by day

# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# 1. Enviroment preparation   
# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
## Limpiar el ambiente
rm(list=ls())

## Load libraries
library(tidyverse)
library(lubridate)

## Import database
epc <- read_delim("../data/household_power_consumption.txt",  delim= ";", )
head(epc)


# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# 2. Clean the data   
# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
## Merge Date and Time and also parse variables "date" data type 
epc <- epc%>%
          unite(col = "complete_date", Date, Time, sep =" ", remove = FALSE)%>%
          mutate(Date=dmy(Date),
                 Time=hms(Time), 
                 complete_date=dmy_hms(complete_date))%>%
          filter(between(Date, as.Date("2007-02-01"),as.Date("2007-02-02")))%>%
          print()

# We observe that numeric columns are typifyed as "character" data type due "?" symbol. 
epc%>%
          filter(Global_active_power=="?")

## Clean the data
### Make a vector with col names
epc_names <- colnames(epc)

### Remove Date and time columns
epc_names <- epc_names%>%
          setdiff(.,c("Date","Time", "complete_date"))

### Remove "?" and transform to "numeric" data type
epc <- epc%>%
          mutate_at(vars(epc_names),~ str_remove(.,"\\?"))%>%
          mutate_at(vars(epc_names),list(as.numeric))



# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# 3. Graph   
# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
png(filename = "../plot3.png", width = 480, height = 480, units = "px")

## Sub metering 1
with(epc, plot(Sub_metering_1~ complete_date, type="l", col="black", ylab="Energy sub metering", xlab=""))

## Sub metering 2
with(epc, lines(Sub_metering_2~ complete_date, type="l", col="red"))

## Sub metering 3
with(epc, lines(Sub_metering_3~ complete_date, type="l", col="blue"))

## Legend
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       lty = 1, col = c("black", "red", "blue"))

dev.off()
