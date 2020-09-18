library(synapser)
library(plyr)
library(dplyr)
library(lubridate)
library(mpowertools)

source("allFeatureNames.R")
synLogin()

FEATURES <- get_features()$walk
TABLE_ID <- "syn5511449"
OUTPUT_FILE <- "data/raw_walk_features.csv"


extract_data <- function(){
    walking_table <- synTableQuery(sprintf("select * from %s", TABLE_ID))
    walking_data <- as.data.frame(walking_table)
    row_name <- walking_data %>% dplyr::select(c(ROW_ID, ROW_VERSION))
    walking_data$idx <- rownames(row_name)

    outbound_walking_json_files <- synDownloadTableColumns(walking_table, "deviceMotion_walking_outbound.json.items")
    outbound_walking_json_files <- data.frame(outbound_walking_json_fileId = names(outbound_walking_json_files),
                                              outbound_walking_json_file   = as.character(outbound_walking_json_files))

    outbound_pedometer_json_files <- synDownloadTableColumns(walking_table, "pedometer_walking_outbound.json.items")
    outbound_pedometer_json_files <- data.frame(outbound_pedometer_json_fileId = names(outbound_pedometer_json_files),
                                                outbound_pedometer_json_file = as.character(outbound_pedometer_json_files))

    walking_data <- walking_data %>%
        dplyr::left_join(., outbound_walking_json_files,
                         by=c("deviceMotion_walking_outbound.json.items"="outbound_walking_json_fileId")) %>%
        dplyr::left_join(., outbound_pedometer_json_files,
                         by = c("pedometer_walking_outbound.json.items"="outbound_pedometer_json_fileId"))

    walking_data$outbound_walking_json_file <- as.character(walking_data$outbound_walking_json_file)
    walking_data$outbound_pedometer_json_file <- as.character(walking_data$outbound_pedometer_json_file)

    pedometer_features <- ddply(.data=walking_data,
                                .variables=c("recordId", "appVersion", "createdOn", "healthCode", "phoneInfo", "medTimepoint"),
                                .fun = function(row) {
                                  tryCatch({
                                    mpowertools::getPedometerFeatures(row$outbound_pedometer_json_file)
                                  }, error = function(err){
                                    stop(paste0('Error with ', row$recordId, ': ', err))
                                  })
                                })

    walking_features <- ddply(.data=walking_data,
                              .variables=c("recordId", "appVersion", "createdOn", "healthCode", "phoneInfo",
                                           "medTimepoint"),
                              .fun = function(row) {
                                tryCatch({
                                  mpowertools::getWalkFeatures(row$outbound_walking_json_file)
                                }, error = function(err){
                                  stop(paste0('Error with ', row$recordId, ': ', err))
                                })
                              })

    all_walking_features <- base::merge(pedometer_features, walking_features, all.x=T, all.y=T, sort=F) %>%
      dplyr::select(recordId, healthCode, createdOn, appVersion, phoneInfo, all_of(FEATURES), medTimepoint) %>%
      dplyr::mutate_at(FEATURES, function(x){as.numeric(x)})

    write.table(all_walking_features, OUTPUT_FILE, sep=",", row.names=F, quote=F, na="")
}

extract_data()
