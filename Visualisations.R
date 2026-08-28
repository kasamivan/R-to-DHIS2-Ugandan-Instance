#####################################BAr Chart#################################


ggplot(df, aes(x = Period, y = Value)) +
  geom_col() +
  labs(
    title = "Number of Patients by District",
    x = "Peiod",
    y = "Number of Patients"
  )


#################Grouped Bar cHarts########################################3####
ggplot(df, aes(x = Period, y = Value, fill = Sex)) +
  geom_col(position = "dodge")


#####################Stacked Bar Chart#########################################
ggplot(df, aes(x = Period, y = Value, fill = Sex)) +
  geom_col()


##########################Pie/ Donut chart#####################################
ggplot(data, aes(x = "", y = Value, fill = Sex)) +
  geom_col(width = 1) +
  coord_polar("y")


############################Line Graph#########################################
ggplot(df, aes(x = Period, y = Value, group = Sex, colour = `Organisation unit`)) +
  geom_line() +
  geom_point()

##########################Heat MAps############################################
ggplot(df, aes(x = Period, y = Value, fill = Sex)) +
  geom_tile()

########################Scatter Plot###################################
ggplot(df, aes(x = Period, y = Value)) +
  geom_point()+  geom_smooth(method = "lm")

########################Box Plot##########################
ggplot(df, aes(x = Period, y = Value)) +
  geom_boxplot()


#########################Faceted Charts##########################
ggplot(df, aes(x = Period, y = Value, fill = Sex)) +
  geom_col() +
  facet_wrap()


#########################Pivot Table#######################
library(dplyr)

summary_data <- df %>%
  group_by(Value, Sex) %>%
  summarise(
    Cases = sum(Cases, na.rm = TRUE)
  )

summary_data <- df %>%
  mutate(Value = as.numeric(Value)) %>%
  group_by(Data, Period, Sex) %>%
  summarise(Value = sum(Value, na.rm = TRUE), .groups = "drop")
summary_data <- summary_data %>%
  bind_rows(summarise(summary_data, Data = "Total", Sex = "", Value = sum(Value))
  )

period_totals <- summary_data %>%
  group_by(Data, Period) %>%
  summarise(Sex = "Total", Value = sum(Value), .groups = "drop")
