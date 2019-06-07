# ==========================================================================
# 2018 SHIFTS IN BUMBLE COMMUNITIES WITH AGRICULTURAL EXPANSION 
# Jeremy Hemberger - j.hemberger.wisc@gmail.com
# March 9, 2018

# Data from GBIF and USGS historical ag reconstruction
# Summarize and model community shifts and agricultural changes
# ==========================================================================

library(raster)
library(rgdal)
library(maps)
library(mapdata)
library(ggmap)
library(maptools)
library(mp)
library(tidyverse)
library(lme4)
library(lmerTest)
library(lsmeans)
library(multcomp)
library(colorspace)

GBIF.bumbles <- read_tsv("./2018_GBIF_Bumbles.csv", col_names = TRUE, na = "NA")
hist.ag <- read_csv("./2018_HistoricalAg_Pop.csv", col_names = TRUE, na = "NA")
census.code <- read_csv("./national_county_code.txt", col_names = (c("state", 
                                                                     "statefp",
                                                                     "countyfp",
                                                                     "countyname",
                                                                     "classfp")))
# Filter out bees with no coordinate information
GBIF.bumbles <- GBIF.bumbles %>%
  filter(!is.na(decimallatitude))
bumble.latlong <- data_frame(GBIF.bumbles$decimallongitude, 
                               GBIF.bumbles$decimallatitude)

# Add county/state to each observation
# Make bumble.latlong into spatial layer
bumble.points <- SpatialPoints(bumble.latlong)
# Load in county shapefile from US Census office
us.counties <- readOGR(".", "USCounties_Shapefile/cb_2015_us_county_5m")
# Match projections of layers
proj4string(bumble.points) <- proj4string(us.counties)
plot(us.counties)
plot(bumble.points, add = TRUE)
# Query which county each point is in/on
bumble.county <- data_frame(over(bumble.points, us.counties)$NAME)
colnames(bumble.county) <- c("county")
bumble.state <- data_frame(over(bumble.points, us.counties)$STATEFP)
colnames(bumble.state) <- c("statefp")
bumble.state$state <- census.code$state[match(as.vector(bumble.state$statefp), 
                                        census.code$statefp)]

GBIF.bumbles$state <- bumble.state$state
GBIF.bumbles$county <- bumble.county$county

GBIF.bumbles.sum <- GBIF.bumbles %>%
  group_by(state, county) %>%
  filter(state != "AK") %>%
  summarise(n.bumbles = n())
colnames(GBIF.bumbles.sum) <- c("region", "subregion", "n.bumbles")
GBIF.bumbles.sum$subregion <- tolower(GBIF.bumbles.sum$subregion)

GBIF.species.sum <- GBIF.bumbles %>%
  group_by(state) %>%
  filter(state != "AK") %>%
  summarise(n.species = n_distinct(species))
colnames(GBIF.species.sum) <- c("abb", "n.species")

state.fips <- state.fips
polyname <- state.fips$polyname
abb <- data_frame(state.fips$abb)
polyname <- data_frame(gsub(":.*", "", polyname))
state.abb <- bind_cols(abb, polyname)
colnames(state.abb) <- c("abb", "region")
GBIF.species.sum <- left_join(GBIF.species.sum, state.abb, by = "abb")

us.county.50 <- read_csv("./counties.csv")
us.county.48 <- us.county.50 %>%
  filter(region != "alaska" & region != "hawaii")
us.states <- maps::map("state", ".", exact = FALSE, plot = FALSE, fill = TRUE) %>% 
  fortify()


bumble.by.county <- left_join(us.county.48, GBIF.bumbles.sum, by = "subregion")
species.by.state <- left_join(us.states, GBIF.species.sum, by = "region")

# us.50 <- census.code %>%
#   filter(statefp <= 56 & statefp != 15 & state != "AK")
# us.counties.50 <- us.counties[us.counties$STATEFP %in% us.50$statefp, ]
base.us.counties <- ggplot(data = bumble.by.county, mapping = aes(x = long, 
                                                                  y = lat, 
                                                                  group = group)) + 
  coord_map() + 
  geom_polygon() +
  theme_minimal()

base.us.state <- ggplot(data = species.by.state, mapping = aes(x = long,
                                                        y = lat, 
                                                        group = group)) + 
  coord_map() + 
  geom_polygon() + 
  theme_nothing()

bumble.plot <- base.us.counties + 
  geom_polygon(data = bumble.by.county, aes(fill = log(n.bumbles))) + 
  scale_fill_gradient(low = "white", high = "darkred") +
  theme_minimal()

bumble.species.plot <- base.us.state + 
  geom_polygon(data = species.by.state, aes(fill = n.species)) + 
  scale_fill_distiller(palette = "Reds", direction = 1) + 
  theme_nothing(legend = TRUE) + 
  labs(fill = "Number of Species") + 
  theme(legend.position = "bottom")


n.by.state <- GBIF.bumbles %>%
  group_by(state) %>%
  summarise(n = n())


