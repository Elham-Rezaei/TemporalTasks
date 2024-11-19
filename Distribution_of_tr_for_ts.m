% Load your data
data = readtable('temporal_reproduction_task csv.csv');
 
% Extract unique 'ts' values
unique_ts = unique(data.ts);

% Define custom colors (converted to 0-1 range)
colors = [
    236, 238, 129;
    141, 223, 203;
    130, 160, 216;
    237, 183, 237;
    237, 123, 123
] / 255; % Convert to 0-1 range
 
% Create a single figure
figure;
hold on;
 
for i = 1:length(unique_ts)
    % Filter 'tr' values for the current 'ts'
    ts_value = unique_ts(i);
    filtered_tr = data.tr(data.ts == ts_value);
    
    % Calculate mean and standard deviation of 'tr'
    mu = mean(filtered_tr);
    sigma = std(filtered_tr);
    
    % Plot only the normal distribution curve (without histogram)
    x = linspace(min(filtered_tr), max(filtered_tr), 100);
    y = (1 / (sigma * sqrt(2 * pi))) * exp(-0.5 * ((x - mu) / sigma).^2);
    plot(x, y, '-', 'LineWidth', 2, 'Color', colors(mod(i-1, size(colors, 1)) + 1, :), ...
        'DisplayName', ['ts = ', num2str(ts_value)]);
    
    % Shade the area under the normal curve
    fill([x fliplr(x)], [y zeros(size(y))], ...
        colors(mod(i-1, size(colors, 1)) + 1, :), ...
        'FaceAlpha', 0.2, 'EdgeColor', 'none');
end
 
% Add labels, title, legend, and grid
xlabel('Reproduced Time (tr)', 'FontSize', 12);
ylabel('Probability Density', 'FontSize', 12);
title('Distribution of TR Values Across All TS Groups', 'FontSize', 14);
legend('show', 'Location', 'northeast'); % Set legend position to northwest
grid on;
hold off;
