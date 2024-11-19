% Load the data
data = readtable('Temporal Discrimination Task.csv');

% Calculate the proportion of "Right" responses for each ts1 and ts2
[grouped, ts1_values, ts2_values] = findgroups(data.ts1, data.ts2);
proportion_right = splitapply(@(x) mean(strcmp(x, 'Right')), data.Response, grouped);

% Define the Gaussian cumulative function
cumulative_gaussian = @(params, x) 0.5 * (1 + erf((x - params(1)) ./ (sqrt(2) * params(2))));

% Fit the Gaussian cumulative function for each ts1
fit_results = [];
unique_ts1 = unique(ts1_values);
for i = 1:length(unique_ts1)
    ts1 = unique_ts1(i); % Current ts1 value
    mask = ts1_values == ts1; % Select data for this ts1
    x = ts2_values(mask); % Corresponding ts2 values
    y = proportion_right(mask); % Proportion of "Right" responses

    % Check if there is data for fitting
    if isempty(x) || isempty(y)
        warning('No data for ts1 = %d', ts1);
        continue;
    end

    % Fit the Gaussian function
    initial_params = [mean(x), std(x)]; % Initial guess: mean and standard deviation
    params = nlinfit(x, y, cumulative_gaussian, initial_params);
    mu = params(1); % Mean (PSE)
    sigma = params(2); % Standard deviation (sigma)

    % Store the results
    fit_results = [fit_results; ts1, mu, sigma];
end

% Convert the fit results to a table
fit_results_table = array2table(fit_results, 'VariableNames', {'ts1', 'PSE', 'sigma'});

% Perform linear regression for ts1 and PSE
X = fit_results_table.ts1;
y = fit_results_table.PSE;
linear_model = fitlm(X, y);

% Extract regression parameters
C = linear_model.Coefficients.Estimate(1); % Intercept
IP = linear_model.Coefficients.Estimate(2); % Slope

% Plot the results
figure;
hold on;
scatter(X, y, 'o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'k'); % Data points
plot(X, predict(linear_model, X), '-r', 'LineWidth', 1); % Linear fit line
xlabel('Interval Duration (ts1)');
ylabel('Point of Subjective Equality (PSE)');
title('Relationship between ts1 and PSE');
legend('Data Points', 'Linear Fit', 'location', 'southeast');
grid on;

% Adjust x-axis
xticks([400 : 100 : 1900]); % Set x-axis ticks
xlim([min(X) - 100, max(X) + 100]); % Set x-axis limits

% Display regression parameters
disp('Linear regression results:');
fprintf('Intercept (C): %.2f\n', C);
fprintf('Slope (IP): %.2f\n', IP);
