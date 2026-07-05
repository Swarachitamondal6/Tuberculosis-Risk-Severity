library(readxl)
assignment <- read_excel("data/clinical parameters_TBpatients.xlsx")
library(dplyr)
transformed_data <-assignment %>% select (`Date of Assessment`, everything())
library(writexl)
####

transformed_data <- assignment %>% 
  mutate(`Episode ID` = row_number()) %>% 
  mutate(assessment_delay = as.numeric(as.Date(end) - as.Date(`Date of Assessment`))) %>% 
  select(start = `Date of Assessment`, `Episode ID`, assessment_delay, everything())
mean(transformed_data$assessment_delay, na.rm = TRUE)
#mean delay in assessment = 8.26 days
library(tidyverse)
mean_age <- mean(assignment$`Age`, na.rm = TRUE)
# Mean age =32.27
print(paste("The mean age is:", round(mean_age, 2)))
transformed_data <- assignment %>%
  mutate(`Age` = if_else(is.na(`Age`), mean(`Age`, na.rm = TRUE), `Age`))
transformed_data <- transformed_data %>%
  mutate(`Age` = round(`Age`, 2))
table(assignment$`Current symptoms /Cough`)
round(prop.table(table(assignment$`Current symptoms /Cough`))*100,2)
# percentage of patients who had cough as a symptom=52.08%
district_gender_table <- table(assignment$`District`, assignment$Gender)
print(district_gender_table)
library(ggplot2)
bp <- barplot(t(district_gender_table),
        main = "Patient Distribution by District and Gender",
        xlab = "District",
        ylab = "Number of Patients",
        col = c("#F8766D", "#00BFC4"), # Custom colors for Female and Male
        legend.text = TRUE,             # Automatically adds the Gender legend
        args.legend = list(x = "topright", bty = "n")) # Clean legend placement
#Lucknow has the highest burden of patients. 
#Barabanki has highest burden of male patients and Kanpur has lowest burden of male patients.
#Lucknow has highest burden of female patients and Unnao has lowest burden of female patients.
chart_matrix <- t(district_gender_table)# To get the matrix layout (Rows = Gender, Columns = District)
y_positions <- apply(chart_matrix, 2, function(col) cumsum(col) - (col / 2))
# to add the numeric labels into the center of each stack
text(x = rep(bp, each = nrow(chart_matrix)), 
     y = y_positions, 
     labels = chart_matrix, 
     col = "black",        
     font = 1,            # Makes the text bold
     cex = 0.8)           # Controls text size
shapiro.test(assignment$`Age`)# Age is not normally distributed
#########################################################################################

#Stratify the existing 'No of Abnormal parameters' column into your custom risk tiers
assignment$Risk_Stratification <- ifelse(assignment$`No of Abnormal parameters` == 1, "low-risk",
                                  ifelse(assignment$`No of Abnormal parameters` %in% c(2, 3), "moderate risk",
                                  ifelse(assignment$`No of Abnormal parameters` >= 4, "high risk", 
                                                       "No Abnormal Parameters"))) # Handles patients with 0 abnormal values
##Create the final summary table of counts and percentages
table(assignment$Risk_Stratification)
round(prop.table(table(assignment$Risk_Stratification))*100,2)
##### ALTERNATIVELY
counts <- table(assignment$Risk_Stratification)
final_table <- cbind(
  Count      = counts, 
  Percentage = round(prop.table(counts) * 100, 2)
)
print(final_table)
###########################################################
#Pull the raw column into a temporary variable for clean processing
raw_mo_stratification <- assignment$`Final risk stratification BY THE MEDICAL OFFICER`
#Create the new column with ONLY the clean, short categories
assignment$MO_Stratification <- ifelse(grepl("^low risk", tolower(raw_mo_stratification)), "Low risk",
                                     ifelse(grepl("^moderate risk", tolower(raw_mo_stratification)), "Moderate risk",
                                            ifelse(grepl("^high risk", tolower(raw_mo_stratification)), "High risk", 
                                                   "Not Stratified")))
#Securely sweep up any missing data (NAs) or blank cells into "Not Stratified"
assignment$MO_Stratification[is.na(raw_mo_stratification) | raw_mo_stratification == ""] <- "Not Stratified"
#Generate the cross-tabulation matrix between the two clean variables
cross_tab_matrix <- table(assignment$MO_Stratification, assignment$Risk_Stratification)
print(cross_tab_matrix)
#extract and print just the specific number of mismatched patients
mismatch_count <- cross_tab_matrix["Low risk", "high risk"]
cat("\nNumber of persons in MO Low-risk but parameter High-risk:", mismatch_count, "\n")
#################################################################
#Count the number of abnormal values for each specific variable
abnormal_counts <- c(
  "BMI"               = sum(assignment$BMI == 1, na.rm = TRUE),
  "Haemoglobin"       = sum(assignment$Haemoglobin == 1, na.rm = TRUE),
  "Respiratory Rate"  = sum(assignment$`Respiratory rate` == 1, na.rm = TRUE),
  "Oxygen Saturation" = sum(assignment$`Oxygen saturation` == 1, na.rm = TRUE)
)
#Sort the counts in descending order (highest to lowest)
sorted_counts <- sort(abnormal_counts, decreasing = TRUE)
#Generate the descending column chart 
bar_positions <- barplot(
  sorted_counts,
  main = "Number of Persons with Abnormal Clinical Parameters",
  ylab = "Number of Patients",
  col  = "#2b7bba", 
  las  = 0.9,         # Makes the Y-axis numbers horizontal and easy to read
  ylim = c(0, max(sorted_counts) * 1.15), # Leaves extra room at the top for labels
  cex.names = 0.9 # Slightly adjusts text size for clarity
)
#Place the exact patient count on top of every bar
text(
  x      = bar_positions, 
  y      = sorted_counts, 
  labels = sorted_counts, 
  pos    = 3,          # Position 3 places the text directly above the bar
  cex    = 0.9,        # Font size for the numbers
  col    = "black"     # Text color
)
############################################################################
#Create the subset based on both conditions
male_no_sputum_blood <- subset(
  assignment, 
  Gender == "Male" & `Blood in sputum` == 0
)
################################################################
names(assignment) <- trimws(names(assignment))
clinical_parameters <- c(
  "Pulse rate", "Temperature", "Systolic BP", "Diastolic BP", 
  "Respiratory rate", "Oxygen saturation", "BMI", "cal_MUAC", 
  "Paedal ordema", "Jaundice", "Haemoglobin", "WBC", "RBS", 
  "HIV", "Chest X-ray"
)
#Number of patients having abnormality in each parameter
abnormality_counts <- sapply(clinical_parameters, function(param) {
  sum(assignment[[param]] == 1, na.rm = TRUE)
})
#in descending order
sorted_abnormalities <- sort(abnormality_counts, decreasing = TRUE)
abnormality_table <- data.frame(
  Parameter = names(sorted_abnormalities),
  Abnormal_Count = as.numeric(sorted_abnormalities)
)
print.data.frame(abnormality_table)
###############################################
#Patients recommended for admission and their average abormality count
admitted_patients <- subset(assignment, `Patient recommended for admission?` == "Yes")
total_admitted <- nrow(admitted_patients)
avg_abnormal <- mean(admitted_patients$`No of Abnormal parameters`, na.rm = TRUE)
cat("Number of patients recommended for admission:", total_admitted, "\n")
cat("Average abnormal parameters for these patients:", round(avg_abnormal, 2), "\n")
##########################################################
#Age range
age_range <- range(assignment$Age, na.rm = TRUE)
cat("--- AGE PROFILE ---\n")
cat("Youngest Patient:", age_range[1], "years old\n")
cat("Oldest Patient  :", age_range[2], "years old\n\n")
cat("Detailed Age Summary:\n")
print(summary(assignment$Age))
cat("\n")
#box plot of age
age_stats <- summary(transformed_data$Age)
min_val   <- age_stats["Min."]
q1        <- age_stats["1st Qu."]
median_val<- age_stats["Median"]
q3        <- age_stats["3rd Qu."]
max_val   <- age_stats["Max."]
boxplot(
  transformed_data$Age,
  horizontal = TRUE,
  main = "Box Plot of Patient Age Distribution",
  xlab = "Age (Years)",
  col  = "#2b7bba",        # Clinical blue color matching previous plots
  border = "black",
  lwd    = 1.5,
  ylim   = c(0, 90)        # Leaves side padding for label visibility
)
text(x = min_val,    y = 1.25, labels = paste("Min\n", min_val),    adj = 0.5, font = 1, col = "black")
text(x = q1,         y = 0.75, labels = paste("Q1\n", q1),         adj = 0.5, font = 1, col = "blue")
text(x = median_val, y = 1.25, labels = paste("Median\n", median_val), adj = 0.5, font = 1, col = "red")
text(x = q3,         y = 0.75, labels = paste("Q3\n", q3),         adj = 0.5, font = 1, col = "blue")
text(x = max_val,    y = 1.25, labels = paste("Max\n", max_val),    adj = 0.5, font = 1, col = "black")
#Gender
cat("--- GENDER COUNTS ---\n")
gender_table <- table(assignment$Gender)
round(prop.table(gender_table <- table(assignment$Gender))*100,2)
print(gender_table)
#####################################


