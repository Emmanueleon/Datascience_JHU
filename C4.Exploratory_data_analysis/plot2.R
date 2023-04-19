## Project 1: Global active power by day

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
          filter(between(Date, as.Date("2007-02-01"),as.Date("2007-02-02")))

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
          mutate_at(vars(epc_names),list(as.numeric))%>%
          print()



# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# 3. Graph   
# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
png(filename = "../plot2.png", width = 480, height = 480, units = "px")
with(epc, plot(Global_active_power~ complete_date, type="l", 
               xlab="",
               ylab="Global Active Power (kilowatts)"))
dev.off()
