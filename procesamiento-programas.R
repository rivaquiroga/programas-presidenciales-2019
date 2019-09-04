library(rvest)
library(dplyr)
library(stringr)

# ARGENTINA

# Los programas están disponibles en el sitio web de ambas candidaturas, así que los leeremos desde ahí usando el paquete para web scraping {rvest}

# FRENTE DE TODOS
# leemos el código html
frente_html <- read_html("https://www.frentedetodos.org/plataforma") %>% 
  html_nodes(".s12") %>% 
  html_text()

# guardamos el texto limpiando previamente el exceso de espacios en algunas partes. En el nombre del archivo ponemos los metadatos:

frente_html %>%
  str_replace_all("\n[:space:]+", "\n") %>% 
  readr::write_file("argentina_frente-de-todos_fernandez_2019.txt")

# JUNTOS POR EL CAMBIO
# leemos el código html

juntos_html <- read_html("http://pro.com.ar/plataforma-electoral/") %>% 
  html_nodes(".desc") %>% 
  html_text()

# guardamos el texto limpiando previamente el exceso de espacios y saltos de líneas. En el nombre del archivo ponemos los metadatos:

juntos_html %>%
  str_replace_all("([\r\n]+)([:space:]*)", "\n") %>% 
  readr::write_file("argentina_juntos-por-el-cambio_macri_2019.txt")

# URUGUAY

# En este caso los programas están en pdf, así que los convertimos a texto plano usando el paquete {pdftools}

# FRENTE AMPLIO

# descargamos el archivo
download.file("https://frenteamplio.uy/campana/bases-programaticas/download/331/759/34", "pdf/frente-amplio.pdf", mode = "wb")

# convertimos a texto plano
frente_amplio <- pdftools::pdf_text("pdf/frente-amplio.pdf")

# concatenamos las 208 páginas, que quedaron cada una como un elemento dentro del vector de caracteres. Luego limpiamos el texto: removemos pie de página, juntamos palabras separadas por guión, eliminamos espacios extra, etc. Guardamos archivos con metadatos en el nombre

frente_amplio %>%
  str_c(collapse = "\n") %>% 
  str_remove_all("BASES PROGRAMÁTICAS 2020 - 2025[:space:]+[:digit:]+[:space:]") %>%
  str_remove_all("\n[:digit:]+[:space:]+FRENTE AMPLIO\n[:space:]") %>%
  str_remove_all("-\n[:space:]*") %>%
  str_replace_all("\n(?=[:lower:])", " ") %>%
  str_replace_all("\n[:space:]", "\n") %>% 
  str_remove_all("(\\.)(\\.)+[:space:]*[:digit:]+") %>% 
  readr::write_file("uruguay_frente-amplio_martinez_2019.txt")



# PARTIDO NACIONAL

# descargamos el archivo
download.file("http://lacallepou.uy/descargas/programa-de-gobierno.pdf", "pdf/partido-nacional.pdf", mode = "wb")

# convertimos a texto plano
partido_nacional <- pdftools::pdf_text("pdf/partido-nacional.pdf")

# Limpiar y guardar

partido_nacional %>%
  str_c(collapse = "") %>% 
  str_remove_all("IR AL INDICE[:space:]+[:digit:]+") %>%
  str_remove_all("[\t]+") %>% 
  str_replace_all("[:space:]{2,}", "\n") %>%
  str_replace_all("-\n", "") %>% 
  str_replace_all("\n(?=[:lower:])", " ") %>% 
  str_replace_all("\n[:digit:]+\n", "\n") %>% 
  readr::write_file("uruguay_partido-nacional_lacalle-pou_2019.txt")

# PARTIDO COLORADO

# descargamos el archivo
download.file("https://d3n8a8pro7vhmx.cloudfront.net/talvi/pages/77/attachments/original/1561563373/Programa_de_Gobierno_de_Ciudadanos_2020-2025_web_%281%29.pdf?1561563373", "pdf/partido-colorado.pdf", mode = "wb")

# convertimos a texto plano
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

