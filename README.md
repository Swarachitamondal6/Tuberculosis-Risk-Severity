# Clinical Profiling and Risk Stratification of Tuberculosis Patients in Uttar Pradesh

## Project Overview
[cite_start]This project provides a comprehensive clinical and epidemiological analysis of 605 Tuberculosis (TB) patients across four districts of Uttar Pradesh: Barabanki, Kanpur, Lucknow, and Unnao[cite: 1, 13]. The study explores patient demographics, symptom variations, objective clinical abnormalities, and the alignment between objective statistical risk strata and actual clinical triaging decisions made by medical professionals.

## Key Dataset Insights
* [cite_start]**Demographic Profile:** The cohort consists of 330 (54.55%) females and 275 (45.45%) males[cite: 1]. [cite_start]The patient population is notably young, with a mean age of 32.27 years and a median age of 28 years[cite: 4].
* [cite_start]**Operational Delays:** The data reveals an average clinical assessment delay of 8.26 days between the initiation and end dates of patient evaluations[cite: 7, 8].
* [cite_start]**Symptom Heterogeneity:** Atypical presentation is highly common; while 351 (58.02%) patients presented with a cough, 254 (41.98%) did not report cough as a symptom[cite: 10].
* [cite_start]**Prevalence of Clinical Abnormalities:** Across 15 tracked parameters, the most frequent clinical flags were abnormal BMI (352 patients) and abnormal Chest X-rays (322 patients)[cite: 37]. 
* [cite_start]**Risk Stratification Mismatch:** Objective stratification based on the number of abnormal parameters categorized 226 patients (37.36%) as high-risk (4 or more abnormalities)[cite: 19, 23]. [cite_start]However, treating medical officers classified 185 of these objectively high-risk individuals as low-risk in practice[cite: 25].
* [cite_start]**Hospital Admissions:** Only 12 out of 605 patients were recommended for hospital admission, presenting with a severe clinical composite and an average of 4.33 abnormal parameters[cite: 38, 39].

## Statistical Analyses Conducted
* [cite_start]**Normality Testing:** A Shapiro-Wilk normality test confirms that age is not normally distributed in this data cohort (W = 0.944, p-value < 0.001)[cite: 17].

## File Structure
* `clinical_parameters_TBpatients.csv`: Cleaned dataset containing patient demographics, clinical symptoms, and abnormality counts.
* `analysis_script.R`: R script containing the code for the descriptive statistics, visualizations (boxplots, stacked bar graphs and column charts).
* `README.md`: Project documentation.

## Technologies Used
* **Language:** R (Base graphics, stats package)
* **Methodologies:** Biostatistics, Clinical Epidemiology, Risk Stratification, Data Visualization# Tuberculosis-Risk-Severity
Tuberculosis project in four districts of Uttar Pradesh
