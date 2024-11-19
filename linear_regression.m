% Load data from CSV
data = readtable('temporal_reproduction_task csv.csv');

% Extract ts and tr columns
ts = data.ts;
tr = data.tr;

% Perform linear regression
coefficients = polyfit(ts, tr, 1); % Fit a line (degree 1)
regression_line = polyval(coefficients, ts); % Compute regression line values

% Create scatter plot
figure;
scatter(ts, tr, 50, 'b', 'filled', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'b'); % Blue circles with black edge
hold on;

% Plot regression line
plot(ts, regression_line, 'r--', 'LineWidth', 1.5); % Red dashed line

% Add labels, title, and legend
xlabel('Simple Time (ts)', 'FontSize', 12);
ylabel('Reproduce Time (tr)', 'FontSize', 12);
title('Linear Regression Analysis of Simple Time vs. Reproduce Time', 'FontSize', 14, 'FontWeight', 'bold');
legend({'Observed Data', 'Regression Line'}, 'FontSize', 10, 'Location', 'northwest');
yticks([200:200:2200]);

% Adjust axes
grid on;
hold off;
