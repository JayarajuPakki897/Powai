# Install and load required packages

library(ncdf4)
library(openair)

# Set the directory and file name
setwd("F:/Ph.D/Thesis/Powai")
filen <- "data.nc"

# Open the NetCDF file
nc_data <- nc_open(filen)

# Read variables from the .nc file
u10 <- ncvar_get(nc_data, "u10")
v10 <- ncvar_get(nc_data, "v10")
time <- ncvar_get(nc_data, "time")
lon <- ncvar_get(nc_data, "longitude")
lat <- ncvar_get(nc_data, "latitude")

# Define target location Powai
target_lat <- 19.130378110700605
target_lon <- 72.91883006500723

# Convert time to datetime
base_date <- as.POSIXct("1900-01-01 00:00:00", tz = "UTC")
actual_dates <- base_date + time * 3600

# Find the nearest latitude and longitude indices
lat_idx <- which.min(abs(lat - target_lat))
lon_idx <- which.min(abs(lon - target_lon))

# Extract data for the nearest location
u10_near <- u10[lon_idx, lat_idx, ]
v10_near <- v10[lon_idx, lat_idx, ]

# Filter data for January and February
months <- as.numeric(format(actual_dates, "%m"))
jan_feb_idx <- which(months == 1 | months == 2)
u10_filtered <- u10_near[jan_feb_idx]
v10_filtered <- v10_near[jan_feb_idx]
dates_jan_feb <- actual_dates[jan_feb_idx]

# Calculate wind speed and direction
wind_speed <- sqrt(u10_filtered^2 + v10_filtered^2)
wind_direction <- (atan2(v10_filtered, u10_filtered) * 180 / pi + 360) %% 360

# Prepare data frame for wind rose plot
wind_data <- data.frame(
  date = dates_jan_feb,
  wd = wind_direction,
  ws = wind_speed
)

# Save the plot as a PNG image
png("wind_rose_jan_feb_powai.png", width = 1600, height = 1200, res = 300)
windRose(wind_data, ws = "ws", wd = "wd", angle = 10, paddle = FALSE,
         key = list(header = "Wind Speed (m/s)", footer = "", space = "right"),
         main = "Wind Rose for January and February in Powai",
         par.settings = list(fontsize = list(text = 10, points = 9), 
                             fontface = "bold"))
dev.off()

