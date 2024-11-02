% Set the directory and file name
cd E:\Phd\Thesis\Powai
filen = 'data.nc';

% Read NO2, isoprene, and time data from the .nc file
no2 = ncread(filen, 'tcno2');
isoprene = ncread(filen, 'tc_c5h8'); % Reading isoprene data
time = ncread(filen, 'time'); % Time dimension
lon = ncread(filen, 'longitude'); % Longitude dimension
lat = ncread(filen, 'latitude');   % Latitude dimension

% Define target location Powai
target_lat = 19.130378110700605;
target_lon = 72.91883006500723;

% Convert time to datetime
base_date = datetime(1900, 1, 1);
actual_dates = base_date + hours(time);

% Find the nearest latitude and longitude indices
[~, lat_idx] = min(abs(lat - target_lat));
[~, lon_idx] = min(abs(lon - target_lon));

% Extract NO2 and isoprene data for the nearest location
no2_near = squeeze(no2(lon_idx, lat_idx, :));
isoprene_near = squeeze(isoprene(lon_idx, lat_idx, :));

% Calculate daily mean for NO2 and isoprene
daily_dates = dateshift(actual_dates, 'start', 'day');
[unique_dates, ~, idx_no2] = unique(daily_dates);
daily_mean_no2 = accumarray(idx_no2, no2_near, [], @mean);
[~, ~, idx_isoprene] = unique(daily_dates);
daily_mean_isoprene = accumarray(idx_isoprene, isoprene_near, [], @mean);

% Constants
molar_mass_NO2 = 46.0055; % g/mol
molar_mass_isoprene = 68.117; % g/mol
avogadro_number = 6.022e23; % molecules/mol
column_height = 8500; % meters
R = 8.314; % J/(mol·K)
T = 288.15; % Kelvin
P = 101325; % Pa

% Convert NO2 from kg/m² to ppb
no2_mol_per_m2 = daily_mean_no2 * 1000 / molar_mass_NO2;
no2_molecules_per_m2 = no2_mol_per_m2 * avogadro_number;
air_column_density = P / (R * T) * avogadro_number * column_height;
no2_ppb = no2_molecules_per_m2 / air_column_density * 1e9;

% Convert isoprene from kg/m² to µg/m³
isoprene_g_per_m2 = daily_mean_isoprene * 1000; % Convert kg/m² to g/m²
isoprene_concentration_m3 = isoprene_g_per_m2 / column_height * 1e6; % Convert g/m² to µg/m³

% Calculate the minimum detectable value for NO2 and convert to ppb
scale_factor_no2 = 3.4683e-10; % Using the scale factor from attributes
add_offset_no2 = 1.2893e-05;   % Using the add offset from attributes
stored_value_min_no2 = -32767; % Using the fill/missing value from attributes
actual_value_min_no2 = (stored_value_min_no2 * scale_factor_no2) + add_offset_no2;
min_no2_mol_per_m2 = actual_value_min_no2 * 1000 / molar_mass_NO2;
min_no2_molecules_per_m2 = min_no2_mol_per_m2 * avogadro_number;
min_no2_ppb = min_no2_molecules_per_m2 / air_column_density * 1e9;

% Calculate the minimum detectable value for isoprene and convert to µg/m³
scale_factor_isoprene = 1.2952e-11; % Using the scale factor from attributes
add_offset_isoprene = 4.244e-07;    % Using the add offset from attributes
stored_value_min_isoprene = -32767; % Using the fill/missing value from attributes
actual_value_min_isoprene = (stored_value_min_isoprene * scale_factor_isoprene) + add_offset_isoprene;
min_isoprene_g_per_m2 = actual_value_min_isoprene * 1000; % Convert kg/m² to g/m²
min_isoprene_concentration_m3 = min_isoprene_g_per_m2 / column_height * 1e6; % Convert g/m² to µg/m³

% Plot NO2
figure;
plot(unique_dates(15:58), no2_ppb(15:58), '-o');
xlabel('Date', 'FontWeight', 'bold');
ylabel('NO_2 Concentration (ppb)', 'FontWeight', 'bold');
title('Daily Mean NO_2 Concentration in ppb in Powai', 'FontWeight', 'bold');
grid on;
ylim([min_no2_ppb, max(no2_ppb)]);
%saveas(gcf, 'NO2_Concentration.png');

% Plot Isoprene
figure;
plot(unique_dates(15:58), isoprene_concentration_m3(15:58), '-o');
xlabel('Date', 'FontWeight', 'bold');
ylabel('Isoprene Concentration (µg/m³)', 'FontWeight', 'bold');
title('Daily Mean Isoprene Concentration in µg/m³ in Powai', 'FontWeight', 'bold');
grid on;
ylim([min_isoprene_concentration_m3, max(isoprene_concentration_m3)]);
%saveas(gcf, 'Isoprene_Concentration.png');




% Set the directory and file name
cd E:\Phd\Thesis\Powai
filen = 'data.nc';

% Read NO2, isoprene, and time data from the .nc file
no2 = ncread(filen, 'tcno2');
isoprene = ncread(filen, 'tc_c5h8'); % Reading isoprene data
time = ncread(filen, 'time'); % Time dimension
lon = ncread(filen, 'longitude'); % Longitude dimension
lat = ncread(filen, 'latitude');   % Latitude dimension

% Define target location Powai
target_lat = 19.130378110700605;
target_lon = 72.91883006500723;

% Convert time to datetime
base_date = datetime(1900, 1, 1);
actual_dates = base_date + hours(time);

% Find the nearest latitude and longitude indices
[~, lat_idx] = min(abs(lat - target_lat));
[~, lon_idx] = min(abs(lon - target_lon));

% Extract NO2 and isoprene data for the nearest location
no2_near = squeeze(no2(lon_idx, lat_idx, :));
isoprene_near = squeeze(isoprene(lon_idx, lat_idx, :));

% Calculate daily mean for NO2 and isoprene
daily_dates = dateshift(actual_dates, 'start', 'day');
[unique_dates, ~, idx_no2] = unique(daily_dates);
daily_mean_no2 = accumarray(idx_no2, no2_near, [], @mean);

% Create a table with dates and NO2 values
no2_table = table(unique_dates, daily_mean_no2, 'VariableNames', {'Date', 'Mean_NO2'});

% Display the table
disp(no2_table);






% Assuming pOWAI2024CPCBDATA is already defined and cleaned

% Display the original table (optional)
disp('Original Table:');
disp(pOWAI2024CPCBDATA);

% Remove rows with NaN in VarName6
pOWAI2024CPCBDATA = pOWAI2024CPCBDATA(~isnan(pOWAI2024CPCBDATA.VarName6), :);

% Convert 'PrescribedStandards' to datetime for daily mean calculation
pOWAI2024CPCBDATA.PrescribedStandards = datetime(pOWAI2024CPCBDATA.PrescribedStandards, 'InputFormat', 'dd-MM-yyyy HH:mm');

% Calculate daily mean
daily_dates = dateshift(pOWAI2024CPCBDATA.PrescribedStandards, 'start', 'day');
[unique_dates, ~, idx] = unique(daily_dates);
daily_mean_values = accumarray(idx, pOWAI2024CPCBDATA.VarName6, [], @mean);

% Create a table for daily means
daily_mean_table = table(unique_dates, daily_mean_values, 'VariableNames', {'Date', 'DailyMean'});

% Display the daily mean table
disp('Daily Mean Table:');
disp(daily_mean_table);


% Assuming daily_mean_table and no2_table are already defined

% Display the original daily mean tables (optional)
disp('Daily Mean Table:');
disp(daily_mean_table);

disp('NO2 Table:');
disp(no2_table);

% Perform inner join on the two tables using the 'Date' column
common_dates_table = innerjoin(daily_mean_table, no2_table, 'Keys', 'Date');

% Display the new table with common dates
disp('Table with Common Dates:');
disp(common_dates_table);



% Assuming common_dates_table is already defined

% Define the column height (in meters)
column_height = 8500; % m

% Convert Mean_NO2 from kg/m² to kg/m³
mean_no2_kg_m3 = common_dates_table.Mean_NO2 / column_height;

% Convert kg/m³ to µg/m³
mean_no2_ug_m3 = mean_no2_kg_m3 * 1e6;

% Add the new µg/m³ column to the table
common_dates_table.Mean_NO2_ug_m3 = mean_no2_ug_m3;

% Display the updated table
disp('Common Dates Table with Mean NO2 in µg/m³:');
disp(common_dates_table);



% Assuming common_dates_table is already defined with Mean_NO2_ug_m3

% Extract the variables for regression
x = common_dates_table.DailyMean;          % Daily Mean
y = common_dates_table.Mean_NO2_ug_m3;    % Mean NO2 in µg/m³

% Fit a linear regression model
p = polyfit(x, y, 1); % p(1) is the slope, p(2) is the intercept
y_fit = polyval(p, x); % Calculate fitted values

% Calculate R²
SS_tot = sum((y - mean(y)).^2); % Total sum of squares
SS_res = sum((y - y_fit).^2);    % Residual sum of squares
R_squared = 1 - (SS_res / SS_tot); % R² value

% Create the regression plot
figure;
scatter(x, y, 'filled'); % Scatter plot of the data
hold on;
plot(x, y_fit, 'r-', 'LineWidth', 2); % Regression line
xlabel('Daily Mean');
ylabel('Mean NO2 (µg/m³)');
title(sprintf('Regression Plot (R² = %.4f)', R_squared));
grid on;
legend('Data Points', 'Regression Line');

% Display the R² value in the command window
fprintf('R² value: %.4f\n', R_squared);
