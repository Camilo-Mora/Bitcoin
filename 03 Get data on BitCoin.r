#Gets Bitcoin Data from the web
#By Camilo Mora
#2018

#this code is for use in R. 3.5.0 and it requires the library   RJSONIO to be installed.
#the code goes to   blocktrail.com and takes data on the blocks needed. In this case all the information for the blocks in 2017
#Data are collected in groups of 1000 blocks, starting on the first block defined in the code. 


      setwd("C:/Users/Camilo Mora/Documents/Bitcoins/")       ##define where you want the blocks data to be saved
      library(RJSONIO) # load the necessarylibrary for web-connection
      Start= 446097  #first block in 2017  446097     #454102
      Last= 502027   #last block of 2017    502027
      
      nullToNA <- function(x) {
      x[sapply(x, is.null)] <- NA
      return(x)
      }


      MY_APIKEY <- "6debaf0ebd4c9081795fe38716df550c46ab06fb"
			# API url
			block_url	<- "https://api.blocktrail.com/v1/btc/block/"
			APIkey		<- paste0("?api_key=", MY_APIKEY)
			
			
			
			for (i in 1:1)      #do 50 loops of 1000 blocks each, that will conver the       47925 blocks of 2017
			{
      Data=data.frame()
			for (x in 0:999) {
			
    #  x1 <- runif(1, 0.0, 1.1)  #sleep for a random time so it does not get blocked
	#		Sys.sleep (x1)
			
			BlockNum=(i*1000+x)+Start
      block_data_list_0	<- nullToNA(fromJSON(paste0(block_url, BlockNum, APIkey)))
      datax=data.frame(t(unlist(block_data_list_0)) )
      Data=rbind(Data,datax)
      }
      
      write.csv(Data,paste(i,".csv",sep=""))
      }
      
      