import geopandas as gpd
import matplotlib.pyplot as plt

# Step 1: Read the shapefile
shapefile_path = r"/Users/jayarajupakki/Documents/Phd/Thesis/Powai/India_Shape/india_st.shx"
gdf = gpd.read_file(shapefile_path)

# Step 2: Define the specific locations for Powai and Wayanad
locations = {
    'Powai': (19.130378110700605, 72.91883006500723),
    'Wayanad': (11.674160398536493, 75.94263875385893)
}

# Step 3: Plot the shapefile
fig, ax = plt.subplots(figsize=(10, 10))
gdf.plot(ax=ax, color='lightgray', edgecolor='black')

# Step 4: Plot the specific locations with symbols
plt.scatter(locations['Powai'][1], locations['Powai'][0], color='red', marker='o', s=50, label='Powai')
plt.scatter(locations['Wayanad'][1], locations['Wayanad'][0], color='Green', marker='^', s=50, label='Wayanad')

# Step 5: Customize the plot to show latitude on the right
plt.title("Specific Sampling Locations: Powai and Wayanad")
plt.xlabel("Longitude")
plt.ylabel("Latitude")

# Display latitudes on the right side
ax.yaxis.tick_right()
ax.yaxis.set_label_position("right")

# Show the legend
plt.legend()

plt.show()
