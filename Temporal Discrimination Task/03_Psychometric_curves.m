% Load the data
data = readtable('Temporal Discrimination Task.csv');

% Calculate the proportion of "Right" responses for each ts1 and ts2
[grouped, ts1_values, ts2_values] = findgroups(data.ts1, data.ts2);
proportion_right = splitapply(@(x) mean(strcmp(x, 'Right')), data.Response, grouped);

% Define the Gaussian cumulative function
cumulative_gaussian = @(params, x) 0.5 * (1 + erf((x - params(1)) ./ (sqrt(2) * params(2))));

% Fit the Gaussian cumulative function for each ts1
fit_results = [];
x_vals = linspace(min(data.ts2), max(data.ts2), 500); % x values for plotting

% Get unique ts1 values
unique_ts1 = unique(ts1_values);
colors = lines(length(unique_ts1)); % Generate colors for each ts1

figure;
hold on;
for i = 1:length(unique_ts1)
    ts1 = unique_ts1(i); % Current ts1 value
    mask = ts1_values == ts1; % Select data related to this ts1
    x = ts2_values(mask); % Corresponding ts2 values
    y = proportion_right(mask); % Proportion of "Right" responses

    % Check if there is data for fitting
    if isempty(x) || isempty(y)
        continue;
    end

    % Fit the Gaussian function
    initial_params = [mean(x), std(x)]; % Initial guess: mean and standard deviation
    params = nlinfit(x, y, cumulative_gaussian, initial_params);
    pse = params(1); % PSE (Point of Subjective Equality)
    sd = params(2); % Standard Deviation (SD)

    % Store the results
    fit_results = [fit_results; ts1, pse, sd];

    % Plot the data and the fit
    plot(x, y, 'o', 'Color', colors(i, :), 'MarkerFaceColor', colors(i, :), ...
         'MarkerSize', 5 , 'DisplayName', sprintf('ts1=%d', ts1)); % Experimental data for ts1
    plot(x_vals, cumulative_gaussian([pse, sd], x_vals), '-', 'Color', colors(i, :), ...
         'DisplayName', sprintf('PSE=%.2f, SD=%.2f', pse, sd)); % Fitted curve with PSE and SD
end

xlabel('ts2 (ms)');
ylabel('Proportion of "Right" Responses');
title('Psychometric Curves and Gaussian Fits');
legend('show', 'Location', 'best'); % Display the legend
grid on;

% Convert fit results to a table with PSE and SD values
fit_results_table = array2table(fit_results, 'VariableNames', {'ts1', 'PSE', 'SD'});

% Perform linear regression for ts1 and PSE
X = fit_results_table.ts1;
y = fit_results_table.PSE;
linear_model = fitlm(X, y); % Linear regression model
C = linear_model.Coefficients.Estimate(1); % Intercept
IP = linear_model.Coefficients.Estimate(2); % Slope

% Display regression results
disp('Linear regression analysis results:');
fprintf('Intercept (C): %.2f\n', C);
fprintf('Slope (IP): %.2f\n', IP);

% Display the final table with ts1, PSE, and SD
disp('Psychometric fit results table:');
disp(fit_results_table);
