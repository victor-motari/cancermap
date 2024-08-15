# Install necessary packages if not already installed
install.packages(c("leaflet", "sf", "dplyr", "htmlwidgets"))
install.packages("rmarkdown")

# Load necessary libraries
library(leaflet)
library(sf)
library(dplyr)
library(htmlwidgets)

# Generate sample data for breast cancer patients in Tanzania
set.seed(123)
tanzania_patients <- data.frame(
  longitude = runif(100, min = 29.5, max = 40.5),  # Adjusted longitude range for Tanzania
  latitude = runif(100, min = -11.5, max = -1.0),  # Adjusted latitude range for Tanzania
  intensity = runif(100, min = 1, max = 10)
)

# Convert to a spatial data frame
tanzania_patients_sf <- st_as_sf(tanzania_patients, coords = c("longitude", "latitude"), crs = 4326)

# Define a color palette function based on intensity
pal <- colorNumeric(palette = "Reds", domain = tanzania_patients_sf$intensity)

# Create the leaflet map
tanzania_map <- leaflet(data = tanzania_patients_sf) %>%
  addTiles() %>%
  addCircleMarkers(
    radius = ~sqrt(intensity) * 3,
    color = ~pal(intensity),
    fillOpacity = 0.5,
    stroke = FALSE,
    label = ~paste("Patients:", intensity)
  ) %>%
  addLegend(
    position = "bottomright",
    pal = pal,
    values = ~intensity,
    title = "Intensity of Breast Cancer Cases",
    opacity = 1
  )

# Save the map to an HTML file
saveWidget(tanzania_map, file = "tanzania_breast_cancer_heatmap.html", selfcontained = TRUE)

# Output message
cat("The map has been saved as 'tanzania_breast_cancer_heatmap.html'. You can upload this file to a hosting service to share it publicly.")
