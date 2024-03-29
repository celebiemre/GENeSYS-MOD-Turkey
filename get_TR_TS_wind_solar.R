###########################
####  ###
####  ###
##   ##      RENEWABLES.NINJA
#####       WEBSITE AUTOMATOR
##
#
#  simple instructions:
#    change any file paths in this script from './path/to/' to the directory where you saved the R and CSV files
#    change the token string to match that from your user account
#    run through the five simple examples below
#




#####
## ##  MODEL SETUP
#####

# pre-requisites
library(curl)
source('ninja_automator.r')

# insert your API authorisation token here
token = '!YOUR TOKEN HERE!'

# establish your authorisation
h = new_handle()
handle_setheaders(h, 'Authorization'=paste('Token ', token))





#####
## ##  DOWNLOAD RENEWABLE TIME SERIES DATA FOR A SINGLE LOCATION
#####

# EXAMPLE 1 ::: look at a very tall wind turbine on top of iain's house
#               optional args are (for example): from='2014-01-01', to='2014-12-31', dataset='merra2', capacity=1, height=60, turbine='Vestas+V80+2000' 
# w = ninja_get_wind(lat=51.5, lon=0, height=30)
# plot(w$time, w$output, type='l', col='blue')


# EXAMPLE 2 ::: or the solar panels facing south-east on stefan's house
#               optional args are (for example): from='2014-01-01', to='2014-12-31', dataset='merra2', capacity=1, system_loss=10, tracking=0, tilt=35, azim=180
# s = ninja_get_solar(47.5, 8.5, tilt=15, azim=135)
# lines(s$time, s$output, col='goldenrod')


#install.packages("tidyverse")
library(tidyverse)
#####
## ##  DOWNLOAD RENEWABLE TIME SERIES DATA FOR MULTIPLE LOCATIONS
#####

# EXAMPLE 3 ::: look at wind farms in each of the UK's capitals
#               args are the same as for ninja_get_wind - either pass a single values or vectors of values
coordinates=read.csv('Lon_Lat_of_Centroids_TR_NUTS1and3_levels.csv', stringsAsFactors=FALSE)
library(dplyr)
coordinates_TR <- coordinates %>% select(X,Y,NUTS_ID,LEVL_CODE,NUTS_NAME) %>% filter(LEVL_CODE==1)  #MAY NOT WORK IF EXCEEDING 50 locations LIMIT on renewables.ninja website
#coordinates_TR <- coordinates %>% select(X,Y,NUTS_ID,LEVL_CODE) %>% filter(LEVL_CODE==3) #NOT WORKING SINCE IT EXCEEDS 50 LIMIT on renewables.ninja website
coordinates_TR <- coordinates %>% select(X,Y,NUTS_ID,LEVL_CODE) %>% filter(LEVL_CODE==3) %>% filter(row_number() %in% 1:40) #FILTER FIRST 40
#coordinates_TR <- coordinates %>% select(X,Y,NUTS_ID,LEVL_CODE) %>% filter(LEVL_CODE==3) %>% filter(row_number() %in% 41:81) #FILTER THE REST
library(DT)
datatable(coordinates_TR)

lon=coordinates_TR$X #X-values
lat=coordinates_TR$Y #Y-values


#default wind 2014 data at NUTS Level 1
#turbine = rep('Vestas+V80+2000', each=12)
#'Enercon+E66+1800', 'Siemens+SWT+2.3+93', 'GE+1.5sl')
#y_wind = ninja_aggregate_wind(lat, lon)
#write_csv(y_wind, 'renewables.ninja.wind.output_TR_level_1.csv', row.names=FALSE)

#wind 2018 data at NUTS Level 3
y_wind3_1 = ninja_aggregate_wind(lat, lon, from='2018-01-01', to='2018-12-31') #FIRST 40 cities AS ninja.renewables has a 50 limit!
#y_wind3_2 = ninja_aggregate_wind(lat, lon, from='2018-01-01', to='2018-12-31') #REST OF 41 cities AS ninja.renewables has a 50 limit!
write_csv(y_wind3_1, 'renewables.ninja.wind.output_TR_level_3_2018_part1.csv', row.names=FALSE)
#write_csv(y_wind3_2, 'renewables.ninja.wind.output_TR_level_3_2018_part2.csv', row.names=FALSE)

#default solar PV 2014 data at NUTS Level 1
#y_solar = ninja_aggregate_solar(lat, lon)
#write_csv(y_solar, 'renewables.ninja.solar.output_TR_level_1.csv', row.names=FALSE)

#Solar PV 2018 data at NUTS Level 3
y_solar3_1 = ninja_aggregate_solar(lat, lon, from='2018-01-01', to='2018-12-31') #FIRST 40 cities AS ninja.renewables has a 50 limit!
#y_solar3_2 = ninja_aggregate_solar(lat, lon, from='2018-01-01', to='2018-12-31') #REST OF 41 cities AS ninja.renewables has a 50 limit!
write_csv(y_solar3_1, 'renewables.ninja.solar.output_TR_level_3_2018_part1.csv', row.names=FALSE)
#write_csv(y_solar3_2, 'renewables.ninja.solar.output_TR_level_3_2018_part2.csv', row.names=FALSE)

# how does the hourly data look?
# dev.new(width=20)
# plot(y$time, y$outputV1, type='l', col='#0E60BA')
# lines(y$time, y$outputV2, col='#C80028')
# lines(y$time, y$outputV3, col='#2E8C39')
# lines(y$time, y$outputV4, col='#FFCF01')
# 
# # how do they correlate?
# dev.new()
# plot(y[ , -1], pch='.')

# what about the daily averages?
# yd = aggregate(y, by=list(as.Date(y$time)), mean)
# dev.new(width=20)
# plot(yd$time, yd$outputV1, type='l', col='#0E60BA')
# lines(yd$time, yd$outputV2, col='#C80028')
# lines(yd$time, yd$outputV3, col='#2E8C39')
# lines(yd$time, yd$outputV4, col='#FFCF01')




#####
## ##  DOWNLOAD RENEWABLE TIME SERIES DATA FOR MULTIPLE LOCATIONS
## ##  USING CSV FILES FOR DATA INPUT AND OUTPUT
#####	

# EXAMPLE 4 :::: read a set of wind farms from CSV - save their outputs to CSV
#                this is the same as example 3 - the UK capital cities
#    your csv must have a strict structure: one row per farm, colums = lat, lon, from, to, dataset, capacity, height, turbine - and optionally name (all lowercase!)

# farms = read.csv('./path/to/renewables.ninja.wind.farms.csv', stringsAsFactors=FALSE)
# 
# z = ninja_aggregate_wind(farms$lat, farms$lon, farms$from[1], farms$to[1], farms$dataset, farms$capacity, farms$height, farms$turbine)
# 
# write.csv(z, './path/to/renewables.ninja.wind.output.csv', row.names=FALSE)
# 
# 
# 
# # EXAMPLE 5 :::: read a set of solar farms from CSV - save their outputs to CSV
# #                this is the ten largest US cities - and uses the 'name' column to identify our farms
# #    your csv must have a strict structure: one row per farm, colums = lat, lon, from, to, dataset, capacity, system_loss, tracking, tilt, azim - and optionally name (all lowercase!)
# 
# farms = read.csv('./path/to/renewables.ninja.solar.farms.csv', stringsAsFactors=FALSE)
# 
# z = ninja_aggregate_solar(farms$lat, farms$lon, farms$from[1], farms$to[1], farms$dataset, farms$capacity, farms$system_loss, farms$tracking, farms$tilt, farms$azim, name=farms$name)
# 
# write.csv(z, './path/to/renewables.ninja.solar.output.csv', row.names=FALSE)
# 
# # how productive are these places
# colMeans(z[ , -1]) / farms$capacity




# now you know the way of the ninja
# use your power wisely
# fight bravely
