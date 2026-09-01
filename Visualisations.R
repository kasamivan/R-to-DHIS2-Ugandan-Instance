#####################################BAr Chart#################################


ggplot(df, aes(x = Period, y = Value)) +
  geom_col() +
  labs(
    title = "Number of Patients by District",
    x = "Peiod",
    y = "Number of Patients"
  )


#Use when:
"
You have a categorical/discrete variable on the X-axis.
You want to compare amounts/counts across categories.
Your Y variable is already a calculated value.

Example question:
  
  How many patients were recorded in each month?
  
  Good for:
  District, Sex, Age group, Period, Facility, etc.

⚠️ If you are comparing continuous numerical measurements, a histogram is usually better"


#################Grouped Bar cHarts########################################3####
ggplot(df, aes(x = Period, y = Value, fill = Sex)) +
  geom_col(position = "dodge")
#
"Use when:

You have one categorical variable on X.
You have a second categorical variable you want to compare within each X category.
You want the groups side-by-side.

Example:
  
  Compare male and female patients in each month.

Month	Male	Female
Jan	100	120
Feb	150	130
Mar	180	160

The grouped chart lets you easily compare Male vs Female within each month.

Think:
  👉 I want to compare groups side by side."

#####################Stacked Bar Chart#########################################
ggplot(df, aes(x = Period, y = Value, fill = Sex)) +
  geom_col()
#
"Use when:

You want to show the total for each category.
You also want to show how that total is composed of subgroups.

For example:
  
  What is the total number of patients each month, and how much of the total were male vs female?
  
  Think:
  
  Total + composition

Grouped bar → compare groups
Stacked bar → compare total and composition "

##########################Pie/ Donut chart#####################################
ggplot(data, aes(x = "", y = Value, fill = Sex)) +
  geom_col(width = 1) +
  coord_polar("y")
#
"Use when:

You have one total.
You want to show the proportion/percentage of categories making up that total.
Usually only a small number of categories.

Example:

What percentage of patients were male vs female?

If:

Male = 400
Female = 600

You can show:

Male = 40%
Female = 60%

Avoid pie charts when:

You have many categories.
The differences between categories are small.
You need precise comparisons.

A bar chart is usually better for analytical work."

############################Line Graph#########################################
ggplot(df, aes(x = Period, y = Value, group = Sex, colour = `Organisation unit`)) +
  geom_line() +
  geom_point()
#
"Use when:

Your X variable represents time.
You want to show a trend over time.
You may want to compare trends between groups.

For example:

How did the number of male and female patients change from January to December?

This is particularly useful for DHIS2 monthly/quarterly surveillance data.

Think:

Time → trend → line graph"

##########################Heat MAps############################################
ggplot(df, aes(x = Period, y = Value, fill = Sex)) +
  geom_tile()

ggplot(df, aes(x = Period,
               y = `Organisation unit`,
               fill = Value)) +
  geom_tile()

#
"A heatmap generally requires two categorical dimensions and a numeric value represented by colour

Use when:

You have two dimensions you want to cross.
You have a numerical value for every combination.
Colour intensity can communicate the magnitude.

Example:

Which districts had the highest number of malaria cases in each month?

	Jan	Feb	Mar
Kampala	500	700	600
Wakiso	300	450	400
Mukono	100	150	200

The heatmap makes high/low values visually obvious.

Think:

Two dimensions + numeric intensity → heatmap"

########################Scatter Plot###################################
ggplot(df, aes(x = Period, y = Value)) +
  geom_point()+  geom_smooth(method = "lm")

#
"Scatter plots are used when you have:

Numeric variable X
Numeric variable Y

and want to examine their relationship."

########################Box Plot##########################
ggplot(df, aes(x = Period, y = Value)) +
  geom_boxplot()
#
"Use when:

X = categorical variable.
Y = continuous/numeric variable.
You want to examine the distribution of the numeric variable across groups.

A box plot shows:

Median
Lower quartile
Upper quartile
Spread/IQR
Potential outliers"

#########################Faceted Charts##########################
ggplot(df, aes(x = Period, y = Value, fill = Sex)) +
  geom_col() +
  facet_wrap()
#
"Use when:

You have a variable with several categories.
You want the same graph repeated separately for each category

Think:

Same analysis, many groups → facets

This is very useful when a single graph becomes overcrowded.
"

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

#
"

This isn't really a visualisation. It is data aggregation/summarisation
Use when:

Your raw dataset has multiple records that need to be combined.
You want totals by combinations of variables.
You want to prepare data for a graph or reporting table
"
