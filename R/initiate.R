# First Analyst Checks
# Created February 2020
# Updated: ARE (2/20/20)
         # ARE (4/8/2020)

library(tidyverse)
library(haven)
library(dplyr)
library(stringr)
library(knitr)
library(janitor)

knitr::opts_chunk$set(echo = FALSE)

# Extract the source name from the folder name
source_name <- str_sub(folder_name, start=5) # pulls character starting at place 5 (3 numbers and space)
# Extract the source number as character from the folder name
source_number <- str_sub(folder_name, end=3) # pulls character ending at place 3
# Make it a number
num_source <- as.numeric(source_number)

# Make the data name
name_data <- paste("_", source_number, "data.sas7bdat", sep="")
name_series <- paste("_", source_number, "series.sas7bdat", sep="")
name_subsectors_series <- paste("_", source_number, "subsectors_series.sas7bdat", sep="")

# Make the file path to the final data
path_source <- file.path(drive, "ESDB", "Sources", folder_name, fsep="\\")
path_data <- file.path(drive, "ESDB", "Sources", folder_name, "Final data", name_data,  fsep="\\")
path_series <- file.path(drive, "ESDB", "Sources", folder_name, "Final data", name_series,  fsep="\\")
path_subsectors_series <- file.path(drive, "ESDB", "Sources", folder_name, "Final data", name_subsectors_series,  fsep="\\")

# Read in the final data
source_data <- read_sas(path_data) %>% mutate_all(`attributes<-`, NULL) %>% clean_names()
source_series <- read_sas(path_series) %>% mutate_all(`attributes<-`, NULL)%>% clean_names()
source_subsectors_series <- read_sas(path_subsectors_series) %>% mutate_all(`attributes<-`, NULL)%>% clean_names()

# Run the pre-update series check
source("S:\\ESDB\\Sources\\~First Analyst Resources\\FAC test\\pre_update.R")

# Run all of the checks
source("S:\\ESDB\\Sources\\~First Analyst Resources\\FAC test\\test1.R")
source("S:\\ESDB\\Sources\\~First Analyst Resources\\FAC test\\test2.R")
source("S:\\ESDB\\Sources\\~First Analyst Resources\\FAC test\\test3.R")