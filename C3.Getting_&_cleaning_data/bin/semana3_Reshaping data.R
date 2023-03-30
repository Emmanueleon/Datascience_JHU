# Semana 3: Getting and cleaning data


#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Subsetting and sorting
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
## Creamos la df que utlizaremos ::::::::::::::::::::::::::::::::::::::::::::::::::::::
set.seed(12345)
x <- data.frame("var1"=sample(1:5), "var2"=sample(6:10), "var3"=sample(11:15))
x[sample(1:5),]
x$var2[c(1,3)]=NA
x


## Subsetting :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
### Primera clumna
x[ ,1]  

### Primera columna pero pidiendo el nombre de la columna
x[ ,"var1"]

### Pedir clumna y renglón
x[1:2, "var2"]

### Con valores lógicos, and y or
x[(x$var1<=3 & x$var3>11), ]

### Más general
x[which(x$var2>8), ]


## Sorting ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
### Arreglo de menor a mayor
sort(x$var1)

### Arreglo de mayor a menor 
sort(x$var1, decreasing = TRUE)

### Arreglo poniendo los NA's al final
sort(x$var2, na.last = TRUE)


## Ordering :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
### Ordenando de acuerdo a una fila 
x[order(x$var1), ]

### Ordenando de acuerdo a dos o más filas
x[order(x$var1, x$var3), ]


## Ordering con plyr ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
library(plyr)

### Arreglo de menor a mayor
arrange(x, var1)

### Arreglo de mayor a menor 
arrange(x, desc(var1))


## Agregando nuevos vectores ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
### Nombrando una nueva columna
x$var4 <- rnorm(5)

### Uniendo columnas o renglones
y <- cbind(x, rnorm(5))
y



#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Summarizing data
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
## Creamos la tabla de datos a utilizar 
if(!file.exists("data")){dir.create("data")}
restdata <- read.csv("data/Restaurants.csv")          


## Vistazo de la df :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
### Encabezado de la df
head(restdata, 3)

### Cola de la df
tail(restdata, 3)

### Dimesniones de la df
dim(restdata)


## Resumen de la df :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
### Summary de la df
summary(restdata)

### Estructura de la df
str(restdata)

### Tamaño en megabytes del data set
print(object.size(restdata), units = "MB")

## Quantiles de variables cuantitativas :::::::::::::::::::::::::::::::::::::::::::::
### Quantiles 
quantile(restdata$x_coord)

### Cambiar los quantiles que quiero 
quantile(restdata$x_coord,probs = c(0.5, 0.75, 0.9))


## Tablas de frecuencia :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
### Una sola dimensión
table(restdata$zipcode, useNA = "ifany")  # el useNA pone al final el número de NAs

### Dos dimensiones
table(restdata$zipcode, restdata$city)

### Con alguna condición
table(restdata$zipcode %in% c("21212", "21213"))


## Tablas cruzadas ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
### Datos a utilizar
data("UCBAdmissions")
df <- as.data.frame(UCBAdmissions)
summary(df)

### Son tres variables, una es la que será la mostrada en la tabla (Freq) y las
### otras dos es de acuerdo a como se quieren dividir (Género y Admisión)
xt <- xtabs(Freq~Gender+Admit, data = df)
## Esto nos dice la frecuencia cn que mujéres u hmbres fueron aceptados o rechazados


## Datos faltantes ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
### Checar cuántos valores NA hay
sum(is.na(restdata$zipcode))

### Checar si existen valores NA hay
any(is.na(restdata$zipcode))

### Condición
all(restdata$zipcode>0)

### Checar cuántos valores NA hay por variable
colSums(is.na(restdata))



#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Creando nuevas variables
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
## Nueva variable como factor 
restdata$zcf <- factor(restdata$zipcode)
restdata$zcf[1:10]
class(restdata$zcf)

## HAcer puntos de corte como factores 
library(Hmisc)
restdata$zipcode <- as.numeric(restdata$zipcode)
restdata$zipgroups <- cut2(restdata$zipcode, g=4)
table(restdata$zipgroups)

## HAcer puntos de corte como factores con plyr
library(plyr)
restdata2 <- mutate(restdata, zipgroupsplyr=cut2(zipcode, g=4))
table(restdata2$zipgroupsplyr)



#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Reshaping 
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
## Cargar la librería a utilizar para la base de datos
library(reshape2)
head(mtcars)

## Melting df::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
### Añadir el nombre de los renglones a una columna para que aparezca
mtcars$carname <- row.names(mtcars)

### Melting 
carmelt <- melt(mtcars, id=c("carname", "gear", "cyl"), measure.vars = c("mpg", "hp"))
head(carmelt)

### Crear resumenes de datos 
ddply(InsectSprays, .variables ="spray",   # Variables por las cuales agrupar
      .fun = summarize,                    # Función que quiero aplicar
      sum=sum(count), mean=mean(count))    # De la función summarize, cuales quiero?


#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Combinando ambos temas de subseting y summarizing data
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
## Renglones que cumplan con cierta característica
restdata[restdata$zipcode %in% c("21212", "21213"), ]


#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Manipulación con dplyr
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
library(dplyr)

## Cargar el df a utilizar 
chicago <- readRDS("data/chicago.rds")
dim(chicago)
str(chicago)
colnames(chicago)


## Select
head(select(chicago, city:dptp))

### Excepto 
head(select(chicago, -(city:dptp)))


## Filter
head(filter(chicago, pm25tmean2>30))

## Filtrados con más de una condición 
head(filter(chicago, pm25tmean2> 30 & tmpd> 80))


## Arrange 
head(arrange(chicago, date), 3)

### Rearreglo descendiente
head(arrange(chicago, desc(date)), 3)


## Rename
chicago <- rename(chicago, pm25=pm25tmean2, dewpoint=dptp)
colnames(chicago)


## Mutate
chicago <- mutate(chicago, pm25detrend= pm25-mean(pm25, na.rm=TRUE))
tail(select(chicago, pm25, pm25detrend))


## Group by 
### Crear la variable de agrupación
chicago <- mutate(chicago, 
                  tempcat= factor(1* (tmpd>80), labels=c("cold", "hot")))

### Haciendo el resumen de algunas variabls 
chicago%>%
          group_by(tempcat)%>%
          dplyr::summarise(pm25=mean(pm25), 
                           o3=max(o3tmean2), 
                           no2= median(no2tmean2))

### PAra remover los NAs
chicago%>%
          group_by(tempcat)%>%
          dplyr::summarise(pm25=mean(pm25, na.rm=TRUE), 
                           o3=max(o3tmean2, na.rm = TRUE), 
                           no2= median(no2tmean2, na.rm = TRUE))

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Merging data
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
## Descargar los archivos
url1 <- "https://raw.githubusercontent.com/jtleek/dataanalysis/master/week2/007summarizingData/data/reviews.csv"
url2 <- "https://raw.githubusercontent.com/jtleek/dataanalysis/master/week2/007summarizingData/data/solutions.csv"
download.file(url = url1, destfile = "data/reviews.csv", method = "curl")
download.file(url = url2, destfile = "data/solution.csv", method = "curl")


## Checar los nombres de las variables
reviews <- read.csv("data/reviews.csv")
colnames(reviews)

solutions <- read.csv("data/solution.csv")
colnames(solutions)


## Uniendo los df
mergedata <- merge(reviews, solutions, by.x = "solution_id", by.y = "id", all = TRUE)
head(mergedata,3)

## Conocer los nombres que se encuentran en ambos df
intersect(names(solutions), names(reviews))



