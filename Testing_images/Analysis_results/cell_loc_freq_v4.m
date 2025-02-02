% Author: Miguel Mazumder -> mfmmazumder@gwmail.gwu.edu
% Date: 11/29/2023 FIX QUADRANT COUNTER
%% README
% This script produces graphs representing x or y cell location frequency
% for visualization of what is going on in each image

%% REQUIRMENTS: Place this script in the same folder as cell_location.csv files
%it will produce x and y frequency figures for each
%cell_location.csv file that exists in the folder.

%% BODY OF SCRIPT: Calling Folder Access, Read files, and Produce Figures
csvfiles = folder_access;
figure_visual(csvfiles)
%% FOLDER ACCESS
function [csvFileNames] = folder_access()
    csvFiles = dir('*cell_locations.csv');
    csvFileNames = {csvFiles.name};
    if isempty(csvFileNames)
        % Display an error message
        error('No cell_locations.csv files found. Cannot execute figure visualization.');
    end
end
%% CSV READ and Produce Figures
function figure_visual(csv_files)
    % Create a dialog box with two input fields
    prompt = {'Enter number of x bins:', 'Enter number of y bins:'};
    dlgtitle = 'Image dimensions and Number of Bins';
    dims = [1 50]; % Dimensions of the input fields
    % Default values
    definput = {'20', '20'};
    % Show the dialog box and wait for user input
    answer = inputdlg(prompt, dlgtitle, dims, definput);
    
    xbin_num = str2double(answer{1});
    ybin_num = str2double(answer{2});
    
    % x_bins = linspace(1, num1, numBins+1);
    % y_bins = linspace(1, num2, numBins+1);
    % 
    % x_bin_count = zeros(1, numBins);
    % y_bin_count = zeros(1, numBins);
    
    for i=1:length(csv_files)
        % Get current data to load
        data = readmatrix(csv_files{i});
        
        % Get frequency for x and y coordinates
        [cell_count_x] = get_freq(data(:,1), csv_files{i}, 'X Coordinate of image', xbin_num);
        x_bin_count = x_bin_count + cell_count_x;
        
        [cell_count_y] = get_freq(data(:,2), csv_files{i}, 'Y Coordinate of image', ybin_num);
        y_bin_count = y_bin_count + cell_count_y;
    end
    
    overallfolder_frequnecy_per_bin_count(x_bin_count, y_bin_count, x_bins, y_bins);
end

%% Function to get frequency of numbers
function [cell_counter] = get_freq(locations, title_, x_or_y, bin_num)
    bin_dim = linspace(1, length(locations) +1, bin_num +1);
    cell_counter = histcounts(locations, bin_dim);
    bin_dim = bin_dim(1:end-1); % Remove the last element
    percent_freq = cell_counter / length(locations);
    %% REMOVE
    size(bin_dim)
    size(percent_freq)
    %%
    % Plot the graph
    figure;
    plot(bin_dim, percent_freq);
    
    % Find the position of the first underscore
    underscoreIndex = strfind(title_, '_');
    title_ = title_(1:underscoreIndex(1)-1);
    title(title_);
    xlabel(x_or_y);
    ylabel('Frequency');
end

function overallfolder_frequnecy_per_bin_count(x_bin_count, y_bin_count, x_bins, y_bins)
    % X bin plot
    x_percent_freq = x_bin_count / sum(x_bin_count);
    % Plot the graph
    figure;
    plot(x_bins(1:end-1), x_percent_freq);
    title('Average cell count frequency across X bins');
    xlabel('X Coordinate of image');
    ylabel('Frequency');
    
    % Y bin plot
    y_percent_freq = y_bin_count / sum(y_bin_count);
    % Plot the graph
    figure;
    plot(y_bins(1:end-1), y_percent_freq);
    title('Average cell count frequency across Y bins');
    xlabel('Y Coordinate of image');
    ylabel('Frequency');
end
