# Semana 4: Getting and cleaning data


#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Editing text variables
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
camera <- read.csv("data/cameras.csv")
colnames(camera)

tolower(names(camera))


splitnames <- strsplit(names(camera), "\\.")
splitnames 


mylist <- list(letters=c("A", "b", "c"), numbers=1:3, matrix(1:25, ncol=5))
head(mylist)

### Primer elemento de la lista
mylist[1]

### Si quiero el contenido dentro de la primera lista 
mylist[[1]]

### Si quiero el segundo contenido de mi primer lista
mylist[[1]][2]

### Llamar la primer lista con $
mylist$letters

### LLamar el segundo elemento de mi primer lista con $
mylist$letters[2]

## Arreglar los vectores utilizando sapply
### Crear una función 
firstelement <- function(x){x[1]}

### Aplicarla con el sapply
sapply(splitnames, firstelement)


## Substituir en los nombres algun caracter
### Nombres originales
names(reviews)

### Substitución 
sub(pattern = "_",replacement = "", x =names(reviews))

### Sin embargo esto solo lo hará la primera vez que lo vea 
testname <- "this_is_a_test"
sub("_", "", testname)

### Se puede utilizar gsub para sustitur a lo largo 
gsub(pattern = "_", replacement = "", x = testname)


## Busqueda de patrones :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
### Encontrar valores (posición)
grep(pattern = "M", x = camera$status)
# Nota: lo que Grep hace es decirme en que posicioes se encuentra el patron

### Encontrar valores (vector)
grep(pattern = "M", x = camera$status, value = TRUE)
# Nota: value me enseña lo que dice la posición, en este caso todo es igual

### Encontrar valores (lógico)
grepl(pattern = "M", camera$status)
#### Para saber cuántas veces aparece lo juntamos con una tabla de frecuencia
table(grepl(pattern = "M", x = camera$status))

### Encontrar un valor específcio
#### En este ejemplo no hay un nombre así en esa columna
grep(pattern = "baltimorecity", camera$arc_street)
length(grep(pattern = "baltimorecity", camera$arc_street))

#### En este ejemplo si hay un nombre así en esa columna
grep(pattern = "baltimorecity", camera$email)
length(grep(pattern = "baltimorecity", camera$email))


## Funciones para strings :::::::::::::::::::::::::::::::::::::::::::::::::::::::::
library(stringr)

### Saber cuántos caracteres hay en una palabra
nchar("Emmanuel Cervantes Monroy")

### Seleccionar solo algunas letras 
substr("Emmanuel Cervantes Monroy", 3,8)

### Pegar letras con espacio
paste("Hola", "Emmanuel")

### PEgar letras sin espacio 
paste0("Hola", "Emmanuel")

### Remover los estacios 
str_trim("Emmanuel         ")


#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Expresiones regulares
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

## Metacaracteres
# ^: Principio de linea, ^Hola
# $: Final de la linea, morning$
# []: Listamos caracteres que pueden ser aceptados, [Mm] [Aa] [Nn] [Uu] 
# []: También puede ser utilizado como un matcheador al ser utilizado al principio
# -: Rango de letras, se usa con el [], [0-9] o [a-zA-Z]. El orden no importa
# . : Cualquier caracter.
# | : combina dos expresiones o alternativas (es el or). fuego|fire
# (): Muy utilizado con el or para poner las alternativas (es el and). 
# ?: Indica que la expresión es opcional, se usa con el ().
# \: Sirve para utilizar como caracter cualquier metacaracter, si esta junto a un 
# metacaracter, de otra manera significa un tipo repetición exacto
# *: cualquier caracter
# +: al menos un item
# {}: intervalo, nos permite especificar el número mínimo y máximo de veces que machea una expresión
# , : significa al menos


## Las busquedas se pueden realizar combinando los metacaracteres 
# ^[Hh]ola, buscará todas las oraciones que inicien con Hola u hola

# ^[0-9] [A-Za-z], buscará todas las oraciones que empiecen con un número al principio 
# y tengas cuanquier letra después p.e "7th". 

# [^?.]$ Aquí buscará al final de la oración cualquier palabra que termine 
# diferene a "?" y "." ; Dentro de "[]", el metacaracter [^] significa "diferente".

# 9.11, buscará cualquier caractér que haya entre el 9 y el 11 pe. 

# .e.e|recién nacido|niñ. buscará las palabras bebé O nene O recién nacido O niñ@

# ^([Gg]ood | [Bb]ad). Buscará que al inicio de la oración se encuentre el Goog, good
# Bad o bad. Si no usamos los (), indica que solo va a encontrar al principio de la oración
# la palabra Good o good, pero Bad o bad pueden estár no al principio de la oración. 

# [Gg]eorge( [Ww]\.)? [Bb]ush. Busca cualquier palabra que diga George Bush pero el
# ( [Ww]\.)? indica un espacio, el "\" se utiliza para tomar al punto como punto y no 
# como metaracarcter y el ? que encierra los () indica que puede ser pcional. 
# se puede encontrar George W. Bush. 

# [0-9]+ (.*)[0-9]+ Busca cualquier número, espacio cualquier palabras o caracteres
# hasta encontrar otra serie de números. 

# [Bu]ush( +[^ ]+ +){1,5} debate . Buscará la palabra Bush, sequido de un espacio, 
# seguido de cualquier cosa que no sea un espacio [^ ], más un espacio, entre 1 a 5 veces
# antes de encontrar la palabra debate. 

# m,n al menos una m pero no más de n veces. 
# m exactamente m matches
# m, al menos m matches


#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Trabajando con fechas
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
d1 <- date()
class(d1)

d2 <- Sys.Date()
class(d2)

## Para cambiar el formato de la fecha 
# %d día como número 
# %a día de la semana abreviado 
# %A día de la semana NO abreviado 
# %m mes (00-12)
# %b mes abreviado
# %B mes no abreviado
# %y año en 2 dígitos 
# %Y año en 4 dígitos

### Día, mes y año
format(d2, "%a %b %y")


## Los formatos de caracteres tmbn los puedo convertir en fechas
x <- c("1jan1960", "2jan1960")
z <- as.Date(x, "%d%b%Y")


## Las fechas se pueden utilizar como números
z[1]-z[2]
# o
as.numeric(z[1]-z[2])


### Convertir a 
### Día de la semana
weekdays(d2)

### Mes 
months(d2)


## Usando la paquetería de lubridate
library(lubridate)

# De acuerdo a como está el string de la fecha pongo la función para que me
# convierta la fecha en año-mes y día

ymd("20140108")  # Aquií empieza por año mes y día 

mdy("08/04/2013")  # Aquí empieza por mes, día y año

dmy("03-04-2013") # Aquí empieza por día mes y año 
