plot1 <- function(){
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
x<-sqldf("select Global_active_power FROM unzipped WHERE newDate BETWEEN '2007-02-01' and '2007-02-02' and Global_active_power <> '?'")
# create histogram
with(x,hist(as.numeric(Global_active_power)/500, col="red", main='Global Active Power',xlab="Global Active Power (kilowatts)", breaks=11))
dev.copy(png, file = "plot1.png")
dev.off()
}