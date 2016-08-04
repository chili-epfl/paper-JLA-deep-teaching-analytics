# Munges the raw data files into a set of clean(er) data (CSV) files, 
# aligned but with potentially different sampling rates
# 
# Assumptions:
# 0. The working directory is that where this R file lives
# 1. The original data files have been copied into the data/raw/caseX folder, 
#    with names like (case1-day1-session2-teacher1)-kindofdata.extension
#    (case1-day1-session2-teacher1) = sessionid
# 2. Will put the cleaner data files in the data/interim folder

originalwd <- getwd()
rawdatadir <- paste(originalwd,"../../data/raw",sep = .Platform$file.sep)
interimdatadir <- paste(originalwd,"../../data/interim",sep = .Platform$file.sep)
setwd(rawdatadir)

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

TODO: Take from the JDC15 code!!!!