
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
