##########################################################################################
##                                                                                      ##
## The 'plot1.R' script:                                                                ##
##   1. Read the 'data/household_power_consumption.txt' file that contains power        ##
##      consumption data into the data table PowerCons.                                 ##
##                                                                                      ##
##   Optimisation:                                                                      ##
##      If the required subset of data to construct the charts has already been saved   ##
##      in the file 'data/070201-02_household_power_consumption.txt', this later is used##
##      Otherwise the required data subset is loaded from the file                      ##
##      'household_power_consumption.txt' and saved in the file                         ##
##      'data/070201-02_household_power_consumption.txt' for further execution of a     ##
##      'plotx.R' script.                                                               ##
##                                                                                      ##
##   2. Tidy up the data.                                                               ##
##   3. Join Date and Time columns into Date and force POSIXct class type               ##
##   4. Build the requested histogram chart.                                            ##
##   5. Clean up global environment.                                                    ##
##                                                                                      ##
## Input: None.                                                                         ##
##                                                                                      ##
## Input files:                                                                         ##
##   - The 'data/household_power_consumption.txt' file or                               ##
##     the 'data/070201-02_household_power_consumption.txt' file (depending of a        ##
##     previous execution of a 'plotx.R' script.                                        ##                                                         ##
##                                                                                      ##
## Output: The chart 'plot1', the file 'data/070201-02_household_power_consumption.txt' ##           ##
##                                                                                      ##
## Version:                                                                             ##
##      1.0 150206 Inital version (Eric)                                                ##
##                                                                                      ##
## Todo: NA                                                                             ##
##########################################################################################

file <- "data/household_power_consumption.txt"
savedfile <- "data/070201-02_household_power_consumption.txt"
#
# Read File into data table PowerCons 
#
#   Optimisation:
#       If the required subset of data to construct the charts has already been
#       saved in the file 'savedfile', use this file.
#       Otherwise retrieve subset from 'file' file and save it in 'savedfile'
#
if(!file.exists(savedfile)) {
#
# Specifying the colums classess speeds up read.table
#
    VarClass <- c(rep('character', 2), rep('numeric', 7))
    PowerCons <- read.table(file, sep=";", header=TRUE, na.strings="?", colClasses=VarClass) 
    PowerCons <- PowerCons[PowerCons$Date == '1/2/2007' | PowerCons$Date == '2/2/2007', ]
#
# Tidying up variables
#
    cnames <- c('Date','Time','GlobalActivePower','GlobalReactivePower','Voltage','GlobalIntensity', 
        'SubMetering1','SubMetering2','SubMetering3')
    colnames(PowerCons) <- cnames
#
# Join Date and Time columns into Date and force POSIXct class type
#
    PowerCons$Date <- as.POSIXct(strptime(paste(PowerCons$Date,PowerCons$Time), "%d/%m/%Y %H:%M:%S"))
    write.table(PowerCons, savedfile, sep=';', row.names=FALSE) 
} else {
    PowerCons <- read.table(savedfile, sep=";", header=TRUE)
    PowerCons$Date <- as.POSIXct(PowerCons$Date)
}
#
# Build histogram chart
#
png(filename="plot1.png", width=480,height=480, units="px") 
hist(PowerCons$GlobalActivePower, main="Global Active Power",
     xlab="Global Active Power (kilowatts)", col="red") 
dev.off()
#
# Cleaning
#
rm(list=ls(all = TRUE))