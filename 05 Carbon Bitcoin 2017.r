#Bitcoin CO2e emmisions for 2017
#Calculations developed by Mason K. Chock, Erik C. Franklin, Michael B. Kantar, Camilo Mora, Randi Rollins, Mio Shimada, Katie Taladay
#Calculations implemented in R-code By Camilo Mora
#2018

##this code is for use in R. 3.5.0 and it requires the library  data.table, bit64, and dplyr to be installed.

#this null model  estimates the co2e emmision of bitoin in 2017. it takes all bitcoind blocks for that year, estimates the hashes, then it pairs each block to a ramdonly selected computing system that used for mining.
#from that we estimate electricity required to mine the given block, then using emmisions of electricity generation in the likely country where mining took place, we 
#estimated the emmisions to mine the given block. Summing the emmisions of all blocks mined in 2017, yields the emmicions of mining Bitcoin that year.
#The process is repeated 1000 times to capture variability in the random selection of a computer for the mining.

library(data.table)
require(bit64)
library(dplyr)

#---start---things to adjust----you need to adjust the lines below to the paths where you put the file
setwd("Z:/CryptoCurrencyFootprint")                  #path where you want results to be saved
Data_2017=fread("Z:/CryptoCurrencyFootprint/BitCoinData_2017.csv")   #database containing all blocks mined in 2017. Database is provided with this code.
ProcessorsElec=fread("Z:/CryptoCurrencyFootprint/Randi_TableS1.csv")   #database listing the processors currently used for mining. Database is provided with this code.
CO2AtMiningCountry=fread("Z:/CryptoCurrencyFootprint/Katie_TableS2.csv")     #list of companies doing mining and the CO2e emmisions of electricity generation in their claimed countries. Database is provided with this code.
#---end---things to adjust----you need to adjust the lines below to the paths where you put the file


#blocks database 
    setkey(Data_2017,Mining_pool)
    #estimate total number of hashes
    Data_2017[,Hashes:=(difficulty*(2^32))]    #according to O'Dwyer and Malone "the the expected number of hashes to find a block is D*2^32"   . see also https://bitcoin.stackexchange.com/questions/4565/calculating-average-number-of-hashes-tried-before-hitting-a-valid-block
    
#processors database     
    setnames(ProcessorsElec,c("Hash_Rate(Ghash/s)" ,"Energy_Efficiency(Mhash/J)") ,c("GHasPerSec","MHashesPerJ"))
    #convert units to hashes
    ProcessorsElec[,HasPerSec:=GHasPerSec*10^9]      #convert rate from giga hashes     to hashes
    ProcessorsElec[,HashesPerJ:=MHashesPerJ*10^6]      #convert Megahashes per jule to hashes per J
    ProcessorsElec=ProcessorsElec[,c("HasPerSec","HashesPerJ"), with=F ]    #selects colums to be used

#Carbon emmisions of electricity generation in the coiuntries of Bitcoit mining companies
   CO2AtMiningCountry= CO2AtMiningCountry[,c("Mining_pool", "Carbon/GWh(Tons)"),with=FALSE]     #selects the two columns to be used from CO2 emmisions of the coutnries where mining is happending
  setnames(CO2AtMiningCountry,"Carbon/GWh(Tons)", "TonsOfCarbonPerGWh")
  setkey(CO2AtMiningCountry,Mining_pool) 
  Data_2017=merge(Data_2017,CO2AtMiningCountry)   #append carbon emmisions data by compny name to the block data
  
Emmisions2017=data.table()         #creates an empty datatable for storage of 1000 iteractions of the approach.

for (i in 1:1000)       #repeat the code above 1,000 times to capture vraibaility due to the random selection of the hardware
{
#estimate electricity needed to resolve the block. 
#1. select a list of random processors equeal o the number of blocks
    Efficiencies=sample_n(ProcessorsElec, nrow(Data_2017), replace = T) #create a ramdon list of processors for each of the different blocks
    Dat_2017=cbind(Data_2017,Efficiencies)   #append the list of random computers to the blocks mined in 2017
    #Dat_2017= Data_2017[,HashesPerJ:=sample(ProcessorsElec$HashesPerJ, 1)] # assuming only one processor is used
#2. estimate total jules of the block
    Dat_2017[,TotalJulesInBlock:=Hashes/HashesPerJ]     #estimate total jules in block
    Dat_2017[,TotalGwhInBlock:=TotalJulesInBlock*(2.78*10^-13)]     #convert jules to GWh

#3. estimate carbon emmisions from the given block   in Ggtons of Carbon
    Dat_2017[,CarboninGtnForBlock:=(TotalGwhInBlock*TonsOfCarbonPerGWh)/10^9] 
    Dat_2017=Dat_2017[,c("transactions","CarboninGtnForBlock"), with=F ]    #selects to colums to be used 

    CarbonEmmision2017= sum(Dat_2017$CarboninGtnForBlock)    #global carbon emmisions for bitcoin mining in 2017     in Ggtons of Carbon      note that this is Carbon. to estimate CO2 this value has to be multipled by 3.67
    Emmisions2017=rbind(Emmisions2017,CarbonEmmision2017)     #append result of year   i
}


write.csv(Emmisions2017,"Code05Emmisions_2017.csv")  #save results

#Average emmisions for 2017
MeanC2017=mean(Emmisions2017$x) *  3.67 #convers average Carbon emmissions to CO2e
MeanC2017=MeanC2017*1000 #convers  GgTon to Million Metric tons  

#Standard deviation emmisions for 2017
SDC2017=sd(Emmisions2017$x) *  3.67 #convers standard deviation emmission to CO2e
SDC2017=SDC2017*1000 #convers  GgTon to Million Metric tons  

