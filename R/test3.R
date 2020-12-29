
# Read in the final data from the final data folder
check3_data <- source_data %>% #source_data defined in initiate.R
  mutate(value_start = as.numeric(value_start),
         value_end = as.numeric(value_end))



check3_data[1,10]<- NA # value_start example
check3_data[5,11]<- 0.5 # value_end example
check3_data[2,2]<- NA # country_id example
check3_data[8,4]<- NA # year example
check3_data[9,3]<- 2019 # year_range start bigger than year
check3_data[10,3] <- 2010 # year range= year
check3_data[19,8] <- 35 # bad source id
check3_data[17,5] <- 2 # monthly period w quarter
check3_data[17,6] <- 7 # monthly period w quarter
check3_data[25,5] <- 7 # period bad



bad_values <- check3_data %>% 
  mutate(problem = case_when(
    
    # check the year columns
    is.na(value_start) ~ 'value_start has missing values',
    value_start - value_end > 0 ~ 'value_end is before value_start',
    year == year_range_start ~ 'year_range_start and year are the same',
    year_range_start > 9999 ~ 'year_range_start includes a year span or is longer than 4 digits',
    year>9999 ~ 'year includes a year span or is longer than 4 digits',
    year != round(year, digits = 0) ~ 'year is not an integer',
    year_range_start != round(year_range_start, digits = 0) ~ 'year_range_start is not an integer',
    
    # check the country column
    is.na(country_id) ~ 'country_id has missing values',
    
    # check the series column
    is.na(series_id) ~ 'series_id has missing values',
    
    # check the source column
    is.na(source_id) ~ 'source_id is missing',
    source_id != num_source ~ 'source_id is incorrect',
    
    # check the survey column
    survey_id < 1 & !is.na(survey_id) ~ 'survey_id is not valid',
    
    # check the periodicity
    periodicity_id == 1 & !is.na(quarter) ~ 'annual data cannot have a quarter',
    periodicity_id == 1 & !is.na(month) ~ 'annual data cannot have a month',
    periodicity_id == 2 & !quarter %in% c(1, 2, 3 ,4)  ~ 'quarterly data does not have correct quarter',
    periodicity_id == 2 & !is.na(month) ~ 'quarterly data cannot have a month',
    periodicity_id == 3 & !month %in% c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)  ~ 'monthly data does not have correct month',
    periodicity_id == 3 & !is.na(quarter) ~ 'monthly data should not have a quarter',
    !periodicity_id %in% c(1, 2, 3) ~ 'periodicity_id is not valid - must be 1, 2, or 3',
    
    TRUE ~ '' ) ) %>%  # keep the rest of the conditions blank
  filter(problem != '')


# Keep only the problem oberservations
# bad_values2 <- bad_values2 %>% 
#   filter(problem != '')

# What's the year range in the data?
check3a <- if (dim(bad_values %>% filter(n()>1))[[1]]>0){
  print(paste("Missing or bad values in ", source_name,".", " You need to fix something.", sep = ''))
} else {
  print("No bad or missing key values. CHECK 3 PASSES")
}

#check3 <- knitr::kable(bad_values, caption = check3a)


check3 <- if (dim(duplicates %>% group_by(country_id, series_id, year) %>% filter(n()>1))[[1]]>0){
  knitr::kable(bad_values, caption = check3a)
} else {
  check3a
}


