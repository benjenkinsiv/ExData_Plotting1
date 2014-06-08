plot3 <- function(){
  # download file
  require(RCurl)
  bin <- getBinaryURL("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",ssl.verifypeer=FALSE)
  con <- file("exdata-data-household_power_consumption.zip", open = "wb")
  writeBin(bin, con)
  close(con)
  
  # unzip to local file
  unzip("exdata-data-household_power_consumption.zip", "household_power_consumption.txt", list = FALSE, overwrite = TRUE)
  
  # load zipped file
  unzipped <- read.csv(file="household_power_consumption.txt", header = TRUE, sep = ";", quote = "\"",
                       dec = ".", fill = TRUE, comment.char = "")
  
  # use SQL to find date range 
  library(sqldf)
  # add column to convert to Date SQL can understand
  unzipped$newDate <- as.character(as.Date(as.character(unzipped$Date), format = "%d/%m/%Y")) 
  # create dataframe with date constraint
  x<-sqldf("select * FROM unzipped WHERE newDate BETWEEN '2007-02-01' and '2007-02-02' ")
  # add column converting newDate and Time 
  x$datetime <- strptime(paste(x$newDate, x$Time),"%Y-%m-%d %H:%M:%S")
  # create plot
  plot( x$datetime, as.numeric(levels(x$Sub_metering_1))[x$Sub_metering_1],type="l", main='',xlab="",ylab="Energy sub metering",ylim=c(0,35), yaxt="n")
  axis(side = 2, at = c(0,10,20,30), c("0","10", "20", "30"))
  lines(x$datetime, as.numeric(levels(x$Sub_metering_1))[x$Sub_metering_1])
  lines(x$datetime, as.numeric(levels(x$Sub_metering_2))[x$Sub_metering_2], col="red")
  lines(x$datetime, x$Sub_metering_3, col="blue")
  legend("topright",legend=c("sub_metering_1","sub_metering_2","sub_metering_3"),col=c("black","red","blue"),lty=c(1,1,1))
  dev.copy(png, file = "plot3.png")
  dev.off()
}