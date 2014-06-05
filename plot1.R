## Download and read complete file
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileURL, destfile = "./data/consumption.zip")

unzip("./data/consumption.zip", exdir = "./data")
testAllData <- read.table("./data/household_power_consumption.txt", sep = ";", header = TRUE, stringsAsFactors = FALSE)

## Convert Date, and use to subset to data of interest
# Contrary to instructions format not strictly "dd/mm/yyyy"
# Some are "d/m/yyyy"
testAllData$Date <- as.Date(testAllData$Date, "%d/%m/%Y")
data <- subset(testAllData, Date >= as.Date("2007-02-01") & Date <= as.Date("2007-02-02"))
rm(testAllData) # free up memory

## Combine date and time
data$datetime <- strptime(paste(data$Date, data$Time), "%Y-%m-%d %H:%M:%S")
# Move datetime to start of df
col_idx <- grep("datetime", names(data))
data <- data[, c(col_idx, (1:ncol(data))[-col_idx])]
rm(col_idx)

## Change all numeric columns to numeric type
data[,4:10] <- sapply(data[,4:10], as.numeric)

## Plot 1 - Histogram
png(filename = "plot1.png", width = 480, height = 480, units = "px")
hist(data$Global_active_power, breaks=seq(0,7.5,by=0.5), col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)")
dev.off()