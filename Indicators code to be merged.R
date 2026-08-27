library(httr2)
library(jsonlite)

resp <- request("https://hmis.health.go.ug/api/dataElements") |>
  req_url_query(
    fields = "id,name,displayName,shortName,code",
    paging = "false"
  ) |>
  req_perform()

data <- resp_body_json(resp, simplifyVector = TRUE)

dx_uganda <- as.data.frame(data$dataElements)

#####################################

resp <- request("https://hmis.health.go.ug/api/dataElements") |>
  req_url_query(
    fields = "id,name,displayName,shortName,code",
    paging = "false"
  ) |>
  req_perform()

resp_status(resp)
resp_headers(resp)[["content-type"]]

#################################################

cat(substr(resp_body_string(resp), 1, 1000))
#######################################################


library(httr2)

resp <- request("https://hmis.health.go.ug/api/dataElements") |>
  req_auth_basic(
    username = "biostat.bunyangabu",
    password = "Records@2034"
  ) |>
  req_url_query(
    fields = "id,name,displayName,shortName,code",
    paging = "false"
  ) |>
  req_perform()

resp_status(resp)
resp_headers(resp)[["content-type"]]

###############################
data <- resp_body_json(resp, simplifyVector = TRUE)

dx_uganda <- as.data.frame(data$dataElements)

head(dx_uganda)

write_xlsx(dx_uganda, "indicator_lookup.xlsx")
write_xlsx(dx_uganda, "C:/Users/USER/Desktop/R excel output/indicator_lookup.xlsx")


#############################################################


```
items[["eH41w0o5oXd"]]$name
[1] "033B-GP06. No. of GeneXpert modules working"
```
