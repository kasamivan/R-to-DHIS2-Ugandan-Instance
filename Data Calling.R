
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

