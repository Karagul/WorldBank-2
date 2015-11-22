suppressPackageStartupMessages(library(reshape2))
suppressPackageStartupMessages(library(data.table))
## First read in World Bank HealthStats data from local copy
world.db <- read.csv("8_Topic_en_csv_v2.csv", header = TRUE, skip = 4)
worldEco.db <- read.csv("3_Topic_en_csv_v2.csv", header = TRUE, skip = 4)

## For this application we will focus on data from 2000
years <- c(1970:2014)
xyears <- as.vector(sapply("X",paste,years, sep=""))

# First, process healthstats dataset
world.db <- world.db[,c('Country.Code', 'Country.Name', 'Indicator.Name', xyears)]
completes <- complete.cases(world.db[,xyears])
uniq <- world.db[completes,"Indicator.Name"]
world.db <- subset(world.db, Indicator.Name %in% uniq)

timeSeriesNames <- as.vector(unique(world.db$Indicator.Name))
timeSeriesCode<- unique(world.db$Indicator.Code)

# Now process Econ dataset
worldEco.db <- worldEco.db[,c('Country.Code', 'Country.Name', 'Indicator.Name', xyears)]
completes <- complete.cases(worldEco.db[,xyears])
uniq <- worldEco.db[completes,"Indicator.Name"]
worldEco.db <- subset(worldEco.db, Indicator.Name %in% uniq)

timeSeriesNamesEco <- as.vector(unique(worldEco.db$Indicator.Name))
timeSeriesCodeEco<- unique(worldEco.db$Indicator.Code)

# Merge the two datasets
world.db <- rbind(world.db,worldEco.db)
timeSeriesNames <- c(timeSeriesNames,timeSeriesNamesEco)
timeSeriesCodes <- c(timeSeriesCode, timeSeriesCodeEco)

countryNames <- unique(world.db$Country.Name)
countryCodes <- unique(world.db$Country.Code)

# regions2.csv is a list of country codes and their associated region of the world.
regions.db <- read.csv("regions2.csv", header = TRUE)
regions.db <- regions.db[,c('Economy','Code','Region')]
# merge world.db and regions.db by matching country codes
world.db <- merge(world.db,regions.db,by.x = "Country.Code", by.y = "Code")
# then keep only the necessary fields
world.db <- world.db[,c('Country.Code', 'Country.Name', 'Region', 'Indicator.Name', xyears)]

#Change colnames to remove "X" from the front of the year variables
colnames(world.db)[colnames(world.db) %in% xyears] <- as.character(years)

#n now melt world.db
world.db <- melt(world.db, id.vars = c("Country.Code", "Country.Name", "Indicator.Name","Region"), measure.vars = as.character(years))
world.db$variable <- as.numeric(as.character(world.db$variable))

