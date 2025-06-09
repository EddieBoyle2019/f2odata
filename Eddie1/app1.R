library(shiny)
library(sf)
library(leaflet)

map <- st_read("SIMD_2020_F2OAOI.shp")
map_ll <- st_transform(map, "+proj=longlat +ellps=WGS84 +datum=WGS84")

#head(my_shapefile)

#plot(my_shapefile['Rankv2'])

# ui object
ui <- fluidPage(
  titlePanel(p("Spatial app", style = "color:#3474A7")),
  mainPanel(
    leafletOutput(outputId = "map", height = "100vh"),
  )
)

ui <- fluidPage(leafletOutput("map", height = "100vh"))

# server()
server <- function(input, output) {
  output$map <- renderLeaflet({
    #pal <- colorBin("YlOrRd", domain = map_ll$Rankv2, bins = 7)
    #pal_f2o <- colorQuantile("RdBu", NULL, n = 5)
    #pal_f2o <- colorNumeric("RdBu", domain = map_ll$Quintilev2)
    pal_f2o <- colorFactor("RdBu", domain = map_ll$Quintilev2)
    leaflet() %>%
      addTiles() %>%
      #addPolygons(data=map_ll, weight = 2, fillColor = "yellow") %>%
      addPolygons(
        data=map_ll, 
        fillColor = ~pal_f2o(Quintilev2), 
        fillOpacity = 0.5, 
        color = "black",
        weight = 1
        ) %>%
      addLegend(
        "bottomright", 
         pal = pal_f2o, 
         values = map_ll$Quintilev2,
         title = "SIMD 2020 quintiles",
         #labFormat = labelFormat(prefix = "$"),
         opacity = 1
        ) %>%
      #addPolygons(
      #  fillColor = ~ pal(Rankv2),
      #  color = "white",
      #  dashArray = "3",
      #  fillOpacity = 0.7
      #) %>%
      setView(lng = -3.5, lat = 56, zoom = 8)
  })
}

# shinyApp()
shinyApp(ui = ui, server = server)