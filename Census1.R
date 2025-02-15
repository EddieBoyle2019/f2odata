## Libraries
library(tidyverse)
library(sf)

## Import data
# OAs polygons geometry shapefile from NRS (clipped to the Mean High Water Mark)
# N=46363
output_areas <- read_sf("OutputArea2022_MHW.shp")
# Scottish Govt. 2022 census data - UV101b (Usual resident population by sex by age (6 categories))
# N=46363
census_data_UV101b <- read_csv("census_2022_UV101b.csv")

## Link data
census_oa = inner_join (output_areas, census_data_UV101b)

## Transform and wrangle data
# Rename and limit attributes
census_oa %>%
	select(1, 12, 13:19) %>%
	rename('OA code' = code) %>%
	rename('Total pop.' = 3, 'Age 0-15' = 4, 'Age 16-24' = 5, 'Age 25-34' = 6, 'Age 35-49' = 7, 'Age 50-64' = 8, 'Age 65 and over' = 9) %>%
	select('OA code', geometry, 'Total pop.', 'Age 0-15', 'Age 16-24','Age 25-34', 'Age 35-49', 'Age 50-64', 'Age 65 and over') -> census_oa_transformed

## Export data
# Note that attribute names are abbreviated for the ESRI Shapefile format
st_write(census_oa_transformed, "Census_2022_data_oa_uv101b.shp")