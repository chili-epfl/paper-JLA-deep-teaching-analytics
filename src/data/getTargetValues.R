
getActivityForTimestamp <- function(timestamp, annotationsData, sessionid, originalTimestamp=F){
    
    value <- ""
    start <- annotationsData[annotationsData$tier=="Recording" & annotationsData$annotation=="Recording" & annotationsData$session==sessionid, "start"]
    if(!originalTimestamp){ # Default behavior, we consider the passed timestamp is from the origin of our aligned data
        value <- as.character(annotationsData[annotationsData$start<=(timestamp+start) & annotationsData$end>=(timestamp+start) & annotationsData$session==sessionid & annotationsData$tier=="Activity","annotation"])
    }else{ # The timestamp passed refers to the original video/ET file's origin
        value <- as.character(annotationsData[annotationsData$start<=timestamp & annotationsData$end>=timestamp & annotationsData$session==sessionid & annotationsData$tier=="Activity","annotation"])
    }
    
    
    value    
}


getSocialForTimestamp <- function(timestamp, annotationsData, sessionid, originalTimestamp=F){
    
    value <- ""
    start <- annotationsData[annotationsData$tier=="Recording" & annotationsData$annotation=="Recording" & annotationsData$session==sessionid, "start"]
    if(!originalTimestamp){ # Default behavior, we consider the passed timestamp is from the origin of our aligned data
        value <- as.character(annotationsData[annotationsData$start<=(timestamp+start) & annotationsData$end>=(timestamp+start) & annotationsData$session==sessionid & annotationsData$tier=="Social","annotation"])
    }else{ # The timestamp passed refers to the original video/ET file's origin
        value <- as.character(annotationsData[annotationsData$start<=timestamp & annotationsData$end>=timestamp & annotationsData$session==sessionid & annotationsData$tier=="Social","annotation"])
    }
    
    
    value    
}

