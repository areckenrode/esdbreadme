# Check products before the ESDB update


# Libraries and paths -----------------------------------------------------

library(tidyverse)

ESDB  <- sprintf("%s\\ESDB\\Database\\", drive)

master_series <- read_sas(sprintf("%sseries.sas7bdat", ESDB)) %>% 
  mutate_all(`attributes<-`, NULL) %>% 
  filter(source_id == num_source) %>%  # num_source is created in initiate.R
  select(series_id, series_name)

master_series_filters <-read_sas(sprintf("%sseries_filters.sas7bdat", ESDB)) %>% 
  mutate_all(`attributes<-`, NULL)


# Use Series_Filters file  --------------------------------------------------------

# We can get product info for Country Profiles, HSBT, Africa Health Tableau, CER, and Sustainable 
# Development Profiles form the series_filters file


list1 <- master_series_filters %>% 
  left_join(master_series, by= "series_id") %>% 
  filter(!is.na(series_name)) %>% 
  mutate(product = case_when(
    series_filter_name == "is_for_country_profiles" ~ "Country Profiles (AB/??)",
    series_filter_name == "is_for_hsbt" ~ "HSBT (CT)",
    series_filter_name == "is_for_africa_tableau" ~ "Africa Health Tableau (AB/CT)",
    series_filter_name == "is_for_cer" ~ "Country Economic Review (JS/EV)",
    series_filter_name == "is_for_sdp" ~ "Regional Context Indicators (AB)",
        )) %>% 
  filter(!is.na(product)) %>% 
  distinct(series_id, product)

# Use Source_Id -----------------------------------------------------------

list2 <- read_sas(sprintf("%sseries.sas7bdat", ESDB)) %>% 
  mutate_all(`attributes<-`, NULL) %>% 
  filter(source_id == 186 |source_id == 177 | source_id == 195) %>% # keep the 3 sources we need to check this way
  select(-series_id) %>% 
  dplyr::rename(series_id = original_series_id) %>% # these use original series id, let's rename
  filter(!is.na(series_id)) %>% 
  mutate(product = case_when(
    source_id == 186 ~ "WE3 Dashboard (ARE/JS)",
    source_id == 177 ~ "Self-Reliance Metrics and Compendium (JS/EV)",
    source_id == 195 ~ "Self-Reliance Metrics and Compendium (JS/EV)"
          )) %>% 
  distinct(series_id, product)


# Use Subsector_Id --------------------------------------------------------

list3 <- read_sas(sprintf("%ssubsectors_series.sas7bdat", ESDB)) %>% 
  mutate_all(`attributes<-`, NULL) %>% 
  mutate(product = case_when(
    subsector_id >= 499 & subsector_id <= 600 ~ "IGD Filter (AB)",
    subsector_id >= 299 & subsector_id <= 400 ~ "Global Health Filter (CT/AB)",
    subsector_id >= 199 & subsector_id <= 300 ~ "Country Dashboard (ARE/JS)",
  )) %>% 
  filter(!is.na(product)) %>% 
  distinct(series_id, product)


# Full Series Product List ------------------------------------------------

product_list <- rbind(list1, list2, list3) %>% 
  left_join(master_series, by="series_id") %>% 
  filter(!is.na(series_name)) %>% 
  distinct(series_id, series_name, product) %>% 
  arrange(series_id)

path_source <- file.path(drive, "ESDB", "Sources", source_name, "Documentation", fsep="\\")
fileName = paste(path_source, 'series_used_in_products.csv',sep = '\\')
write.csv(product_list,fileName)


product <- product_list %>% 
  distinct(product)

product
