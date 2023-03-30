# Ideas básicas del curso 
# Encontrar y extrar datos cruds
# Principios de los datos tidy y como hacer datos tidy
# Implementación práctica através de los paquetes de R

# El camino a seguir: 
# Datos crudos -> Procesdamiento-> Tidy data-> Análisis de datos-> Comunicación de los datos

# Definición de datos
# Los datos son variables cuantitativas o cualitativas que pertenecen a un set de 
# individuos, poblaciones...



############################################################################################################
# Entorno
############################################################################################################

## Working directory 
getwd()
setwd()

### Nota 
# Ruta relativa: setwd("../data") 
# Ruta absoluta setwd(Desktop/data)

## Creación de directorios
if (!file.exists("data")){
          dir.create("data")
}


############################################################################################################
# 2. Descarga datos de internet
############################################################################################################
# Útil para descargar archivos tsv, csv y algunos otros archivos, descargar datos de internet
# es muy útil para la reproducibilidad del flujo de trabajo. En general almacenar los datos
# en formatos de archivo planos como .csv o .tsv es mejor ya que su distribución ees más 
# sencilla


## 2. Descargar desde url ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
fileurl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accesType=DOWNLOAD"
download.file(fileurl, destfile = "data/cameras.csv", method = "curl")
list.files("data")

### 2.1 Poner la fecha en que la que el archivo fue descargado
date_downloaded <- date()
date_downloaded

### Nota: 
# Método curl es necesario apra Mac 


## 3. Lectura de archivos planos locales ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
read.table()  # No tan bueno para bases de datos muy grandes

camera_data <- read.csv("data/cameras.csv")
head(camera_data)

# Nota: 
# Uno de los problemas más comunes es tener comas en algún lugar de la base de datos, 
# esto se puede reolver con el argumento quote="". 


## 4. Lectura de archivos excel locales ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
library(xlsx)
camera_data <- read.xlsx("../../../Desktop/Metadata.xlsx", sheetIndex = 1, header = TRUE)
head(camera_data)


## 5. Lectura de archivos XML(Extensible Markup Languaje) :::::::::::::::::::::::::::::::::::::::::::::::::
# Lenguaje muy utilizado en aplicaciones de internet, almacena datos estructurados. 
# Está compuesto de tags, elementos y atributos.

# 1. Tags, corresponden a las etiquetas generales: 
#    - Start tags <section>
#    - End tags  </section>
#    - Empty tags <line-break/>

# 2. Elements, ejempls específicos de los tags:
#    - <Gretting> Hellow, world </Greeting>

# 3. Componentes de las etiquetas:
#    - <img src="jeff.jpg" alt="instructor"/>
#    - <step nimber="3"> Connect A to B. </step>

library(XML)
fileurl <- "https://www.w3schools.com/xml/simple.xml"
doc <- xmlTreeParse(fileurl, useInternalNodes = TRUE)

doc <- xmlParse("data/employee.xml")
root_node <- xmlRoot(doc)
xmlName(root_node)

names(root_node)

root_node[[1]] # Primera lista

root_node[[1]][[1]] # Primer elemento de la primera lista

xmlSApply(root_node, xmlValue)


data <- xmlParse("data/employee.xml")
data
