%testing
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
fixationColor = [255, 255, 255]; % White for fixation point
targetColor = [255, 255, 255];   % White for peripheral targets
yellowColor = [150, 150, 50];    % RGB color for yellow spokes
purpleColor = [150, 50, 150];    % RGB color for purple spokes

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

% Percentage of ts1 to create ts2
ts_percentage_diff = [6, 12, 24, 48];

% Create a CSV file to save data
fileID = fopen('temporal_discrimination_task.csv', 'w');
fprintf(fileID, 'Trial,ts1,ts2,Response,Correct\n');  % Column headers

% Start the experiment
for trial = 1:n_trials
    % Display fixation point and targets (side circles), which must always be present
    Screen('FillOval', window, fixationColor, [xCenter - fixationDiameter_pixels/2, yCenter - fixationDiameter_pixels/2, xCenter + fixationDiameter_pixels/2, yCenter + fixationDiameter_pixels/2]);
    Screen('FillOval', window, targetColor, [leftTargetPos(1) - leftTargetDiameter_pixels/2, leftTargetPos(2) - leftTargetDiameter_pixels/2, leftTargetPos(1) + leftTargetDiameter_pixels/2, leftTargetPos(2) + leftTargetDiameter_pixels/2]);
    Screen('FillOval', window, targetColor, [rightTargetPos(1) - rightTargetDiameter_pixels/2, rightTargetPos(2) - rightTargetDiameter_pixels/2, rightTargetPos(1) + rightTargetDiameter_pixels/2, rightTargetPos(2) + rightTargetDiameter_pixels/2]);

    % Display the screen
    Screen('Flip', window);
    WaitSecs(0.5 + exprnd(0.25));  % Random delay

    % Randomly select ts1
    ts1 = ts_values(randi(length(ts_values)));

    % Create ts2 by adding or subtracting a random percentage of ts1
    ts2 = ts1 + ts1 * (ts_percentage_diff(randi(length(ts_percentage_diff))) / 100) * (-1)^(randi(2));

    % Display the first stimulus (wheel-like circle) for ts1
    for i = 1:6
        % Alternate the colors between yellow and purple for each spoke
        if mod(i, 2) == 0
            color = purpleColor; % Even spokes are purple
        else
            color = yellowColor; % Odd spokes are yellow
        end
        % Draw spokes and display for ts1
        Screen('FillArc', window, color, [xCenter-wheelOuterRadius, yCenter-wheelOuterRadius, xCenter+wheelOuterRadius, yCenter+wheelOuterRadius], angles(i), segmentWidth);
        Screen('FillArc', window, [128, 128, 128], [xCenter-wheelInnerRadius, yCenter-wheelInnerRadius, xCenter+wheelInnerRadius, yCenter+wheelInnerRadius], angles(i), segmentWidth);
    end
    
    % Ensure peripheral white circles remain visible while the wheel is displayed
    Screen('FillOval', window, fixationColor, [xCenter - fixationDiameter_pixels/2, yCenter - fixationDiameter_pixels/2, xCenter + fixationDiameter_pixels/2, yCenter + fixationDiameter_pixels/2]); % Central white circle
    Screen('FillOval', window, targetColor, [leftTargetPos(1) - leftTargetDiameter_pixels/2, leftTargetPos(2) - leftTargetDiameter_pixels/2, leftTargetPos(1) + leftTargetDiameter_pixels/2, leftTargetPos(2) + leftTargetDiameter_pixels/2]); % Left target circle
    Screen('FillOval', window, targetColor, [rightTargetPos(1) - rightTargetDiameter_pixels/2, rightTargetPos(2) - rightTargetDiameter_pixels/2, rightTargetPos(1) + rightTargetDiameter_pixels/2, rightTargetPos(2) + rightTargetDiameter_pixels/2]); % Right target circle
    Screen('Flip', window);
    WaitSecs(0.0266);  % First stimulus duration

    % Wait for ts1
    WaitSecs(ts1 / 1000);

    % Display the second stimulus (similar to the first one) for ts2
    for i = 1:6
        % Alternate the colors between yellow and purple for the second stimulus
        if mod(i, 2) == 0
            color = yellowColor; % Even spokes are yellow for second stimulus
        else
            color = purpleColor; % Odd spokes are purple for second stimulus
        end
        % Draw spokes and display for ts2
        Screen('FillArc', window, color, [xCenter-wheelOuterRadius, yCenter-wheelOuterRadius, xCenter+wheelOuterRadius, yCenter+wheelOuterRadius], angles(i), segmentWidth);
        Screen('FillArc', window, [128, 128, 128], [xCenter-wheelInnerRadius, yCenter-wheelInnerRadius, xCenter+wheelInnerRadius, yCenter+wheelInnerRadius], angles(i), segmentWidth);
    end
    
    % Ensure peripheral white circles remain visible while the second wheel is displayed
    Screen('FillOval', window, fixationColor, [xCenter - fixationDiameter_pixels/2, yCenter - fixationDiameter_pixels/2, xCenter + fixationDiameter_pixels/2, yCenter + fixationDiameter_pixels/2]); % Central white circle
    Screen('FillOval', window, targetColor, [leftTargetPos(1) - leftTargetDiameter_pixels/2, leftTargetPos(2) - leftTargetDiameter_pixels/2, leftTargetPos(1) + leftTargetDiameter_pixels/2, leftTargetPos(2) + leftTargetDiameter_pixels/2]); % Left target circle
    Screen('FillOval', window, targetColor, [rightTargetPos(1) - rightTargetDiameter_pixels/2, rightTargetPos(2) - rightTargetDiameter_pixels/2, rightTargetPos(1) + rightTargetDiameter_pixels/2, rightTargetPos(2) + rightTargetDiameter_pixels/2]); % Right target circle
    Screen('Flip', window);
    WaitSecs(0.0266);  % Second stimulus duration

    % Wait for ts2
    WaitSecs(ts2 / 1000);

    % Now prompt the user for input (compare ts1 and ts2)
    DrawFormattedText(window, 'Is ts2 longer or shorter than ts1? Press Left or Right.', 'center', 'center', [255, 255, 255]);
    Screen('Flip', window);

    % Wait for a key press (left or right)
    validKeyPressed = false;  % New variable to track if valid key is pressed
    while ~validKeyPressed
        [keyIsDown, ~, keyCode] = KbCheck;  % Changed to KbCheck for continuous check
        if keyIsDown
            % Convert keyCode array to readable key names
            pressedKey = KbName(find(keyCode));

            if iscell(pressedKey)  % Handle multiple key presses
                pressedKey = pressedKey{1};
            end

            if strcmp(pressedKey, 'RightArrow')  % Check if RightArrow is pressed
                response = 'Right';  % ts2 is longer
                correct = ts2 > ts1;
                validKeyPressed = true;  % Exit loop
            elseif strcmp(pressedKey, 'LeftArrow')  % Check if LeftArrow is pressed
                response = 'Left';  % ts2 is shorter
                correct = ts2 < ts1;
                validKeyPressed = true;  % Exit loop
            end
        end
    end

    % Save the trial data to CSV file
    fprintf(fileID, '%d,%.2f,%.2f,%s,%d\n', trial, ts1, ts2, response, correct);

    % Show feedback (green for correct, red for incorrect)
    if correct
        Screen('FillOval', window, [0, 255, 0], [xCenter - 50, yCenter - 50, xCenter + 50, yCenter + 50]);  % Green circle
    else
        Screen('FillOval', window, [255, 0, 0], [xCenter - 50, yCenter - 50, xCenter + 50, yCenter + 50]);  % Red circle
    end
    Screen('Flip', window);
    WaitSecs(feedback_time);

    % Inter-trial interval
    WaitSecs(1.2);
end

% Close the CSV file and the screen
fclose(fileID);
sca;
