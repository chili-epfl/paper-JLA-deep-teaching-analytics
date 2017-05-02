# Run through pre-trained visual neural network models, see https://github.com/kidzik/deep-features

extractVideoFeatures <- function(featurescriptDir, imageDir, outputzipFile){
  
  origDir <- getwd()
  setwd(featurescriptDir)
  # TODO: we will need to do this through docker (torch is installed there, probably)
  # docker run -it -p 8888:8888 -p 6006:6006 -v /media/sf_shared:/root/sharedfolder floydhub/dl-docker:cpu ls -l /root/sharedfolder/deep-features
  # Execute the Lua script to extract the last layer of features  
  cmd <- paste("th extract.lua -images_path",imageDir)
  system(cmd, wait=T)
  
  # Put the output.csv file into a videofeatures-lastlayer.csv.zip file in the data/interim dir (or wherever specified)
  zip(outputzipFile,paste(featurescriptDir,"output.csv",.Platform$file.sep))
  
  setwd(origDir)
  
  outputzipFile
  
}  