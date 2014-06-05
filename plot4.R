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

## Plot 4 - 4 charts together
png(filename = "plot4.png", width = 480, height = 480, units = "px")
par(mfrow = c(2,2))
with(data, {
    # Plot 1
    plot(datetime, Global_active_power, type = "l", xlab = "", ylab = "Global Active Power")
    # Plot 2
    plot(datetime, Voltage, type = "l")
    # Plot 3
    plot(datetime, Sub_metering_1, type = "l", col = "black", xlab = "", ylab = "Energy sub metering")
    lines(datetime, Sub_metering_2, type = "l", col = "red")
    lines(datetime, Sub_metering_3, type = "l", col = "blue")
    legend("topright", lty=1, col=c("black", "red", "blue"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty="n")
    # Plot 4
    plot(datetime, Global_reactive_power, type="l")
})
dev.off()
