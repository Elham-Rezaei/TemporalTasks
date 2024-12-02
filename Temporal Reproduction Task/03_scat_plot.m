% Load data from CSV
data = readtable('temporal_reproduction_task csv.csv');

% Extract ts and tr columns
ts = data.ts;
tr = data.tr;

% Calculate statistics
mean_ts = mean(ts);
mean_tr = mean(tr);
std_ts = std(ts);
std_tr = std(tr);

% Define axis limits
max_limit = max(max(ts), max(tr)); % Determine maximum value to set plot limits

% Create scatter plot
figure;
scatter(ts, tr, 50, [71, 202, 214] / 255, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', [71, 202, 214] / 255); % Custom color with black edge
hold on;

% Plot ideal reproduction line (ts = tr) passing through (0, 0)
plot([0, max_limit], [0, max_limit], 'k--', 'LineWidth', 1.5); % Dashed line

% Add labels, title, and legend
xlabel('Simple Time (ts)', 'FontSize', 12);
ylabel('Reproduce Time (tr)', 'FontSize', 12);
title('Scatter Plot of Simple Time (ts) vs Reproduce Time (tr)', 'FontSize', 14, 'FontWeight', 'bold');
legend({'Observed Data', 'Ideal Reproduction (ts = tr)'}, 'FontSize', 10, 'Location', 'northwest');
xticks(0:200:2200);
yticks(0:200:2200);

% Add statistical text box
stats_text = sprintf(['Mean ts = %.2f ms\nMean tr = %.2f ms\nStd ts = %.2f ms\nStd tr = %.2f ms'], ...
                      mean_ts, mean_tr, std_ts, std_tr);
annotation('textbox', [0.15, 0.75, 0.3, 0.15], 'String', stats_text, ...
           'FitBoxToText', 'on', 'BackgroundColor', 'white', 'FontSize', 10);

% Adjust axes
axis([0 max_limit 0 max_limit]); % Ensure axes start at 0 and extend to the maximum limit
grid on;
hold off;
