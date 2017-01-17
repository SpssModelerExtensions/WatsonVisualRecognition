#################################################################################
# 'WatsonVisualRecognition' v1.0 node for IBM SPSS Modeler      				#
# Artur Kucia, Mateusz Mika                           							#
# IBM 2017                                                      				#
# Description: Use the Visual Recognition Service for image classification.     #
#################################################################################

# Install function for packages    
packages <- function(x){
  x <- as.character(match.call()[[2]])
  if (!require(x,character.only=TRUE)){
    install.packages(pkgs=x,repos="http://cran.r-project.org")
    require(x,character.only=TRUE)
  }
}
# Required packages
packages(httr)    
# Classifier
watsonClassify <- function(destination,imageURL,apiVersion,apiKey,classifiers){
	#  "&" is used as a separator between parameters in api call, we must use "%26" instead
	imageURL <- gsub('&','%26',imageURL)	
	api_call <- paste0("https://gateway-a.watsonplatform.net/visual-recognition/api/v3/",destination,"?&url=",imageURL
					,'&classifier_ids=',classifiers,"&version=",apiVersion,"&api_key=",apiKey)
	apiResponse <- GET(api_call)
	status <- apiResponse[["status_code"]]
	apiResponse <- content(apiResponse)[["images"]][[1]]
	
	if( status == 400 ) warning("Invalid input. Check for image URLs.")
	else if( status == 401 ) warning("Unauthorized. Check your Api Key.")
	else if( status == 404 ) warning("404")
	else if( status == 401 ) warning("Internal Server Error")
	else if( "error" %in% names(apiResponse)  ) warning(apiResponse[["error"]])
	else return(apiResponse)
	return("error")
}
# Input 
apiKey <- "%%watson_api_key%%"
apiVersion <- "%%api_version%%"
classifier_list <- "%%classifier_ids%%"
imageURLs <- modelerData$%%photo_urls%%
imageIDs <- modelerData$%%im_ids%%

outImgId <-c()
outImgSource <- c()
outClass <- c()
outClassScore <- c()
outClassType <- c()
outClassifierIDs <- c()
outClassifierNames <- c()

for(i in 1:length(imageURLs)){
	imageID <- paste(imageIDs[i])
	imageURL <- paste(imageURLs[i])
	apiResponse <- watsonClassify("classify",imageURL,apiVersion,apiKey,classifier_list)
	if(apiResponse != "error") {
		classifiers <- apiResponse[["classifiers"]]
		imageSource <- apiResponse[["source_url"]]
	} else {
		warning(paste0("Above error is for photo with ID: ",imageID,"\n\t... and URL: ",imageURL))
		next
	}
	if( length(classifiers) > 0 ){ 
		for(classifier in classifiers){
			recognizedClasses <- classifier[["classes"]]
			if( length(recognizedClasses) > 0 ){
				for(recognizedClass in recognizedClasses){ # new row for each output
					outImgId <- c(outImgId, imageID)
					outImgSource <- c(outImgSource,imageSource)
					outClass <- c(outClass,recognizedClass[["class"]])
					outClassScore <- c(outClassScore,recognizedClass[["score"]])
					
					if( !is.null(recognizedClass[["type_hierarchy"]]) ){ 
						outClassType <- c(outClassType,recognizedClass[["type_hierarchy"]])
					} else outClassType <- c(outClassType,"")
					
					outClassifierIDs <- c(outClassifierIDs,classifier[["classifier_id"]])
					outClassifierNames <- c(outClassifierNames,classifier[["name"]])
				}
			} else { # wnen nothing was found in the picture
				outImgSource <- c(outImgSource,imageSource)
				outClass <- c(outClass,"Couldn't find any class.")
				outClassScore <- c(outClassScore,"")
				outClassType <- c(outClassType,"")
				outClassifierIDs <- c(outClassifierIDs,classifier[["classifier_id"]])
				outClassifierNames <- c(outClassifierNames,classifier[["name"]])
			}
			
		}
	} else warning("Did not found any classifier (not even the default one).")
}

if( length(imageURLs) > 0 ){
	modelerData <- data.frame(outImgId,outImgSource,outClass,outClassScore,outClassType,outClassifierIDs,outClassifierNames)
} else warning("Did not found any URLs")

var1 <- c(fieldName="ID", fieldLabel="", fieldStorage="string", fieldMeasure="", fieldFormat="", fieldRole="")
var2 <- c(fieldName="Source", fieldLabel="", fieldStorage="string", fieldMeasure="", fieldFormat="", fieldRole="")
var3 <- c(fieldName="Class", fieldLabel="", fieldStorage="string", fieldMeasure="", fieldFormat="", fieldRole="")
var4 <- c(fieldName="ClassScore", fieldLabel="", fieldStorage="string", fieldMeasure="", fieldFormat="", fieldRole="")
var5 <- c(fieldName="ClassType", fieldLabel="", fieldStorage="string", fieldMeasure="", fieldFormat="", fieldRole="")
var6 <- c(fieldName="ClassifierID", fieldLabel="", fieldStorage="string", fieldMeasure="", fieldFormat="", fieldRole="")
var7 <- c(fieldName="ClassifierName", fieldLabel="", fieldStorage="string", fieldMeasure="", fieldFormat="", fieldRole="")

modelerDataModel <- data.frame(var1,var2,var3,var4,var5,var6,var7)
