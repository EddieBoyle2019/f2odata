## Libraries
library(tidyverse)
library(sf)

## Import data
#OAs polygons geometry shapefile from NRS (clipped to the Mean High Water Mark)
#N=46363
output_areas <- read_sf("OutputArea2022_MHW.shp")
#Scottish Govt. 2022 census data - UV101b (Usual resident population by sex by age (6 categories))
#N=46363
census_data_UV101b <- read_csv("census_2022_UV101b.csv")

## Link data
census_oa = inner_join (output_areas, census_data_UV101b)

## Export data
st_write(census_oa, "Census_2022_data_oa_uv101b.shp")