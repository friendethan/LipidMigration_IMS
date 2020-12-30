#Creates a dataframe of three vectors for use in scatter plot format
#x value (order), y value (mz), z value (intensity)
GelDataS = function(directory, threshold) {
  #creating vectors for analysis
  list = createMassList(directory)
  data = detectPeaks(list,halfWindowsize=20, method=c("MAD"), SNR=2)
  data = binPeaks(data,method="strict",tolerance=0.1)
  #creates vector for mz (y value)
  mz=c()
  for(i in 1:length(data)){
    mz[[i]] = data[[i]]@mass
  }
  #creates list for intensities (z value)
  intensity=c()
  for(i in 1:length(data)){
    intensity[[i]] = data[[i]]@intensity
  }
  #create list for order (x value)
  order=intensity
  for(i in 1:length(order)){
    order[[i]] = rep(i, length(order[[i]]))
  }
  #turn values into vectors
  order=unlist(order)
  mz=unlist(mz)
  intensity=unlist(intensity)
  #threshold value
  t=threshold
  cutoff=max(intensity)*t
  intensity[ intensity>cutoff ] = cutoff
  #create vector dataframe
  df= data.frame(order, mz, intensity)
  return(df)
}

#creates line plot from existing dataframe exported from GelDataS
LinePlotData=function(data,peaklist,peakname,tolerance, normalize){
  data$mz=round(data$mz,decimalplaces(tolerance)+1)
  if(is.null(peakname)) label=paste(peaklist, "+/-", tolerance, 
                                      sep="") else label=paste(peakname, " ", peaklist, "+/-", tolerance, sep="")
    #allow for rough m/z values
    if(length(peaklist)==1){
      peak = findInterval(data$mz, c(peaklist-tolerance,peaklist+tolerance)) == 1
      tdata = data[which(peak==T),]
      legend = rep(paste(label), times=nrow(tdata))
      if(nrow(tdata)==0) norm=F else norm=normalize
      if(isTRUE(norm)){
          FUN <- function(x) x/max(x)
          ndata = data.frame(tdata$intensity)
          ndata = apply(ndata, 2,FUN)
          if(is.null(nrow(ndata))) ndata=data.frame(ndata)
          colnames(ndata) = "normalized intensity"
          tdata = data.frame(tdata, ndata)
        }
        tdata = data.frame(legend, tdata)  
      }
    
    if(length(peaklist)>1) {
      peak = findInterval(data$mz, c(peaklist[1]-tolerance,peaklist[1]+tolerance)) == 1
      tdata = data[which(peak==T),]
      legend = rep(paste(label[1]), times=nrow(tdata))
      if(nrow(tdata)==0) norm=F else norm=normalize
      if(isTRUE(norm)){
          FUN <- function(x) x/max(x)
          ndata = data.frame(tdata$intensity)
          ndata = apply(ndata, 2,FUN)
          if(is.null(nrow(ndata))) ndata=data.frame(ndata)
          colnames(ndata) = "normalized intensity"
          if(is.null(nrow(ndata))) ndata=data.frame(ndata)
          tdata = data.frame(tdata, ndata)
        }
      tdata = data.frame(legend, tdata)

      for(i in 2:length(peaklist)){
        peak = findInterval(data$mz, c(peaklist[i]-tolerance,peaklist[i]+tolerance)) == 1
        sdata = data[which(peak==T),]
        legend = rep(paste(label[i]), times=nrow(sdata))
        if(nrow(sdata)==0) norm=F else norm=normalize
          if(isTRUE(norm)){
            FUN <- function(x) x/max(x)
            ndata = data.frame(sdata$intensity)
            ndata = apply(ndata, 2,FUN)
            if(is.null(nrow(ndata))) ndata=data.frame(ndata)
            colnames(ndata) = "normalized intensity"
            sdata = data.frame(sdata, ndata)
          }
        sdata = data.frame(legend, sdata)
        tdata = rbind(tdata,sdata)
      }
      }
  return(tdata)
  }

#creates multiple line plots using ggplot methods
#must use data from LinePlotData & peaklist must have column named mz
#allows for smoothing or no smoothing, 
multiLinePlots = function(data, peaklist, peakname, tolerance, species, lpg, title, 
                          normalize=TRUE, smooth=TRUE, s_method="loess", span=1, 
                          xlim=NULL, ylim=NULL, xlab = "cycles", plot=TRUE, fontsize=18){
  require(ggplot2)
  if(is.null(fontsize)) fontsize = 11
  theme_set(theme_gray(base_size = fontsize))
  if(is.null(ncol(peaklist))) peak=peaklist else peak=peaklist$mz
  p=list()
  for(j in 1:ceiling(species/lpg)){
    start=lpg*(j-1)+1
    end=lpg*(j)
    if(end>species) end=species
    if(is.null(peakname)) name=NULL else name=peakname[c(start:end)]
    plotdata = LinePlotData(data, peaklist=peak[c(start:end)], peakname=name, tolerance, normalize=normalize)
    #condition normalized and smooth 
    if(isTRUE(normalize)&isTRUE(smooth)){
      #plotting
      p[[j]]= ggplot(data = plotdata, aes(x=order, y=normalized.intensity)) + 
        #setting the x,y limit
        coord_cartesian(xlim,ylim)+
        scale_x_continuous(limits=xlim, expand = c(0, 0))+
        scale_y_continuous(limits=ylim, expand = c(0, 0))+
        #plotting smoothed line
        geom_smooth(aes(colour=legend),method=s_method, se=F, span = span, lwd=1) +
        #add appropriate title
        ggtitle(paste(title," Species ", start, "-", end, sep=""))+ theme(plot.title = element_text(hjust=0.5, lineheight=.8, face="bold")) +
        #create x, y, and legend labels
        labs(x = xlab, y = "Normalized Intensity", colour="Species")
    }
    #condition normalized and unsmoothed
    if(normalize==T&smooth==F){
      p[[j]]= ggplot(data = plotdata, aes(x=order, y=normalized.intensity)) + 
        #setting the x,y limit
        coord_cartesian(xlim,ylim)+
        scale_x_continuous(limits=xlim, expand = c(0, 0))+
        scale_y_continuous(limits=ylim, expand = c(0, 0))+
        #plotting line
        geom_line(aes(colour=legend),lwd=1) +
        #add appropriate title
        ggtitle(paste(title," Species ", start, "-", end, sep=""))+ theme(plot.title = element_text(hjust=0.5, lineheight=.8, face="bold")) +
        #create x, y and legend labels
        labs(x = xlab, y = "Intensity (a.u.)", colour="Species")
    }
    #condition not normalized and smoothed
    if(normalize==F&smooth==T){
      p[[j]]= ggplot(data = plotdata, aes(x=order, y=intensity)) + 
        #setting the x,y limit
        coord_cartesian(xlim,ylim)+
        scale_x_continuous(limits=xlim, expand = c(0, 0))+
        scale_y_continuous(limits=ylim, expand = c(0, 0))+
        #plotting smoothed line
        geom_smooth(aes(colour=legend),method=s_method, se=F, span = span, lwd=1) +
        #add appropriate title
        ggtitle(paste(title," Species ", start, "-", end, sep=""))+ theme(plot.title = element_text(hjust=0.5, lineheight=.8, face="bold")) +
        #create x, y and legend labels
        labs(x = xlab, y = "Intensity (a.u.)", colour="Species")
    }
    #condition not normalized and not smoothed
    if(normalize==F&smooth==F){
      p[[j]]= ggplot(data = plotdata, aes(x=order, y=intensity)) + 
        #setting the x,y limit
        coord_cartesian(xlim,ylim)+
        scale_x_continuous(limits=xlim, expand = c(0, 0))+
        scale_y_continuous(limits=ylim, expand = c(0, 0))+
        #plotting line
        geom_line(aes(colour=legend),lwd=1) +
        #add appropriate title
        ggtitle(paste(title," Species ", start, "-", end, sep=""))+ theme(plot.title = element_text(hjust=0.5, lineheight=.8, face="bold")) +
        #create x, y and legend labels
        labs(x = xlab, y = "Intensity (a.u.)", colour="Species")
    }
  }
  if(isTRUE(plot)) print(p)
  return(p)
}
