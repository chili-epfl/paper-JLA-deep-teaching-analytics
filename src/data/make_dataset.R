# Munges the raw data files into a set of clean(er) data (CSV) files, 
# aligned but with potentially different sampling rates
# 
# Assumptions:
# 0. The working directory is that where this R file lives
# 1. The original data files have been copied into the data/raw/caseX folder, 
#    with names like (case1-day1-session2-teacher1)-kindofdata.extension
#    (case1-day1-session2-teacher1) = sessionid
# 2. Will put the cleaner data files in the data/interim folder
source('readAnnotationsFile.R')
source('readTrackerFile.R')
source('getTargetValues.R')

originalwd <- getwd()
rawdatadir <- paste(originalwd,"../../data/raw",sep = .Platform$file.sep)
interimdatadir <- paste(originalwd,"../../data/interim",sep = .Platform$file.sep)
#setwd(rawdatadir)

# TODO: Add more sessions here as we add case studies with different teachers
sessions <- data.frame(session=c("case1-day1-session1-teacher1",
                              "case1-day1-session2-teacher1",
                              "case1-day1-session3-teacher1",
                              "case1-day1-session4-teacher1"),
                         case=c("case1",
                                "case1",
                                "case1",
                                "case1"),
                         day=c("day1",
                               "day1",
                               "day1",
                               "day1"),
                         teacher=c("teacher1",
                                   "teacher1",
                                   "teacher1",
                                   "teacher1"))

# (possibly partial) suffixes for the different raw data files
suffix.acc <- "accelerometer"
suffix.audio <- "audio"
suffix.et.raw <- "eyetracker-raw"
suffix.et.fix <- "eyetracker-fixations"
suffix.et.sac <- "eyetracker-saccades"
suffix.video <- "video"
suffix.coding <- "videocoding"

# STEP 1: ALIGNMENT OF THE DIFFERENT DATA SOURCES
# We take from the video coding the moment all sources are recording 
# (teacher clicks record on mobile phone tracker)
# This origin of time will be applied to all subsequent processing of raw data, 
# so as to have aligned data, even for different sampling rates
annotationsData <- data.frame()
for (i in 1:nrow(sessions)){
    session.annot <- readAnnotationsFile(paste(rawdatadir,.Platform$file.sep,sessions[i,'session'],"-",suffix.coding,".eaf",sep=""))
    session.annot$session <- sessions[i,'session'] # We add the session ID to the annotations
    # Join all sessions in a single dataframe
    if(nrow(annotationsData)==0) annotationsData = session.annot
    else annotationsData = rbind(annotationsData,session.annot)
}
# We add the start and end timestamps (from the point of view of the ET recording) of our dataset for each session. 
# These will be the origin of our unified/aligned dataset
initendtimes <- annotationsData[annotationsData$tier=="Recording" & annotationsData$annotation=="Recording",c("start","end","session")]
sessions <- merge(sessions,initendtimes)

# We load all our raw data, clean it up, and add the new aligned timestamp, and the two target variables at that point in time, and write it to the interim data folder
# Accelerometer data
accelData <- data.frame()
for (i in 1:nrow(sessions)){
    
    session.accel <- readTrackerFile(paste(rawdatadir,.Platform$file.sep,sessions[i,'session'],"-",suffix.acc,"-1.txt",sep=""))
    session.accel <- rbind(session.accel, readTrackerFile(paste(rawdatadir,.Platform$file.sep,sessions[i,'session'],"-",suffix.acc,"-2.txt",sep="")))
    session.accel$session <- sessions[i,'session'] # We add the session ID to the annotations
    # We clean up to keep only the accelerometer data
    session.accel <- session.accel[!is.na(session.accel$accelerationX),-c(5:8)]
    session.accel <- session.accel[order(session.accel$timestamp),]
    # We set the aligned timestamp (the initial timestamp for the accel file marks the origin, nothing to do with the eyetracker timestamp)
    session.accel$timestamp.orig <- session.accel$timestamp
    session.accel$timestamp <- session.accel$timestamp - session.accel$timestamp[1]
    
    # We add the two target variables, in case we want to use the interim data file for training directly
    v <- sapply(session.accel$timestamp, getActivityForTimestamp, annotationsData, sessions[i,'session'])
    v2 <- lapply(v, function(x) ifelse(length(x)==0, NA, x))
    session.accel$Activity <- unlist(v2)
    v <- sapply(session.accel$timestamp, getSocialForTimestamp, annotationsData, sessions[i,'session'])
    v2 <- lapply(v, function(x) ifelse(length(x)==0, NA, x))
    session.accel$Social <- unlist(v2)
    
    if(nrow(accelData)==0) accelData = session.accel
    else accelData = rbind(accelData,session.accel)
}
# We write the clean, aligned data to an interim csv
z <- gzfile(paste(interimdatadir,"accelData.csv.gz",sep=.Platform$file.sep),"w")
write.csv(accelData, z)
close(z)

# eyetracking data


# audio data (create the snippets of the desired length, and tag them with the mid-snippet timestamp and the target values?


# video data (extract the desired frames from it, and tag them with the timestamp and the target values?
