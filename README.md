# Programas presidenciales elecciones 2019: Argentina y Uruguay

Las próximas elecciones presidenciales en Argentina y Uruguay serán el tema de la semana 22 (4 de septiembre) del proyecto [#datosdemieRcoles](https://github.com/cienciadedatos/datos-de-miercoles). En este repositorio está el código que utilicé para descargar y procesar los archivos. 

## Argentina

Los programas están disponibles en el sitio web de ambas candidaturas, así que podemos leerlos en R usando el paquete para _web scraping_ [**rvest**](http://rvest.tidyverse.org/).


### Frente de todos

Primero, leemos el sitio web con **rvest**:

```r
library(rvest)
library(dplyr)
library(stringr)

frente_html <- read_html("https://www.frentedetodos.org/plataforma") %>% 
  html_nodes(".s12") %>% 
  html_text()
```

Como hay espacios de sobra en algunas partes, limpiamos el archivo usando [**stringr**](https://stringr.tidyverse.org/index.html). Luego, guardamos el texto indicando los metadatos en el nombre del archivo: país, partido, apellido del candidato y año de la elección. Utilizaremos ese formato en todos los archivos.

```r
frente_html %>%
  str_replace_all("\n[:space:]+", "\n") %>% 
  readr::write_file("argentina_frente-de-todos_fernandez_2019.txt")
  ```

### Juntos por el cambio

Hacemos lo mismo. Leemos:

```r
juntos_html <- read_html("http://pro.com.ar/plataforma-electoral/") %>% 
  html_nodes(".desc") %>% 
  html_text()
```

Y luego limpiamos y guardamos:

```r
juntos_html %>%
  str_replace_all("([\r\n]+)([:space:]*)", "\n") %>% 
  readr::write_file("argentina_juntos-por-el-cambio_macri_2019.txt")
```

## Uruguay

En este caso los programas están en formato pdf, así que los convertimos a texto plano usando el paquete [**pdftools**](https://github.com/ropensci/pdftools).

### Frente Amplio

Primero, descargamos el archivo pdf:

```r
download.file("https://frenteamplio.uy/campana/bases-programaticas/download/331/759/34", "pdf/frente-amplio.pdf", mode = "wb")
```

Luego, lo convertimos a texto plano:

```r
frente_amplio <- pdftools::pdf_text("pdf/frente-amplio.pdf")
```
A continuación tenemos que hacer varias cosas: concatenar las páginas (quedó cada una como una cadena de caracteres distinta), eliminar el pie de página y la numeración, juntar las palabras separadas por guión y salto de línea, eliminar espacios extras, etc. Finalmente, guardamos el texto con los metadatos en el nombre del archivo:

```r
frente_amplio %>%
  str_c(collapse = "\n") %>% 
  str_remove_all("BASES PROGRAMÁTICAS 2020 - 2025[:space:]+[:digit:]+[:space:]") %>%
  str_remove_all("\n[:digit:]+[:space:]+FRENTE AMPLIO\n[:space:]") %>%
  str_remove_all("-\n[:space:]*") %>%
  str_replace_all("\n(?=[:lower:])", " ") %>%
  str_replace_all("\n[:space:]", "\n") %>% 
  str_remove_all("(\\.)(\\.)+[:space:]*[:digit:]+") %>% 
  readr::write_file("uruguay_frente-amplio_martinez_2019.txt")
```

**IMPORTANTE**: Los títulos de sección de este programa estaban como imagen, por lo que no aparecen en archivo final. Esto tiene como consecuencia que sea difícil identificar qué temas se aborda en cada sección mirando el archivo. 

## Partido Nacional

Hacemos lo mismo: descargar, convertir, limpiar y guardar.

```r
download.file("http://lacallepou.uy/descargas/programa-de-gobierno.pdf", "pdf/partido-nacional.pdf", mode = "wb")

partido_nacional <- pdftools::pdf_text("pdf/partido-nacional.pdf")
```

Acá hay más cosas que limpiar:

```r
partido_nacional %>%
  str_c(collapse = "") %>% 
  str_remove_all("IR AL INDICE[:space:]+[:digit:]+") %>%
  str_remove_all("[\t]+") %>% 
  str_replace_all("[:space:]{2,}", "\n") %>%
  str_replace_all("-\n", "") %>% 
  str_replace_all("\n(?=[:lower:])", " ") %>% 
  str_replace_all("\n[:digit:]+\n", "\n") %>% 
  readr::write_file("uruguay_partido-nacional_lacalle-pou_2019.txt")
```

## Partido Colorado

El mismo proceso:

```r
# descargar

download.file("https://d3n8a8pro7vhmx.cloudfront.net/talvi/pages/77/attachments/original/1561563373/Programa_de_Gobierno_de_Ciudadanos_2020-2025_web_%281%29.pdf?1561563373", "pdf/partido-colorado.pdf", mode = "wb")

# convertir

partido_colorado <- pdftools::pdf_text("pdf/partido-colorado.pdf")

# limpiar y guardar

partido_colorado %>%
  str_c(collapse = "") %>% 
  str_remove_all("\n[:space:]{2,}[:digit:]+") %>% 
  str_remove_all("(\\.[:space:](\\.)*){4,}[:digit:]+") %>% 
  str_replace_all("-\n", "") %>% 
  str_replace_all("\n(?=[:lower:])", " ") %>%
  str_remove_all(regex("^([:space:]+)", multiline = TRUE)) %>%
  str_replace_all("[:digit:]+[:space:]{2,}(?=[:alpha:])", "") %>%
  str_remove_all("[:space:]{5,}") %>% 
  readr::write_file("uruguay_partido-colorado_talvi_2019.txt")
  
```

Respecto de este programa hay que tener en cuenta varias cosas. Primero, que incluía muchas notas al pie que en algunos casos cortan los párrafos que se extienden de una página a otra. Segundo, que contenía gráficos, por lo que luego de convertir el pdf solo queda el título y las notas. Tercero, que había tablas. En ese caso, los datos quedan, pero sin formato. Por último, hubo problemas en la conversión de algunos títulos por la tipografía y diseño en el pdf original, lo que hizo que en algunos casos quedaran espacios entre las letras de una palabra:

<a href="url"><img src="https://github.com/rivaquiroga/programas-presidenciales-2019/blob/master/otros-problemas.png" align="center" width="50%"></a>

Eso no está arreglado en los archivos `*.txt` incluidos en este repositorio. 








  
