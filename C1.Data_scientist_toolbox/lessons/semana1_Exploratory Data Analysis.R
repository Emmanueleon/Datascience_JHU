# Semana 1: Exploratory Data Analysis: 


## Gráficas exploratorias
# Son las gráficas utilizadas de manera exploratoria por el investigador ya que son 
# rápidas de hacer.El objetivo es un entendimiento individual,
# no buscan usarse para comunicar resultados. 

## Resumen de los datos (Una dimensión)
# * Resuen 5 números (Estadística descriptiva)
# * Boxplots
# * Histogra,a 
# * Gráfica de densidad
# * Barplot

# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
## 1. Preparación del ambiente  
# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
### Limpiar el ambiente
rm(list=ls())

### Crear carpeta de los datos
if (!file.exists("data")){
          dir.create("data")
}

## Descargar la df que vamos a utilizar 
pollution_df <- "../data/pollution.csv"
url <- "https://raw.githubusercontent.com/Xiaodan/Coursera-Exploratory-Data-Analysis/master/data/avgpm25.csv"

if (!file.exists(pollution_df)){
          download.file(url, pollution_df, method="curl")
}  

## Leer la df
pollution <- read.csv(pollution_df, 
                      colClasses = c("numeric", "character", 
                                     "factor", "numeric","numeric"))

head(pollution)

# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
## 2. Resumen de los datos una sola variable 
# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
## Resumen de 5 números
summary(pollution$pm25)

## Boxplot
boxplot(pollution$pm25, col = "green")
abline(h=12)


## Histograma
hist(pollution$pm25, col="blue", breaks = 50)
rug(pollution$pm25)
abline(v=median(pollution$pm25), col="red", lwd=3)


### Barplot (Más para datos categóricos)
barplot(table(pollution$region), col="red", 
        main = "Number f countries in each region")


# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
## 3. Resumen de los datos dos variables
# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
## De 1 dimensión sobrepuestos
### Boxplots
boxplot(pm25~ region, data=pollution, col="blue")

### Histogramas
par(mfrow=c(2,1), mar=c(4,4,2,1))
hist(subset(pollution, region=="east")$pm25, col = "green")
hist(subset(pollution, region=="west")$pm25, col = "green")


## Scatterplot
with(pollution, plot(latitude, pm25, col=region))
abline(h=12, lwd=2, lty=2)

### Multiples scatterplot
par(mfrow=c(1,2), mar=c(5,4,2,1))
with(subset(pollution, region=="west"), plot(latitude, pm25, col="black", main="West"))
with(subset(pollution, region=="east"), plot(latitude, pm25, col="red", main="East"))


### 
#Plotting systems in R
####
## R base
with(cars, plot(speed, dist))

## Lattice 
library(lattice)
state <- data.frame(state.x77, region=state.region)  
xyplot(Life.Exp~Income| region, data=state, layout=c(4,1)) # "|" me permite definir la variable por la cuál agrupar como facet de  ggplot


## Ggplot
qplot(displ, hwy, data=mpg)


