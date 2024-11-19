% Load data from CSV
data = readtable('temporal_reproduction_task csv.csv');

% Extract necessary columns
ts = data.ts; % Presented Time (ms)
error = data.Error; % Error

% Calculate mean and standard deviation for each unique ts value
[unique_ts, ~, idx] = unique(ts);
mean_error = accumarray(idx, error, [], @mean);
std_error = accumarray(idx, error, [], @std);

% Create error bar plot
figure;
errorbar(unique_ts, mean_error, std_error, '-o', 'Color', 'm', 'MarkerFaceColor', 'm', ...
         'MarkerEdgeColor', 'm', 'LineWidth', 1.5); % Magenta line with circles
hold on;

% Add labels, title
xlabel('Presented Time (ts)', 'FontSize', 12);
ylabel('Mean Error ± Std', 'FontSize', 12);
title('Mean Error and Standard Deviation for Each Presented Time', 'FontSize', 14, 'FontWeight', 'bold');

% Adjust axes and grid
ylim([-600, 400]); % Set y-axis limits
grid on;
hold off;
