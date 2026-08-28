
######################CALLING DATA ONE VARIABLE#######################################################3
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
dx_ids <- c("tgkH6h8gsWk", "DuMMAbvDfjn", "hqGqG3XbnJm")

resp <- req %>%
  req_url_path_append("analytics.json")%>%
  req_url_query(
    dimension = c(
      paste0("dx:", paste(dx_ids, collapse = ";")),
      "pe:202501;202502;202503;202504;202505;202506;202507;202512",
      "ou:cpR3goPseRq"
    ),
    .multi = "explode"
  ) |>
  req_perform()

data <- resp_body_json(resp, simplifyVector = TRUE)

df <- as.data.frame(data$rows, stringsAsFactors = FALSE)
names(df) <- data$headers$column

# UID -> name lookup, vectorized, with UID fallback if missing
item_names <- vapply(data$metaData$items, `[[`, character(1), "name")
lookup <- function(uid) ifelse(uid %in% names(item_names), item_names[uid], uid)

df$Data <- lookup(df$Data)
df$`Organisation unit` <- lookup(df$`Organisation unit`)

df

###########################RE PIVOTING ###################################

library(tidyr)
library(dplyr)

# Long format (this is what get_analytics() returns) has columns like:
# Data | Period | Organisation unit | Value

# --- Pivot A: Indicators as columns, Periods as rows ---
pivot_dates_as_rows <- function(df) {
  df %>%
    select(Data, Period, Value) %>%
    pivot_wider(names_from = Data, values_from = Value) %>%
    arrange(Period)
}

# --- Pivot B: Periods as columns, Indicators as rows ---
pivot_dates_as_columns <- function(df) {
  df |>
    select(Data, Period, Value) |>
    pivot_wider(names_from = Period, values_from = Value) |>
    arrange(Data)
}

result <- pivot_dates_as_rows(df)
result          # print it, or just remove the assignment:

pivot_dates_as_rows(df)   # this alone will print in an interactive session

###############################################################################




library(tidyr)
library(dplyr)

dx_ids <- c("tgkH6h8gsWk", "DuMMAbvDfjn", "hqGqG3XbnJm")

resp <- req |>
  req_url_path_append("analytics.json") |>
  req_url_query(
    dimension = c(
      paste0("dx:", paste(dx_ids, collapse = ";")),
      "pe:202501;202502;202503;202504;202505;202506;202507;202512",
      "ou:cpR3goPseRq"
    ),
    .multi = "explode"
  ) |>
  req_perform()

data <- resp_body_json(resp, simplifyVector = TRUE)

df <- as.data.frame(data$rows, stringsAsFactors = FALSE)
names(df) <- data$headers$column

# --- UID -> name lookup (metaData$items collapses to a data.frame under simplifyVector) ---
items      <- data$metaData$items
item_names <- setNames(items$name, rownames(items))
lookup     <- function(uid) ifelse(uid %in% names(item_names), item_names[uid], uid)

df$Data                 <- lookup(df$Data)
df$`Organisation unit`  <- lookup(df$`Organisation unit`)
df$Period               <- lookup(df$Period)   # e.g. "202501" -> "January 2025"
df$Value                <- as.numeric(df$Value) # API returns Value as character

# df is already "long" format: one row per Data x Period x Org unit x Value

# --- long -> wide: periods become columns, one row per Data/Org unit ---
df_wide <- df |>
  pivot_wider(
    id_cols     = c(Data, `Organisation unit`),
    names_from  = Period,
    values_from = Value
  )

# --- wide -> long: back to tidy/long format (e.g. for plotting) ---
df_long <- df_wide |>
  pivot_longer(
    cols      = -c(Data, `Organisation unit`),
    names_to  = "Period",
    values_to = "Value"
  )

df_wide
df_long



#######################################################################################

library(tidyr)
library(dplyr)

dx_ids <- c("tgkH6h8gsWk", "DuMMAbvDfjn", "hqGqG3XbnJm")

resp <- req |>
  req_url_path_append("analytics.json") |>
  req_url_query(
    dimension = c(
      paste0("dx:", paste(dx_ids, collapse = ";")),
      "pe:202501;202502;202503;202504;202505;202506;202507;202512",
      "ou:cpR3goPseRq"
    ),
    .multi = "explode"
  ) |>
  req_perform()

data <- resp_body_json(resp, simplifyVector = TRUE)

df <- as.data.frame(data$rows, stringsAsFactors = FALSE)
names(df) <- data$headers$column

# one lookup table: uid -> name
meta <- data$metaData$items
name_of <- setNames(meta$name, rownames(meta))

df <- df |>
  mutate(
    Data = name_of[Data],
    `Organisation unit` = name_of[`Organisation unit`],
    Period = name_of[Period],
    Value = as.numeric(Value)
  )

# long -> wide (periods as columns)
df_wide <- df |> pivot_wider(names_from = Period, values_from = Value)

# wide -> long (back to tidy)
df_long <- df_wide |> pivot_longer(-c(Data, `Organisation unit`), names_to = "Period", values_to = "Value")

df_wide
df_long



########################################################################



library(tidyr)
library(dplyr)

dx_ids <- c("tgkH6h8gsWk", "DuMMAbvDfjn", "hqGqG3XbnJm")

resp <- req |>
  req_url_path_append("analytics.json") |>
  req_url_query(
    dimension = c(
      paste0("dx:", paste(dx_ids, collapse = ";")),
      "pe:202501;202502;202503;202504;202505;202506;202507;202512",
      "ou:cpR3goPseRq"
    ),
    .multi = "explode"
  ) |>
  req_perform()

data <- resp_body_json(resp, simplifyVector = TRUE)

df <- as.data.frame(data$rows, stringsAsFactors = FALSE)

# DIAGNOSTIC: see what the API actually gave you before assuming names
print(data$headers$column)   # <- check this matches "Data","Period","Organisation unit","Value"
print(ncol(df))              # <- check this equals length(data$headers$column)

names(df) <- data$headers$column
print(names(df))             # <- confirm df's real column names now