## Project 2: Fine particulate matter (Pm25) analysis

# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# 1. Enviroment preparation   
# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
## Clean the enviroment
rm(list=ls())

## Load libraries
library(tidyverse)
library(RColorBrewer)

## Data
ppm_emission <- readRDS("../data/summarySCC_PM25.rds")
ssc_code <- readRDS("../data/Source_Classification_Code.rds")


# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# 2. Data inspection
# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
## Ppm Emission
head(ppm_emission)
dim(ppm_emission)
colnames(ppm_emission)
str(ppm_emission)

# A data frame with 6 variables (fips, SCC, Pollutant, Emissions, type and year) and 6497651 observations. 


## SSC code
head(ssc_code)
dim(ssc_code)
colnames(ssc_code)
str(ssc_code)

# A data frame with 15 variables and 11717 observations. 


# Due to its wealth of information I decided not to merge both df into one and 
# better wait until more specific tasks are completed. 


# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# 2. Question 1

# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
# Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for 
# each of the years 1999, 2002, 2005, and 2008.

# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
## Create a data base with the sum of emissions by year
all_emissions <- ppm_emission%>%
          select(Emissions, year)%>%
          filter(year=="1999" | year=="2002" | year=="2005" | year=="2008")%>%
          group_by(year)%>%
          summarise(total_emissions=sum(Emissions), .groups = "drop")%>%
          print()

## Graph
png(filename = "../submission/plot1_total_emissions.png", width = 480, height = 480, units = "px")

with(all_emissions, plot(log10(total_emissions)~year, type="o",col="red", lwd=2,
             main = expression("Total"~ PM[2.5]~ "Emissions by year"), 
             xlab="Year", ylab = expression(~ PM[2.5] ~ " Emissions ("~log[10]~")")))

 dev.off()
 
 # R1: Total emissions from all sources decreased from 1999 to 2008 in the United States.

 
 # ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
 # 2. Question 2
 
 # Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510")
 # from 1999 to 2008? Use the base plotting system to make a plot answering this question.
 
 # ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
baltimore_emissions <- ppm_emission%>%
          select(fips, Emissions, year)%>%
          filter(fips=="24510" & between(year,1999,2008))%>%
          group_by(year)%>%
          summarise(total_emissions=sum(Emissions), .groups = "drop")%>%
          print()

## Graph
png(filename = "../submission/plot2_baltimore_emissions.png", width = 480, height = 480, units = "px")

with(baltimore_emissions, plot(log10(total_emissions)~year, type="o",col="red", lwd=2,
                               main = expression("Baltimore total"~ PM[2.5]~ "Emissions between 1999 and 2008"), 
                               xlab="Year", ylab = expression(~ PM[2.5] ~ " Emissions ("~log[10]~")")))

dev.off()

# R2: In Baltimore there was a fluctuation in PM2.5 emission levels between 1999 and 2008,
# but overall decreased its total emissions by 2008. 


# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# 2. Question 3

# Of the four types of sources indicated by the typetype (point, nonpoint, onroad, nonroad) variable,
# which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
# Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a plot 
# answer this question.

# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
png(filename = "../submission/plot3_baltimore_emissions_source_type.png", width = 480, height = 480, units = "px")

ppm_emission%>%
          select(fips, Emissions, year, type)%>%
          filter(fips=="24510" & between(year,1999,2008))%>%
          group_by(year, type)%>%
          summarise(total_emissions=sum(Emissions), .groups = "drop")%>%
          ggplot(aes(x=year, y=log10(total_emissions), color=factor(type)))+
          geom_line(linewidth=1.2)+
          geom_point(color="black", pch=4, size=1.5)+
          scale_color_brewer(palette = "Dark2")+
          facet_wrap(.~type, nrow = 4)+
          labs(title =expression("Baltimore total"~ PM[2.5]~ "Emissions by type of source"), 
               subtitle = "Between 1999 and 2008\n", 
               x="\n Years", y=expression(~ PM[2.5] ~ " Emissions ("~log[10]~")"))+
          theme_linedraw()+
          theme(legend.position = "none", 
                strip.background = element_rect(fill = "gray"), 
                strip.text.x  = element_text(size=6, color="black", face = "bold"))

dev.off()

## Calculate the delta ppm emission
ppm_emission%>%
          select(fips, Emissions, year, type)%>%
          filter(fips=="24510" & between(year,1999,2008))%>%
          group_by(year, type)%>%
          summarise(total_emissions=sum(Emissions), .groups = "drop")%>%
          pivot_wider(names_from = year, values_from = total_emissions, names_prefix = "Year_")%>%
          mutate(delta=Year_2008-Year_1999)%>%
          arrange(delta)

# R3: Graphically we note that all source types in Baltimore, except point, decreased over time. 
# Calculating the delta of emissions by year, we observe that the nonpoint source type is the source with the greatest decrease in emissions. 
# While the point source type increased between 1999 and 2008.


# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# 2. Question 4

# Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

## Identify combustion and coal and then separate by levels. 
comb_coal_code <- ssc_code%>%
          select(SCC, Short.Name)%>%
          filter(grepl("[Cc]ombustion | [Cc]oal", Short.Name))%>%
          separate(col=Short.Name, into = c("L1", "L2", "L3", "L4"), sep = " /")%>%
          select(SCC, L1, L3)

## Join sscode and ppm emition df
comb_coal_emission <- ppm_emission%>%
          select(SCC,Emissions, year)%>%
          inner_join(comb_coal_code, by="SCC")%>%
          group_by(year)%>%
          summarise(total_emissions=sum(Emissions), .groups = "drop")%>%
          print()

## Graph
png(filename = "../submission/plot4_coal_combustion.png", width = 480, height = 480, units = "px")

comb_coal_emission%>%
          ggplot(aes(x = year,y = log10(total_emissions)))+
          geom_bar(fill="grey", stat="identity", width=0.75) +
          geom_line(color="blue", lty=2, lwd=0.8)+
          geom_point(color="black", pch=4, size=1.5)+
          labs(title =expression("Total"~ PM[2.5]~ "Emissions by coal combustion across US"), 
               subtitle = "From 1999 to 2008\n", 
               x="\n Years", y=expression(~ PM[2.5] ~ " Emissions ("~log[10]~")"))+
          theme_linedraw()+
          theme(legend.position = "none", 
                strip.background = element_rect(fill = "gray"), 
                strip.text.x  = element_text(size=6, color="black", face = "bold"))
          
dev.off()

# R4: Between 1999 and 2008 there was a substantial reduction in Pm2.5 emissions from coal combustion-related sources
# in the United States, from 583673 to 349192 tons, respectively. 


# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# 2. Question 5

# How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City

# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

## Filter vehicles in ssc code
vehicle_code <- ssc_code%>%
          select(SCC, Short.Name,SCC.Level.Two)%>%
          filter(grepl("[Vv]ehicle*", SCC.Level.Two))%>%
          separate(col=Short.Name, into = c("L1", "L2", "L3", "L4"), sep = " /")%>%
          print()


## Join vehicle and ppm emition df
vehicle_emission <- ppm_emission%>%
          select(fips, SCC,Emissions, year)%>%
          filter(fips=="24510" & between(year,1999,2008))%>%
          inner_join(vehicle_code, by="SCC")%>%
          group_by(year)%>%
          summarise(total_emissions=sum(Emissions), .groups = "drop")

## Graph
png(filename = "../submission/plot5_Baltimore_motor_vehicle.png", width = 480, height = 480, units = "px")

vehicle_emission%>%
          ggplot(aes(x=year, y=log10(total_emissions)))+
          geom_line(color="red", linewidth=1.2)+
          geom_point(color="black", pch=4, size=2)+
          labs(title =expression("Baltimore total"~ PM[2.5]~ "Emissions from motor vehicle sources"), 
               subtitle = "Since 1999 to 2008\n", 
               x="\n Years", y=expression(~ PM[2.5] ~ " Emissions ("~log[10]~")"))+
          theme_linedraw()+
          theme(legend.position = "none", 
                strip.background = element_rect(fill = "gray"), 
                strip.text.x  = element_text(size=6, color="black", face = "bold"))

dev.off()

# R5: There is a huge drop in emissions from motor vehicle sources from 1999–2008 in Baltimore City.


# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# 2. Question 6

# Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle 
# sources in Los Angeles County, California (fips == "06037"). 
# Which city has seen greater changes over time in motor vehicle emissions?

# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

## Filter vehicles in ssc code
vehicle_code <- ssc_code%>%
          select(SCC, Short.Name,SCC.Level.Two)%>%
          filter(grepl("[Vv]ehicle*", SCC.Level.Two))%>%
          separate(col=Short.Name, into = c("L1", "L2", "L3", "L4"), sep = " /")%>%
          print()

## Filter vehicles in ssc code
fips_vehicle_emission <- ppm_emission%>%
          select(fips, SCC, Emissions, year)%>%
          filter(fips=="24510" | fips=="06037" & between(year,1999,2008))%>%
          inner_join(vehicle_code, by="SCC")%>%
          group_by(fips, year)%>%
          summarise(total_emissions=sum(Emissions), .groups = "drop")%>%
          print()

## Graph
png(filename = "../submission/plot6_Baltimor_California_motor_vehicle.png", width = 480, height = 480, units = "px")

fips_vehicle_emission%>%
          ggplot(aes(x = year,y = log10(total_emissions)))+
          geom_bar(aes(fill=factor(year)), alpha=0.85, stat="identity", width=2)+
          geom_line(color="red", lwd=0.8)+
          geom_point(color="black", pch=4, size=1.5)+
          labs(title =expression("Total"~ PM[2.5]~ "Emissions from motor vehicle sources"), 
               subtitle = "Between Los Angeles and Baltimore since 1999 to 2008\n", 
               x="\n Years", y=expression(~ PM[2.5] ~ " Emissions ("~log[10]~")"))+
          scale_x_continuous(limits = c(1996, 2011), breaks = seq(1999, 2008, by=3))+
          scale_fill_brewer(palette = "Set2")+
          facet_wrap(.~fips, ncol = 2, labeller = as_labeller(c("06037"="Los Angeles","24510"="Baltimore")))+
          theme_linedraw()+
          theme(legend.position = "none", 
                strip.background = element_rect(fill = "gray"), 
                strip.text.x  = element_text(size=10, color="black", face = "bold"))

dev.off()

# R6: Emissions from motor vehicle sources in Los Angeles showed greater changes over time, with an increase in emissions
# between 2002 and 2005, and then a decrease in 2008. While Baltimore City decreased its emissions over time. 
