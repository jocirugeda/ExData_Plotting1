# Donwload File from internet
fileUrl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl,destfile="household_power_consumption.zip",method="curl")
rm(fileUrl)

# Unzip file contens
unzip("household_power_consumption.zip")


# create output file with the filtered rows from the huge input File
outFD <- file("FEB1_2_2007.txt", "w")  # open an output file connection        
inputFD<- file("household_power_consumption.txt", "r",blocking = FALSE) 

# read copy head of file 
head_ff<-readLines(inputFD,1)
writeLines(head_ff[1],outFD) # head of files copied to output file
rm(head_ff)
# iterate throw input file rows - blocks of 100 rows each
list_lines<-readLines(inputFD,100)           
while(length(list_lines)>0){                
        for (line in list_lines){
                # filter row that start with the day 
                if (grepl("^1/2/2007",line)){ 
                        # write line to output file
                        writeLines(line,outFD)                
                }
                if (grepl("^2/2/2007",line)){                        
                        # write line to output file
                        writeLines(line,outFD)                
                }                
        }
        rm(line)
        # read new block of rows
        list_lines<-readLines(inputFD,100)                              
} 
rm(list_lines)
# close file connections
close(outFD)
close(inputFD)  
rm(outFD)
rm(inputFD)

# remove input files from disk
file.remove("household_power_consumption.zip")
file.remove("household_power_consumption.txt")

# read filtered data from output file
# setting for dataframe:
# decimal point dec="."
# separator sep=";"
# NA value  na.strings="?"
# colClasses colClasses=c("character","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric")

acs<-read.csv("FEB1_2_2007.txt",dec=".",sep=";",na.strings="?",colClasses=c("character","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric"))

# remove output data file from disk
file.remove("FEB1_2_2007.txt")

# create DateTime Column 
acs$DateTime <- as.POSIXct(paste(acs$Date, acs$Time), format="%d/%m/%Y %H:%M:%S")

# plot 2   480 pixels and a height of 480 pixels.
# open png device
png(filename = "plot2.png",
    width = 480, height = 480, units = "px", pointsize = 12,
    bg = "white")

# plot generation
with(acs,plot(DateTime,Global_active_power,type = "n",ylab="Global Active Power (kilowatts)",xlab=""))
with(acs,lines(DateTime,Global_active_power))
# close device
dev.off() 

# clean Environment
rm(acs)
