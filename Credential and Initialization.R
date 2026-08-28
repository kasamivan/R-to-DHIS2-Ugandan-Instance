install.packages(c("httr2", "jsonlite", "dplyr", "writexl", "tidyr", "ggplot2"))
library(httr2)
library(jsonlite)
library(writexl)
library(dplyr)
library(tidyr)
library(ggplot2)

Sys.setenv(DHIS2_USER = "xxxxxxxx")
Sys.setenv(DHIS2_PASS = "xxxxxxxxx")




##################CREDENTIALS################################


base_url <- "https://hmis.health.go.ug/api"


req <- request(base_url) |>
  req_auth_basic(Sys.getenv("DHIS2_USER"), Sys.getenv("DHIS2_PASS"))


resp <- req |>
  req_url_path_append("me.json") |>
  req_perform()

resp_body_json(resp)

