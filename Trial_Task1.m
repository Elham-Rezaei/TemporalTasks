% Initial screen settings
Screen('Preference', 'SkipSyncTests', 1);
[window, windowRect] = Screen('OpenWindow', 0, [128, 128, 128]); 
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the center of the screen
[xCenter, yCenter] = RectCenter(windowRect); 

% Display characteristics (cm)
screenWidth_cm = 28.5; 
viewingDistance_cm = 57; 

% Calculate the number of pixels per centimeter
pixelsPerCm = screenXpixels / screenWidth_cm;

% Circle and target angles in degrees
fixationDiameter_deg = 0.2;   
leftTargetDiameter_deg = 0.5; 
rightTargetDiameter_deg = 2;  
stimulusDiameter_deg = 2.5;   
visualAngle_deg = 10;        

% Calculate the 10-degree distance and circle diameters in pixels
visualAngle_rad = deg2rad(visualAngle_deg);
distanceFromFixation_cm = 2 * viewingDistance_cm * tan(visualAngle_rad / 2);
distanceFromFixation_pixels = distanceFromFixation_cm * pixelsPerCm;

% Calculate the diameters of circles in pixels
fixationDiameter_pixels = 2 * viewingDistance_cm * tan(deg2rad(fixationDiameter_deg / 2)) * pixelsPerCm;
leftTargetDiameter_pixels = 2 * viewingDistance_cm * tan(deg2rad(leftTargetDiameter_deg / 2)) * pixelsPerCm;
rightTargetDiameter_pixels = 2 * viewingDistance_cm * tan(deg2rad(rightTargetDiameter_deg / 2)) * pixelsPerCm;
stimulusDiameter_pixels = 2 * viewingDistance_cm * tan(deg2rad(stimulusDiameter_deg / 2)) * pixelsPerCm;

% Calculate the positions of the fixation point and targets based on the new calculations
fixationPoint = [xCenter, yCenter];
leftTargetPos = fixationPoint + [-distanceFromFixation_pixels, 0];
rightTargetPos = fixationPoint + [distanceFromFixation_pixels, 0];

% Color settings
fixationColor = [255, 255, 255];
targetColor = [255, 255, 255];
yellowColor = [150, 150, 50];
purpleColor = [150, 50, 150];

% Start angles for each spoke
angles = [10, 70, 130, 190, 250, 310];

% Radius of the central white circle
centerWhiteCircleRadius = fixationDiameter_pixels / 2;  
wheelOuterRadius = stimulusDiameter_pixels / 2 - 5;  
wheelInnerRadius = centerWhiteCircleRadius + 10; 

% Width of the spokes
segmentWidth = 15;

% Experiment timings
ts_values = [400, 500, 700, 1100, 1900];
n_trials = 40;
feedback_time = 0.8;

% Create a CSV file to save data
fileID = fopen('temporal_reproduction_task.csv', 'w');
fprintf(fileID, 'Trial,ts,tr,Error\n');  % Column headers

% Start the experiment
for trial = 1:n_trials
    % Display fixation point and targets 
    Screen('FillOval', window, fixationColor, [xCenter - fixationDiameter_pixels/2, yCenter - fixationDiameter_pixels/2, xCenter + fixationDiameter_pixels/2, yCenter + fixationDiameter_pixels/2]);
    Screen('FillOval', window, targetColor, [leftTargetPos(1) - leftTargetDiameter_pixels/2, leftTargetPos(2) - leftTargetDiameter_pixels/2, leftTargetPos(1) + leftTargetDiameter_pixels/2, leftTargetPos(2) + leftTargetDiameter_pixels/2]);
    Screen('FillOval', window, targetColor, [rightTargetPos(1) - rightTargetDiameter_pixels/2, rightTargetPos(2) - rightTargetDiameter_pixels/2, rightTargetPos(1) + rightTargetDiameter_pixels/2, rightTargetPos(2) + rightTargetDiameter_pixels/2]);

    % Display the screen
    Screen('Flip', window);
    WaitSecs(0.5 + exprnd(0.25));  % Random delay

    % Randomly select a time interval (ts)
    ts = ts_values(randi(length(ts_values)));

    % Display the first stimulus
    for i = 1:6
        if i <= 3
            color = yellowColor; % First three spokes are yellow
        else
            color = purpleColor; % Next three spokes are purple
        end

        % Draw spokes along with the fixation point and targets
        Screen('FillOval', window, fixationColor, [xCenter - fixationDiameter_pixels/2, yCenter - fixationDiameter_pixels/2, xCenter + fixationDiameter_pixels/2, yCenter + fixationDiameter_pixels/2]);
        Screen('FillOval', window, targetColor, [leftTargetPos(1) - leftTargetDiameter_pixels/2, leftTargetPos(2) - leftTargetDiameter_pixels/2, leftTargetPos(1) + leftTargetDiameter_pixels/2, leftTargetPos(2) + leftTargetDiameter_pixels/2]);
        Screen('FillOval', window, targetColor, [rightTargetPos(1) - rightTargetDiameter_pixels/2, rightTargetPos(2) - rightTargetDiameter_pixels/2, rightTargetPos(1) + rightTargetDiameter_pixels/2, rightTargetPos(2) + rightTargetDiameter_pixels/2]);

        % Draw the spokes
        Screen('FillArc', window, color, [xCenter-wheelOuterRadius, yCenter-wheelOuterRadius, xCenter+wheelOuterRadius, yCenter+wheelOuterRadius], angles(i), segmentWidth);
        Screen('FillArc', window, [128, 128, 128], [xCenter-wheelInnerRadius, yCenter-wheelInnerRadius, xCenter+wheelInnerRadius, yCenter+wheelInnerRadius], angles(i), segmentWidth);
    end
    Screen('Flip', window);
    WaitSecs(0.0266);  % Display for 26.6 milliseconds

    % Erase the first stimulus but keep the fixation point and targets
    Screen('FillOval', window, fixationColor, [xCenter - fixationDiameter_pixels/2, yCenter - fixationDiameter_pixels/2, xCenter + fixationDiameter_pixels/2, yCenter + fixationDiameter_pixels/2]);
    Screen('FillOval', window, targetColor, [leftTargetPos(1) - leftTargetDiameter_pixels/2, leftTargetPos(2) - leftTargetDiameter_pixels/2, leftTargetPos(1) + leftTargetDiameter_pixels/2, leftTargetPos(2) + leftTargetDiameter_pixels/2]);
    Screen('FillOval', window, targetColor, [rightTargetPos(1) - rightTargetDiameter_pixels/2, rightTargetPos(2) - rightTargetDiameter_pixels/2, rightTargetPos(1) + rightTargetDiameter_pixels/2, rightTargetPos(2) + rightTargetDiameter_pixels/2]);
    Screen('Flip', window);
    WaitSecs(ts / 1000);  % Wait for ts duration

    % Display the second stimulus (similar to the first)
    for i = 1:6
        if i <= 3
            color = yellowColor; % First three spokes are yellow
        else
            color = purpleColor; % Next three spokes are purple
        end

        % Draw spokes along with the fixation point and targets
        Screen('FillOval', window, fixationColor, [xCenter - fixationDiameter_pixels/2, yCenter - fixationDiameter_pixels/2, xCenter + fixationDiameter_pixels/2, yCenter + fixationDiameter_pixels/2]);
        Screen('FillOval', window, targetColor, [leftTargetPos(1) - leftTargetDiameter_pixels/2, leftTargetPos(2) - leftTargetDiameter_pixels/2, leftTargetPos(1) + leftTargetDiameter_pixels/2, leftTargetPos(2) + leftTargetDiameter_pixels/2]);
        Screen('FillOval', window, targetColor, [rightTargetPos(1) - rightTargetDiameter_pixels/2, rightTargetPos(2) - rightTargetDiameter_pixels/2, rightTargetPos(1) + rightTargetDiameter_pixels/2, rightTargetPos(2) + rightTargetDiameter_pixels/2]);

        % Draw the spokes
        Screen('FillArc', window, color, [xCenter-wheelOuterRadius, yCenter-wheelOuterRadius, xCenter+wheelOuterRadius, yCenter+wheelOuterRadius], angles(i), segmentWidth);
        Screen('FillArc', window, [128, 128, 128], [xCenter-wheelInnerRadius, yCenter-wheelInnerRadius, xCenter+wheelInnerRadius, yCenter+wheelInnerRadius], angles(i), segmentWidth);
    end
    Screen('Flip', window);
    WaitSecs(0.0266);  % Display for 26.6 milliseconds

    % Erase the second stimulus but keep the fixation point and targets
    Screen('FillOval', window, fixationColor, [xCenter - fixationDiameter_pixels/2, yCenter - fixationDiameter_pixels/2, xCenter + fixationDiameter_pixels/2, yCenter + fixationDiameter_pixels/2]);
    Screen('FillOval', window, targetColor, [leftTargetPos(1) - leftTargetDiameter_pixels/2, leftTargetPos(2) - leftTargetDiameter_pixels/2, leftTargetPos(1) + leftTargetDiameter_pixels/2, leftTargetPos(2) + leftTargetDiameter_pixels/2]);
    Screen('FillOval', window, targetColor, [rightTargetPos(1) - rightTargetDiameter_pixels/2, rightTargetPos(2) - rightTargetDiameter_pixels/2, rightTargetPos(1) + rightTargetDiameter_pixels/2, rightTargetPos(2) + rightTargetDiameter_pixels/2]);
    Screen('Flip', window);
    
    % Display instruction: "Hold the right arrow key, then release when you think the same time has passed"
    DrawFormattedText(window, 'Hold the right arrow key, then release when you think the same time has passed', 'center', 'center', [255, 255, 255]);
    Screen('Flip', window);

    % Wait for the key press
    KbWait([], 2);
    press_time = GetSecs;

    % Wait for key release
    while KbCheck
    end
    release_time = GetSecs;

    % Calculate the time the key was held down
    tr = (release_time - press_time) * 1000;

    % Calculate the error
    error = tr - ts;

    % Display the error and skip showing fixation point at this stage
    DrawFormattedText(window, sprintf('Error: %.2f ms', error), 'center', 'center', [255, 255, 255]);
    Screen('Flip', window);
    WaitSecs(feedback_time);

% Save trial dataارع into the CSV file
fprintf(fileID, '%d,%.2f,%.2f,%.2f\n', trial, ts, tr, error);

    % Start the next trial after 1.2 seconds
    WaitSecs(1.2);
end

% Close the CSV and the screen
fclose(fileID);
sca;

