##################SETTING UP#############################



###############ERROR CODES##################################
#  | Error   | Meaning      | Simple interpretation                                            |
#  | ------- | ------------ | ---------------------------------------------------------------- |
#  | **401** | Unauthorized | "I don't know/authenticate you."                                 |
#  | **403** | Forbidden    | "I know who you are, but you're not allowed to do this."         |
#  | **404** | Not Found    | "I can't find what you're requesting."                           |
#  | **409** | Conflict     | "Your request conflicts with something about the query/request." |
#  | **500** | Server Error | "Something went wrong on the server."  
# 👈👉👆👇👍🏾🫶🫵🏼☝️|
##################################################* 


install.packages(c("httr2", "jsonlite", "dplyr", "writexl"))
library(httr2)
library(jsonlite)
library(writexl)
library(dplyr)

Sys.setenv(DHIS2_USER = "biostat.bunyangabu")
Sys.setenv(DHIS2_PASS = "Records@2034")




##################CREDENTIALS################################


base_url <- "https://hmis.health.go.ug/api"


req <- request(base_url) |>
  req_auth_basic(Sys.getenv("DHIS2_USER"), Sys.getenv("DHIS2_PASS"))


resp <- req |>
  req_url_path_append("me.json") |>
  req_perform()

resp_body_json(resp)










######################CALLING DATA#######################################################3
resp <- req |>
  req_url_path_append("analytics.json") |>
  req_url_query(
    dimension = c("dx:tgkH6h8gsWk", "pe:202512", "ou:iTfbtn6JUsN"),
    .multi = "explode"
  ) |>
  req_perform()

data <- resp_body_json(resp, simplifyVector = TRUE)

df <- as.data.frame(data$rows, stringsAsFactors = FALSE)
colnames(df) <- data$headers$column

# metaData$items is a named list: UID -> list(name = "...")
items <- data$metaData$items

# helper to look up the readable name for a UID
uid_to_name <- function(uid) {
  vapply(uid, function(x) {
    if (!is.null(items[[x]]) && !is.null(items[[x]]$name)) {
      items[[x]]$name
    } else {
      x  # fallback to the UID if no name found
    }
  }, character(1))
}

df$Data <- uid_to_name(df$Data)
df$`Organisation unit` <- uid_to_name(df$`Organisation unit`)

df

################# List all the indicator UIDs you want here############################
dx_ids <- c(
  "tgkH6h8gsWk",
  "DuMMAbvDfjn",
  "hqGqG3XbnJm"
  # add as many more indicator UIDs as you need
)

resp <- req |>
  req_url_path_append("analytics.json") |>
  req_url_query(
    dimension = c(
      paste0("dx:", paste(dx_ids, collapse = ";")),  # multiple indicators, semicolon-joined
      "pe:202501;202502;202503;202504;202505;202506;202507;202508;202509;202510;202511;202512",
      "ou:cpR3goPseRq"
    ),
    .multi = "explode"
  ) |>
  req_perform()

data <- resp_body_json(resp, simplifyVector = TRUE)
df <- as.data.frame(data$rows, stringsAsFactors = FALSE)
colnames(df) <- data$headers$column

# metaData$items is a named list: UID -> list(name = "...")
items <- data$metaData$items

# helper to look up the readable name for a UID
uid_to_name <- function(uid) {
  vapply(uid, function(x) {
    if (!is.null(items[[x]]) && !is.null(items[[x]]$name)) {
      items[[x]]$name
    } else {
      x  # fallback to the UID if no name found
    }
  }, character(1))
}

df$Data <- uid_to_name(df$Data)
df$`Organisation unit` <- uid_to_name(df$`Organisation unit`)
df

















###########################################

items[["Oc2o5T4ys2b"]]$name




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

# 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺
# 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺
# 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️ 🗺️
##################DEFINING THE OU CODE#########################################

resp <- req |>
  req_url_path_append("organisationUnits.json") |>
  req_url_query(
    filter = "name:like:Bunyangabu",
    fields = "id,name,level,parent[name]"
  ) |>
  req_perform()

resp_body_json(resp, simplifyVector = TRUE)$organisationUnits

#👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇OUTPUT👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇
#  | # | name                | name                | id          | level |
#  | - | ------------------- | ------------------- | ----------- | ----- |
#  | 1 | Bunyangabu DLG      | Bunyangabu District | ARrKg065SFL | 4     |
#  | 2 | Bunyangabu District | Tooro               | iTfbtn6JUsN | 3     |
#  
#👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆



################################SELECT THE OR LEVEL DESIRES IN HEIRACHAL ORDER#################################################
resp <- req |>
  req_url_path_append("organisationUnitLevels.json") |>
  req_url_query(fields = "id,name,level", paging = "false") |>
  req_perform()

levels <- resp_body_json(resp, simplifyVector = TRUE)$organisationUnitLevels
levels

#👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇OUTPUT👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇
#  | Name                             | Level | ID          |
#  | -------------------------------- | ----: | ----------- |
#  | National                         |     1 | Qwwy9GM6dFu |
#  | Region                           |     2 | CfnWgqkxbyg |
#  | District/City                    |     3 | iITwmH31lPe |
#  | DLG/Municipality/City Council    |     4 | NGXlJhHTDdV |
#  | Sub County/Town Council/Division |     5 | Sg9YZ6o7bCQ |
#  | Health Facility                  |     6 | APR575taREB |
#  | Ward/Department                  |     7 | xVsDiHsvVTq |
#👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆  

########################### CHANGE THE LEVEL CODE TO GET THE HEIRACHL LEVEL YOU DESIRE#######################################################
resp <- req |>
  req_url_path_append("organisationUnits.json") |>
  req_url_query(
    filter = "level:eq:6",   #👈👈👈👈👈👈👈👈👈👈👈👈👈 change 3 to whichever level you want
    fields = "id,name,level,parent[name]",
    paging = "false"
  ) |>
  req_perform()

districts_or_facilities <- resp_body_json(resp, simplifyVector = TRUE)$organisationUnits

################################GETTING OU CODES FOR DISTRICTS################################################3
resp <- req |>
  req_url_path_append("organisationUnits.json") |>
  req_url_query(
    fields = "id,name,level,parent[id,name],ancestors[id,name,level]",
    paging = "false"
  ) |>
  req_perform()

org_units <- resp_body_json(resp, simplifyVector = TRUE)$organisationUnits

# Helper: pull out the ancestor at a given level (e.g. District = level 2)
get_ancestor_name <- function(ancestors_list, target_level) {
  if (is.null(ancestors_list) || length(ancestors_list) == 0) return(NA_character_)
  match_row <- ancestors_list[ancestors_list$level == target_level, ]
  if (nrow(match_row) == 0) return(NA_character_)
  match_row$name[1]
}

# Change 2 to whichever level number your Step 1 output showed for "District"
org_units$District <- vapply(
  org_units$ancestors,
  get_ancestor_name,
  target_level = 3,
  FUN.VALUE = character(1)
)

nrow(org_units)
View(org_units)


org_units_Bunyangabu <- org_units |>
  select(id, name, level, District)   # keep only flat columns; add Region here too if you created it


View(org_units_Bunyangabu)
write_xlsx(org_units_Bunyangabu, "org_units_lookup.xlsx")




write_xlsx(org_units_Bunyangabu, "org_lookup.xlsx")
write_xlsx(org_units_Bunyangabu, "C:/Users/USER/Desktop/R excel output/org_units_Bunyangabu.xlsx")

########################ORG UNITS WITH PARENT ID######################
resp <- req |>
  req_url_path_append("organisationUnits.json") |>
  req_url_query(
    fields = "id,name,level,parent[id,name]",
    paging = "false"
  ) |>
  req_perform()

org_units <- resp_body_json(resp, simplifyVector = TRUE)$organisationUnits
nrow(org_units)
View(org_units)



#📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅
#📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅📅

################################################################################
#  | Type      | Format     | Example       | Meaning            |
#  | --------- | ---------- | ------------- | ------------------ |
#  | Yearly    | `YYYY`     | `pe:2025`     | Calendar year 2025 |
#  | Quarterly | `YYYYQn`   | `pe:2025Q4`   | Q4 2025 (Oct–Dec)  |
#  | Monthly   | `YYYYMM`   | `pe:202512`   | December 2025      |
#  | Weekly    | `YYYYWn`   | `pe:2025W48`  | Week 48 of 2025    |
#  | Daily     | `YYYYMMDD` | `pe:20251225` | 25 Dec 2025        |
################################################################################

#👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇OUTPUT👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇
"pe:THIS_YEAR"
"pe:LAST_YEAR"
"pe:THIS_QUARTER"
"pe:LAST_QUARTER"
"pe:THIS_MONTH"
"pe:LAST_MONTH"
"pe:LAST_12_MONTHS"
"pe:LAST_4_QUARTERS"
"pe:LAST_5_YEARS"
"pe:THIS_WEEK"
"pe:LAST_WEEK"
"pe:LAST_4_WEEKS"
"pe:TODAY"           # daily
"pe:YESTERDAY"
"pe:LAST_7_DAYS"
"pe:LAST_14_DAYS"
"pe:LAST_30_DAYS"
#👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆



#############################DAILY PERIODS######################################

"pe:202501;202502;202503;202504;202505;202506;202507;202508;202509;202510;202511;202512"

################################################################################


















