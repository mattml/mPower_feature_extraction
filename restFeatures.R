library(synapser)
library(plyr)
library(dplyr)
library(mpowertools)

source("allFeatureNames.R")
synLogin()

FEATURES <- get_features()$rest
TABLE_ID <- "syn5511449"
OUTPUT_FILE <- "data/raw_rest_features.csv"


extract_data <- function(){
    rest_table <- synTableQuery(sprintf("select * from %s", TABLE_ID))
    rest_data <- as.data.frame(rest_table)
    row_name <- rest_data %>% dplyr::select(c(ROW_ID, ROW_VERSION))
    rest_data$idx <- rownames(row_name)

    json_files <- synDownloadTableColumns(rest_table, "deviceMotion_walking_rest.json.items")
    json_files <- data.frame(rest_json_fileId = names(json_files), rest_json_file = as.character(json_files))

    rest_data <- base::merge(rest_data, json_files, by.x="deviceMotion_walking_rest.json.items", by.y="rest_json_fileId", all=T)
    rest_data <- rest_data %>% mutate(rest_json_file=as.character(rest_json_file))

    rest_features <- ddply(.data=rest_data,
                           .variables=c("recordId", "appVersion", "createdOn", "healthCode", "phoneInfo", "medTimepoint"),
                           .fun = function(row) {
                               tryCatch({
                                   mpowertools::getRestFeatures(row$rest_json_file)
                               }, error = function(err){
                                    stop(paste0('Error with ', row$recordId, ': ', err))
                               })
                           })

    rest_features <- rest_features %>%
        dplyr::select(recordId, healthCode, createdOn, appVersion, phoneInfo, all_of(FEATURES), medTimepoint) %>%
        mutate_at(FEATURES, function(x){as.numeric(x)})

    write.table(rest_features, OUTPUT_FILE, sep=",", row.names=F, quote=F, na="")
}

extract_data()
