% Load the data
data = readtable('Temporal Discrimination Task.csv');

% Calculate Bias: Difference between ts2 and ts1
data.Bias = data.ts2 - data.ts1;

% Calculate Mean Bias for each unique ts1
unique_ts1 = unique(data.ts1);
mean_bias = zeros(size(unique_ts1));

for i = 1:length(unique_ts1)
    ts1_value = unique_ts1(i);
    % Extract subset of data for this ts1 value
    subset = data(data.ts1 == ts1_value, :);
    
    % Calculate mean bias
    mean_bias(i) = mean(subset.Bias);
end

% Plot Mean Bias vs ts1
figure;
plot(unique_ts1, mean_bias, '-o', 'Color', [61, 59, 243]/255, 'LineWidth', 1.5);
xlabel('Interval (ts1) (ms)');
ylabel('Mean Bias (ms)');
title('Mean Bias Across Interval Durations');
legend('location', 'northeast')
grid on;
