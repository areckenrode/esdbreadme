
duplicates <- source_data %>% #source_data defined in initiate.R
  group_by(country_id, series_id, year) %>% 
  filter(n()>1) %>% 
  arrange(country_id, series_id, year)

# What's the year range in the data?
check2a <- if (dim(duplicates %>% group_by(country_id, series_id, year) %>% filter(n()>1))[[1]]>0){
   print(paste("There are duplicate values in", source_name,".", "You need to fix something.", sep = ' '))
  } else {
    print("There are no duplicates! CHECK 2 PASSES")
  }

check2 <- if (dim(duplicates %>% group_by(country_id, series_id, year) %>% filter(n()>1))[[1]]>0){
  knitr::kable(duplicates, caption = check2a)
} else {
  check2a
}