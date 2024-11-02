% Load the valid_time variable and convert it to datetime
cd C:\Users\Admin\Downloads\b30c634e4415a410fabcd9e997bfdd9b

valid_time = ncread('data_plev.nc', 'forecast_reference_time');
valid_time_seconds = double(valid_time);
reference_date = datetime(1970, 1, 1, 'TimeZone', 'UTC');
actual_time = reference_date + seconds(valid_time_seconds);
variables = {'c5h8','pan','go3', 'c2h6',}
% Load other variables
% variables = {'co', 'hcho', 'c5h8', 'hno3', 'no', 'pan', 'c3h8', ...
%              'ch3coch3', 'ald2', 'c2h5oh', 'c2h4', 'hcooh', ...
%              'ch4_c', 'ch3oh', 'ch3ooh', 'ole', 'onit', 'par'};

% Load latitude, longitude, and model level as single values
latitude = ncread('data_plev.nc', 'latitude');
longitude = ncread('data_plev.nc', 'longitude');
pressure_level = ncread('data_plev.nc', 'pressure_level');

% Number of rows for valid_time
numRows = length(valid_time);

% Prepare the table
data_table = table;

% Adding the valid_time and geographical information to the table
data_table.valid_time = actual_time;
data_table.pressure_level = repmat(pressure_level, numRows, 1);
data_table.latitude = repmat(latitude, numRows, 1);
data_table.longitude = repmat(longitude, numRows, 1);

% Load and reshape each variable, then add to the table
for i = 1:length(variables)
    var_name = variables{i};
    data = ncread('data_plev.nc', var_name);
    data_table.(var_name) = reshape(data, [], 1); % Add to table
end

% Add a units column
units = repmat({'kg m**-2'}, numRows, 1); % Assuming all variables share the same units
data_table.units = units;

% Display the table (optional)
disp(data_table);

% Save the table as CSV
csvFileName = 'data_table_pressure_level_shruthi.csv';  % Specify the desired CSV file name
writetable(data_table, csvFileName);

% Confirmation message
fprintf('Table saved as %s\n', csvFileName);








% Load the valid_time variable and convert it to datetime
cd('C:\Users\Admin\Downloads\b30c634e4415a410fabcd9e997bfdd9b');

valid_time = ncread('data_plev.nc', 'forecast_reference_time');
valid_time_seconds = double(valid_time);
reference_date = datetime(1970, 1, 1, 'TimeZone', 'UTC');
actual_time = reference_date + seconds(valid_time_seconds);

variables = {'c5h8', 'pan', 'go3', 'c2h6'};

% Load latitude, longitude, and model level as single values
latitude = ncread('data_plev.nc', 'latitude');
longitude = ncread('data_plev.nc', 'longitude');
pressure_level = ncread('data_plev.nc', 'pressure_level');

% Number of rows for valid_time
numRows = length(valid_time);

% Prepare the table
data_table = table;

% Adding the valid_time and geographical information to the table
data_table.valid_time = actual_time(:); % Ensure it's a column vector
data_table.pressure_level = repmat(pressure_level, numRows, 1);
data_table.latitude = repmat(latitude, numRows, 1);
data_table.longitude = repmat(longitude, numRows, 1);

% Load and reshape each variable, then add to the table
for i = 1:length(variables)
    var_name = variables{i};
    data = ncread('data_plev.nc', var_name);
    
    % Display the size of the loaded data for debugging
    disp(['Size of ', var_name, ': ', num2str(size(data)')]);

    % Check the number of elements in the loaded data
    numElements = numel(data);
    
    % Check if reshaping is needed
    if numElements ~= numRows
        % Try reshaping to match the first dimension with numRows
        if numElements < numRows
            error(['Not enough elements in ', var_name, ...
                   '. Expected at least ', num2str(numRows), ...
                   ', but got ', num2str(numElements), '.']);
        else
            data_reshaped = reshape(data, numRows, []); % Reshape to have numRows as the first dimension
            data_reshaped = data_reshaped(:); % Flatten to a column vector
        end
    else
        data_reshaped = data(:); % Ensure it's a column vector
    end
    
    % Check if the number of rows matches
    if length(data_reshaped) ~= numRows
        error(['The number of rows in ', var_name, ...
               ' does not match the expected number of rows in the table. ', ...
               'Expected: ', num2str(numRows), ', Got: ', num2str(length(data_reshaped))]);
    end
    
    data_table.(var_name) = data_reshaped; % Add to table
end

% Add a units column
units = repmat({'kg m**-2'}, numRows, 1); % Assuming all variables share the same units
data_table.units = units;

% Display the table (optional)
disp(data_table);
