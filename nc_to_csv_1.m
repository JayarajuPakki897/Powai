% Specify the NetCDF file name
cd C:\Users\Admin\Downloads\b30c634e4415a410fabcd9e997bfdd9b
filename = 'data_plev.nc';

% Get the information about the NetCDF file
info = ncinfo(filename);

% Print all the variable names
disp('Variables in the dataset:');
for i = 1:length(info.Variables)
    disp(info.Variables(i).Name);
end

% Optionally, print details about each variable
disp('Variable details:');
for i = 1:length(info.Variables)
    var = info.Variables(i);
    fprintf('Name: %s, Dimensions: %s, Type: %s\n', ...
        var.Name, strjoin(var.Dimensions.Name, ', '), var.Datatype);
end


% 
% % Load the valid_time variable and convert it to datetime
% valid_time = ncread('data_byhour_plev.nc', 'valid_time');
% valid_time_seconds = double(valid_time);
% reference_date = datetime(1970, 1, 1, 'TimeZone', 'UTC');
% actual_time = reference_date + seconds(valid_time_seconds);
% 
% % Load other variables
% 
% gtco3 = ncread('data_byhour_sfc.nc', 'gtco3');
% 
% % Load latitude, longitude, and model level as single values
% latitude = ncread('data_byhour_sfc.nc', 'latitude');
% longitude = ncread('data_byhour_sfc.nc', 'longitude');
% 
% % Number of rows for valid_time
% numRows = length(valid_time);
% 
% % Prepare the table
% data_table = table;
% 
% % Adding variables to the table
% data_table.valid_time = actual_time;
% data_table.latitude = repmat(latitude, numRows, 1);
% data_table.longitude = repmat(longitude, numRows, 1);
% 
% data_table.gtco3 = reshape(gtco3, [], 1);
% 
% 
% % Add a units column
% units = repmat({'kg m**-2'}, numRows, 1); % Assuming all variables share the same units
% data_table.units = units;
% 
% % Display the table (optional)
% disp(data_table);
% 
% % Save the table as CSV
% csvFileName = 'data_table_Ozone.csv';  % Specify the desired CSV file name
% writetable(data_table, csvFileName);
% 
% % Confirmation message
% fprintf('Table saved as %s\n', csvFileName);
