##Step 1: Load functions
#load necessary functions
source("functions.R")

##Step 2: Obtain Heat Map using Scatterplot approach
#list all the data in directory
list=read.table("list_of_bruker_MS_folders.txt")
folder_directory="folder_for_bruker_data"

#set default parameters
threshold=0.5
resolution=1
picwd="directory_for_saving_pic"
cex=2

#create loop for datasets for plotting
for (i in 1:nrow(list)){
  
  #obtain directory
  directory=paste(folder_directory, list[i,],sep="")
  
  #convert data into necessary format for reading
  data=GelDataS(directory, threshold)
  
  #set working directory for exporting data
  setwd(picwd)
  
  #set title for the figure
  title=list[i,]
  
  #set parameters for export
  png(height=553*2, width=841*2, units="px", res=400, pointsize=5, filename=paste(list[i,],"-t",threshold*100,"-cex",cex,"-",i,"-SP.png",sep=""), type="cairo")
  
  #export figure using scatter_fill of ggplot2
  scatter_fill(data$mz,data$order,data$intensity,nlevels=max(data$intensity),
               xlim=c(0,1100),ylim=c(0,max(data$order)),zlim=c(0,max(data$intensity)),
               xlab="m/z", ylab="Cycle", main=title,pch=15,cex=cex)
  
  #allow png to save
  dev.off()
  
  #clean RAM
  gc()
}
