library(synapser)
library(plyr)
library(dplyr)
library(mpowertools)

source("allFeatureNames.R")
synLogin()

FEATURES <- get_features()$tap
TABLE_ID <- "syn5511439"
OUTPUT_FILE <- "data/raw_tap_features.csv"

extract_data <- function(){
  tapping_table <- synTableQuery(sprintf("select * from %s", TABLE_ID))
  tapping_data <- as.data.frame(tapping_table)
  row_name <- tapping_data %>% dplyr::select(c(ROW_ID, ROW_VERSION))
  tapping_data$idx <- rownames(row_name)

  json_files <- synDownloadTableColumns(tapping_table, "tapping_results.json.TappingSamples")
  json_files <- data.frame(tapping_json_fileId = names(json_files), tapping_json_file = as.character(json_files))

  tapping_data <- base::merge(tapping_data, json_files, by.x="tapping_results.json.TappingSamples",
                              by.y="tapping_json_fileId", all=T)
  tapping_data <- tapping_data %>% mutate(tapping_json_file=as.character(tapping_json_file))

  tapping_features <- ddply(.data=tapping_data,
                            .variables=c("recordId", "appVersion", "createdOn", "healthCode", "phoneInfo", "medTimepoint"),
                            .fun = function(row) {
                              tryCatch({
                                mpowertools::getTappingFeatures(row$tapping_json_file)
                              }, error = function(err){
                                stop(paste0('Error with ', row$recordId, ': ', err))
                              })
                            })

  tapping_features <- tapping_features %>%
    dplyr::select(recordId, healthCode, createdOn, appVersion, phoneInfo, all_of(FEATURES), medTimepoint) %>%
    mutate_at(FEATURES, function(x){as.numeric(x)})

  write.table(tapping_features, OUTPUT_FILE, sep=",", row.names=F, quote=F, na="")
}

extract_data()
