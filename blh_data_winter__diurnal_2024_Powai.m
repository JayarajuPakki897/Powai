% Define file path and target coordinates
cd /Users/jayarajupakki/Documents/Phd/Thesis/Powai
filen = 'adaptor.mars.internal-1722680842.9241455-3857-13-7f597a8c-6e14-401e-985e-24d20212d0f4.nc';
target_lat = 19.130378110700605;
target_lon = 72.91883006500723;

% Read variables from NetCDF file
blh = ncread(filen, 'blh');
time = ncread(filen, 'time'); % Time dimension
lon = ncread(filen, 'longitude'); % Longitude dimension
lat = ncread(filen, 'latitude'); % Latitude dimension

% Convert time to datetime
base_date = datetime(1900, 1, 1);
actual_dates = base_date + hours(time);

% Convert from UTC to IST by adding 5.5 hours
actual_dates_IST = actual_dates + hours(5.5);

% Find the nearest latitude and longitude indices
[~, lat_idx] = min(abs(lat - target_lat));
[~, lon_idx] = min(abs(lon - target_lon));

% Extract the blh data for the nearest point
blh_near = squeeze(blh(lon_idx, lat_idx, :));

% Remove NaN values from blh_near
blh_near_nonan = blh_near(~isnan(blh_near));

% Select the needed range of data
blh_needed = blh_near_nonan(337:1344);
time_needed = actual_dates_IST(337:1344); % Use IST time

% Calculate the diurnal variation
hours_of_day = hour(time_needed);
unique_hours = unique(hours_of_day);

% Preallocate an array to store the mean BLH for each hour
mean_blh = zeros(length(unique_hours), 1);

% Calculate the mean BLH for each hour of the day
for i = 1:length(unique_hours)
    hour_idx = hours_of_day == unique_hours(i);
    mean_blh(i) = mean(blh_needed(hour_idx));
end

% Plot the diurnal variation of BLH
figure;
plot(unique_hours, mean_blh, '-o', 'LineWidth', 2); % Set line width to make the plot line bold
xlabel('Hour of Day (IST)', 'FontWeight', 'bold'); % Update label to indicate IST
ylabel('Mean Boundary Layer Height (m)', 'FontWeight', 'bold');
title('Diurnal Variation of Boundary Layer Height for Winter 2024 in Powai', 'FontWeight', 'bold');
set(gca, 'FontWeight', 'bold'); % Set bold for tick labels
grid on;

% Create a table with the needed data
data_table = table(time_needed, blh_needed, 'VariableNames', {'Time_IST', 'BoundaryLayerHeight'});

% Save the table to an Excel file
output_filename = 'blh_data_winter_2024_Powai_IST.xlsx';
writetable(data_table, output_filename);
