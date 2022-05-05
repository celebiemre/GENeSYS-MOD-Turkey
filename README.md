# GENeSYS-MOD-Turkey
GENeSYS-MOD Turkey (Disaggregated at NUTS level 1, i.e., 12 regions)
---

# INTRODUCTION
This report summarizes the efforts on data collection for solar PV and wind time series (hourly capacity factors) data for Turkey. In order to modify it for any EU region, see below, section "MODIFYING FOR ANY REGION". 

We have employed [renewables.ninja](https://www.renewables.ninja/) website to collect wind and solar PV time series data. Different than most EU countries, there is no hourly solar PV or wind capacity factor data for Turkey in this website, nor it has any regional disaggregation at NUTS level 1 (12 regions) or 3 (81 cities). Only point data is available, which requires coordinates (in longitude and lattitude). 

# FINDING THE CENTROIDS of TR REGIONS at NUTS LEVEL 1 & 3
* In order to do so, we firstly used the shape data file for EU (available at [this link](https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units/nuts) or Google for the .shp filename below) and then find the centroids for each polygon (of each NUTS level 1 & 2 & 3) in this shape file. We have used several R packages, specifically *sf* package to encode spatial vector data. Other packages are for data manipulation and visualization/tabulation.

```{r}
library(stringr)
library(leaflet)
library(sf)
library(dplyr)
library(mapview)
library(DT)

nuts_EU = st_read("NUTS_RG_20M_2021_3035.shp") %>% 
      st_simplify(dTolerance = 1000) %>%
      sf::st_transform('+init=epsg:4326')

```
* We add the centroid of each polygon as a separate geometry column and then filter Turkish NUTS level 1 and 3 regions.
```{r}
nuts_EU$geom2 = st_centroid(nuts_EU)
#NUTS1_EU$geom2 

library(dplyr)
nuts_EU_centers=as.data.frame(nuts_EU$geom2[,c(1,2,10)])

#datatable(nuts_EU_centers)
# FILTER TR values
nuts_EU_centers_TR <-  nuts_EU$geom2 %>% filter(grepl('TR', NUTS_ID))
#str(nuts_EU_centers_TR)
#head(nuts_EU_centers_TR)
datatable(nuts_EU_centers_TR)

```
# Centroids of TR Regions
* Finally, we visulize the centroids of all regions on a map.
```{r, out.width = '100%'}
nuts_EU_TR = nuts_EU %>% filter(grepl('TR', NUTS_ID))
labels <- sprintf("<strong>%s</strong>", nuts_EU_TR$NUTS_ID) %>% lapply(htmltools::HTML)

  leaflet(data = nuts_EU_TR) %>%
  addTiles() %>% 
  addProviderTiles(providers$CartoDB.Positron) %>%
  addPolygons(data = nuts_EU_TR,
              color = "#b13a3a", 
              weight = 1,
              smoothFactor = 0.5, 
              fillOpacity = 0.2,
              #label = nuts_EU_TR$NUTS_ID, 
              #fillColor =#33333,
              label = labels,
              labelOptions = labelOptions(style = list("font-weight" = "normal", padding = "3px 8px"), textsize = "15px", direction = "auto"),
              stroke = T,
              highlightOptions = highlightOptions(
                weight = 5,
                color = "#666666",
                fillOpacity = 0.7)) %>% 
  addCircles(data = nuts_EU_TR$geom2, fill = TRUE, stroke = TRUE, color = "#000", fillColor = "blue", radius = 1600, weight = 1, label = labels, labelOptions = labelOptions(style = list("font-weight" = "normal", padding = "3px 8px"), textsize = "15px", direction = "auto"),)
```
# WRITE COORDINATES (longitude and latitude) TO CSV
```{r}
#st_write(nuts_EU_TR$geom2, "Lon_Lat_of_Centroids_TR_NUTS1and3_levels.csv", layer_options = "GEOMETRY=AS_XY")
```

# MODIFYING FOR ANY REGION
* In order to modify this time series data for any region:
1. Choose %YOUR REGION% in above code and run it to retrieve the centroids for all NUTS levels for your region.
```{r}
nuts_EU_centers_TR <-  nuts_EU$geom2 %>% filter(grepl('%YOUR REGION%', NUTS_ID))
```
2. Enter your own token value in get_TR_TS_wind_solar.R file in line 26:
```{r}
token = '!YOUR TOKEN HERE!'
```
3. Modify the get_TR_TS_wind_solar.R line 64, according to your %NUTS_LEVEL% and %NO_OF_ROWS%"
```{r}
coordinates_TR <- coordinates %>% select(X,Y,NUTS_ID,LEVL_CODE) %>% filter(LEVL_CODE==%NUTS_LEVEL%) %>% filter(row_number() %in% 1:%NO_OF_ROWS%) #FILTER FIRST %NO_OF_ROWS% DO NOT EXCEED 40 or 50 points at a time!
```
4. Run get_TR_TS_wind_solar.R to retrieve wind and PV time series.


# A NOTE ON RENEWABLES.NINJA WEBSITE and DATA GATHERING
* We have used ninja_automator.r that is available at [Github](https://github.com/renewables-ninja/ninja_automator) and used the coordinates of centroids of polygons for NUTS level 1 and 3 to gather these data from renewables.ninja website (the Github page of ninja.renewables have the necessary information, but there is a hourly data gathering limit of 50 querries,i.e., 50 points at once).

# OFFSHORE WIND DATA
* For offshore wind data, we have used the following study on offshore wind potential in TUrkey:
  * Emeksiz, C., & Demirci, B. (2019). The determination of offshore wind energy potential of Turkey by using novelty hybrid site selection method. Sustainable Energy Technologies and Assessments, 36, 100562.
  
* Accordingly 11 locations from this paper are selected:

1. Bandırma (TR2)
2. Bozcaada (TR2)
3. Gökçeada (TR2)
4. Karasu (TR4)
5. Antalya (TR6)	
6. Mersin (TR6)	
7. Bafra1 (TR8)
8. Bafra2 (TR8)
9. Inebolu (TR8)
10. Sinop1 (TR8)
11. Sinop2 (TR8)

* We have also selected several other locations that appear in another paper:
  * Argin, M., Yerci, V., Erdogan, N., Kucuksari, S., & Cali, U. (2019). Exploring the offshore wind energy potential of Turkey based on multi-criteria site selection. Energy Strategy Reviews, 23, 33-46.
* These regions are:

12. Burhaniye (TR2)
13. Saros (TR2)
14. Dikili (TR3)
15. Karaburun (TR3)

* Then single offshore points for these locations are selected from the renewables.ninja website wind capacity factors are downloaded. These factors are then averaged for each TR NUTS level 1 region.

# FINAL REMARKS
These efforts, however, does not complete the hourly onshore wind, offshore wind and PV time series data required for GENeSYS-MOD. We also need 3 sub-technologies for each of these hourly datasets (the values in parentheses shows the multipliers for capacity factors we have used for each sub technology) 

  * **PV:** inf (0.70), avg (0.85) opt or base (1)
  * **WINDONSHORE:** inf (0.70), avg or base (1), opt (0.85)
  * **WINDOFFSHORE:** shallow (0.85), deep (0.70) and base or wind_offshore (1)

* Moreover, there are other factors that needs to be considered, however, we have no data sources for Hydro dispatchable nor for Hydro (RoR) capacity factors at NUTS Level 1 disaggregation. Furthermore, load data is also available at NUTS Level 0. Therefore, we have used the TR data currently available in GENeSYS-MOD database for NUTS Level 0.
