#####################################BAr Chart#################################
library(ggplot2)

ggplot(df, aes(x = Value, y = Period)) +
  geom_col() +
  labs(
    title = "Number of Patients by District",
    x = "District",
    y = "Number of Patients"
  )


#################Grouped Bar cHarts########################################3####
ggplot(df, aes(x = Value, y = Period, fill = Sex)) +
  geom_col(position = "dodge")


#####################Stacked Bar Chart#########################################
ggplot(df, aes(x = District, y = Number, fill = Sex)) +
  geom_col()


##########################Pie/ Donut chart#####################################
ggplot(data, aes(x = "", y = Number, fill = Sex)) +
  geom_col(width = 1) +
  coord_polar("y")


############################Line Graph#########################################
ggplot(df, aes(x = Period, y = Value, group = District, colour = Organisation)) +
  geom_line() +
  geom_point()

##########################Heat MAps############################################
ggplot(data, aes(x = Month, y = District, fill = Cases)) +
  geom_tile()

########################Scatter Plot###################################
ggplot(df, aes(x = Period, y = Value)) +
  geom_point()+  geom_smooth(method = "lm")

########################Box Plot##########################
ggplot(df, aes(x = Period, y = Value)) +
  geom_boxplot()


#########################Faceted Charts##########################
ggplot(data, aes(x = District, y = Cases, fill = Sex)) +
  geom_col() +
  facet_wrap(~ Age_group)


#########################Pivot Table#######################
library(dplyr)

summary_data <- raw_data %>%
  group_by(District, Sex) %>%
  summarise(
    Cases = sum(Cases, na.rm = TRUE)
  )
