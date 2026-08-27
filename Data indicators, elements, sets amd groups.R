
#📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉
#📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉
#📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉📉
#######################DEFINING ALL DU CODES WITHOUT DHIS2 NAMES##########################################

resp <- req |>
  req_url_path_append("indicators.json") |>
  req_url_query(
    fields = "id,name",
    paging = "false"
  ) |>
  req_perform()

indicators <- resp_body_json(resp, simplifyVector = TRUE)$indicators
dx_uids <- indicators$id

print(dx_uids)
############################DEFINING ALL DU CODES WITH DHIS2 NAMES###########################################
resp <- req |>
  req_url_path_append("indicators.json") |>
  req_url_query(
    fields = "id,name",
    paging = "false"
  ) |>
  req_perform()

indicators <- resp_body_json(resp, simplifyVector = TRUE)$indicators

# Keep both columns — this is your lookup table
head(indicators)   # shows id AND name together
nrow(indicators)    # how many indicators total

View(indicators)
write_xlsx(indicators, "indicators_lookup.xlsx")
write_xlsx(indicators, "C:/Users/USER/Desktop/R excel output/indicators_lookup.xlsx")


############################INDICATOR GROUPS #######################################
resp <- req |>
  req_url_path_append("indicatorGroups.json") |>
  req_url_query(
    fields = "id,name",
    paging = "false"
  ) |>
  req_perform()

groups <- resp_body_json(resp, simplifyVector = TRUE)$indicatorGroups
groups  # browse names to find the one(s) you want, e.g. "HMIS", "Malaria", "EPI"
View(groups)
#######################Using groups in DHIS2 (CALLING A SPECIFIC GRE#####################################################
resp <- req |>
  req_url_path_append(paste0("indicatorGroups/", "EIMCvHUfYcd", ".json")) |>
  req_url_query(fields = "indicators[id,name]") |>
  req_perform()

group_data <- resp_body_json(resp, simplifyVector = TRUE)
dx_lookup <- group_data$indicators   # data frame: id, name

View(dx_lookup)
##########################Merging the groups#####################################################
resp <- req |>
  req_url_path_append("analytics.json") |>
  req_url_query(
    dimension = c(paste0("dx:", paste(dx_lookup$id, collapse = ";")),
                  "pe:2025",
                  "ou:akV6429SUqu"),
    .multi = "explode"
  ) |>
  req_perform()

data <- resp_body_json(resp, simplifyVector = TRUE)
df <- as.data.frame(data$rows, stringsAsFactors = FALSE)
colnames(df) <- data$headers$column

# join in readable indicator names
df <- merge(df, dx_lookup, by.x = "Data", by.y = "id", all.x = TRUE)
names(df)[names(df) == "name"] <- "Indicator Name"

# org unit name via metaData$items (only one OU here, so this is simple)
items <- data$metaData$items
df$`Organisation unit` <- items[[df$`Organisation unit`[1]]]$name

df

items[["eH41w0o5oXd"]]$name
