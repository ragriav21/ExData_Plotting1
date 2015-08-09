# Increase RAM available for Java and Java processes
options(java.parameters = "--max-mem-size")  

# Number of minutes in two days

timeSteps <- 2 * 24 * 60

# Load in data just for dates of interest

temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", 
              temp)
ElectricPowerConsumptionDF <- 
    read.table(unz(temp, "household_power_consumption.txt"), header = T, 
               sep = ";", na.strings = "?", 
               skip = grep("1/2/2007", 
                           readLines(unz(temp, "household_power_consumption.txt")))[1] - 2, 
               nrows = timeSteps)

# Get appropriate names for dataset of interest

EPCDF.Names <- read.table(unz(temp, "household_power_consumption.txt"), header = T, 
                          sep = ";", nrows = 1)

names(ElectricPowerConsumptionDF) <- names(EPCDF.Names)

# Assign new date and time variables

ElectricPowerConsumptionDF$Date.Converted <- 
    as.Date(ElectricPowerConsumptionDF$Date, format = "%d/%m/%Y")

ElectricPowerConsumptionDF$Time.PreConversion <-
    paste(ElectricPowerConsumptionDF$Date.Converted, 
          ElectricPowerConsumptionDF$Time)

ElectricPowerConsumptionDF$Time.Converted <-
    strptime(ElectricPowerConsumptionDF$Time.PreConversion,
             format = "%Y-%m-%d %X")

# Make & print Plot 3

png("plot3.png")
plot(x = ElectricPowerConsumptionDF$Time.Converted, 
     y = ElectricPowerConsumptionDF$Sub_metering_1, type = "l",
     xlab = "", ylab = "Energy sub metering")
lines(ElectricPowerConsumptionDF$Time.Converted, 
      ElectricPowerConsumptionDF$Sub_metering_2, col = "red")
lines(ElectricPowerConsumptionDF$Time.Converted, 
      ElectricPowerConsumptionDF$Sub_metering_3, col = "blue")
legend("topright", 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"), lty = 1)
dev.off()


