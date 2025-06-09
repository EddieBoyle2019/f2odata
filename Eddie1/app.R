library(shiny)
library(sf)
library(leaflet)

map <- st_read("SIMD_2020_F2OAOI.shp")
map_ll <- st_transform(map, "+proj=longlat +ellps=WGS84 +datum=WGS84")

# ui object
ui <- fluidPage(
  titlePanel(p("Spatial app", style = "color:#3474A7")),
)

ui <- fluidPage(leafletOutput("map", height = "100vh"))

# server()
server <- function(input, output) {
  output$map <- renderLeaflet({
    pal_f2o <- colorFactor("RdBu", domain = map_ll$Quintilev2)
    leaflet() %>%
      addTiles() %>%
       addPolygons(
        data=map_ll, 
        fillColor = ~pal_f2o(Quintilev2), 
        fillOpacity = 0.5, 
        color = "black",
        weight = 1,
        popup = paste("Datazone: ", map_ll$DZName, "<br>", "SIMD value: ", map_ll$Quintilev2, "<br>")
        ) %>%
      addLegend(
        "bottomright", 
         pal = pal_f2o, 
         values = map_ll$Quintilev2,
         title = "SIMD 2020 quintiles",
         opacity = 1
        ) %>%
      setView(lng = -3.5, lat = 56, zoom = 8)
  })
}

# shinyApp()
shinyApp(ui = ui, server = server)