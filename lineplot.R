##Step 1: Load functions
#get functions
source("functions.R")

##Step 2: Load Peaklist and data directory
#set working directory
list=read.table("list_of_bruker_fid_folders.txt")
folder_directory="folder_directory"

#obtain peaklist
#manually creating a peaklist
peaklist=c(155.02, 137.02, 574.46, 734.50, 601.48, 758.57, 786.60, 810.60)
peakname=c("DHB", "DHB-H2O", "Cer(d18:2/16:0)", "PC(32:0)", "DG", "PC[34:1]", "PC[36a:3]", "PC[38a:6]")	

#insert peaklist that you copied from Excel directly
peaks = read.table("clipboard",sep="\t",header=TRUE)
peaklist=peaks$mz
peakname=as.character(peaks$name)

##Step 3: Generate line plots
#parameters for data frame 
for(i in 1:nrow(list)){
  
  #obtain directory for lineplot data
  directory=paste(folder_directory, list[i,],sep="")
  
  #Generates data
  data=GelDataS(directory, threshold=1)
  
  #creates list of all peaks in your data ordered by intensity (if you want to see the most intense peaks); otherwise, use approach above
  #peaklist=LinePlotPeaklist(data, max, order="intensity")
  #peakname=NULL
  
  #creates ggplot items that can be plotted
  #for just one plot, species = length(peaklist) & lpg = length(peaklist) 
  #species = the number of species you want to plot, lpg = the number of species on each graph
  p = multiLinePlots(data, peaklist=peaklist, peakname=peakname, tolerance=0.2, 
                     species = length(peaklist), lpg=10, title=list[i,],
                     normalize=TRUE, smooth=TRUE, s_method="loess", span=0.5, xlab = "# of Cycles", plot=TRUE)
  
  #provide directory
  picwd="png_directory"
  
  #set working directory
  setwd(picwd)
  
  #export multiple plots
  for(i in 1:length(p)){
    i=1
    png(height=553*4, width=831*4, units="px", res=400, 
        filename=paste(p[[i]]$labels$title," ASMS Select Species.png",sep=""), type="cairo")
    print(p[[i]])
    dev.off()
  } 
}

##Step X: Other functions for plotting single dataset
require(ggplot2)

#plot normalized smoothed data
plot= ggplot(data = testdata, aes(x=order, y=normalized.intensity)) + 
  #plotting approach of smooth line using loess
  geom_smooth(aes(colour=legend),method="loess", se=F, lwd=1) +
  #add appropriate title
  ggtitle(paste(list[i,], " Select species (Normalized Smoothed)", sep=""))+ theme(plot.title = element_text(hjust=0.5, lineheight=.8, face="bold")) +
  #create x, y and legend labels
  labs(x = "Cycles", y = "Normalized Intensity", colour="Species")
print(plot)
#save data
picwd="pic_directory"
setwd(picwd)
png(height=553*1.5, width=831*1.5, units="px", res=150, filename=paste(plot$labels$title,".png",sep=""), type="cairo")
print(plot)
dev.off()

#plot unsmoothed line data
plot=ggplot(data = testdata, aes(x=order, y=normalized.intensity)) + geom_line(aes(colour=legend),lwd=1) +
  #add appropriate title
  ggtitle(paste(list[i,], " Select species (Unsmoothed Normalized)", sep=""))+ theme(plot.title = element_text(hjust=0.5, lineheight=.8, face="bold")) +
  #create x, y and legend labels
  labs(x = "Cycles", y = "Intensity (a.u.)", colour="Species")
print(plot)
#another plotting approach that isn't as pretty, archived method
scatterplot(intensity ~ order | mz, data=test, xlab="Cycles", ylab="Intensity", main="Test")
