%% Fit psychometric function and assess its goodness-of-fit (cardinal axis, with 90° rotation)
%  using the Palamedes toolbox
clc
clear

%% Data preparation

% Stimulus levels:
% stimulusLevels = [1,2,3,4,5,6,7,8,9,10,11,12,13]/13; % stimuli number
% AR values:
stimulusLevels = [0.409836066,0.564971751,0.704225352,0.813008130,0.892857143,0.952380952,1,1.05000000,1.12000000,1.23000000,1.42000000,1.77000000,2.44000000]; 

% Number of 'Yes' responses for each stimulus level (here, it means "Horizontal" responses):
numResponses = [0,0,4,7,15,29,55,77,117,176,235,267,272]; % Note: these are the mean values of asending and descending conditions

% Total number of trials for each stimulus level:
totalTrials = max(numResponses)*ones(1,13); 

%% Fit the function to the data

% Define the psychometric function:
PF = @PAL_Logistic; 

% Set up initial parameter guesses for the fitting process:
paramsFree = [1,1,1,1]; % Specifies which parameters to fit (1=fit, 0=fixed)
initialParams = [1, 10, 0.5, 0]; % [alpha, beta, gamma, lambda]

% Do the fit:
options = struct; 
[paramsFitted, LL, exitflag] = PAL_PFML_Fit(stimulusLevels, numResponses, totalTrials, initialParams, paramsFree, PF); 

%% Calculate goodness-of-fit criteria

% Extract common criteria: 
B = 1000; % the number of simulations for the goodness-of-fit test
[Deviance, pValue, Dev_Sim, converged] = PAL_PFML_GoodnessOfFit(stimulusLevels, numResponses, totalTrials, paramsFitted, paramsFree, B, PF, 'SearchOptions', options);

% Calculate R-squared:
observedProportions = numResponses ./ totalTrials;    % Observed proportions
fittedProportions = PF(paramsFitted, stimulusLevels); % Fitted proportions at the stimulus levels
meanObservedProportions = mean(observedProportions);  % Mean of the observed proportions

SStot = sum((observedProportions - meanObservedProportions).^2); % Total sum of squares
SSres = sum((observedProportions - fittedProportions).^2);       % Residual sum of squares
R_squared = 1 - (SSres / SStot); % R-squared calculation

%% ascending and descending sequences

% ascending sequence ------------------------------------------------------
% Number of 'Yes' responses for each stimulus level:
numResponses_asc = [0,0,3,6,10,13,21,32,49,80,113,132,136];

% Total number of trials for each stimulus level:
totalTrials_asc = max(numResponses_asc)*ones(1,13); 

% Define the psychometric function:
PF_asc = @PAL_Logistic; 

% Set up initial parameter guesses for the fitting process:
initialParams_asc = [1, 10, 0.5, 0]; % [alpha, beta, gamma, lambda]

% Do the fit:
[paramsFitted_asc, ~, ~] = PAL_PFML_Fit(stimulusLevels, numResponses_asc, totalTrials_asc, initialParams_asc, paramsFree, PF_asc); 

% descending sequence -----------------------------------------------------
% Number of 'Yes' responses for each stimulus level:
numResponses_desc = [0,0,1,1,5,16,34,45,68,96,122,135,136];

% Total number of trials for each stimulus level:
totalTrials_desc = max(numResponses_desc)*ones(1,13); 

% Define the psychometric function:
PF_desc = @PAL_Logistic; 

% Set up initial parameter guesses for the fitting process:
initialParams_desc = [1, 10, 0.5, 0]; % [alpha, beta, gamma, lambda]

% Do the fit:
[paramsFitted_desc, ~, ~] = PAL_PFML_Fit(stimulusLevels, numResponses_desc, totalTrials_desc, initialParams_desc, paramsFree, PF_desc); 

%% Visualize the results

% Create a smooth curve for the fitted functions:
stimulusRange = linspace(min(stimulusLevels), max(stimulusLevels), 100); 
proportionCorrectFitted = PF(paramsFitted, stimulusRange); 
proportionCorrectFitted_asc = PF_asc(paramsFitted_asc, stimulusRange);
proportionCorrectFitted_desc = PF_desc(paramsFitted_desc, stimulusRange);

% Plot the raw data and the fitted curves:
figure('Position', [100, 100, 750, 500]); % set figure size
semilogx(stimulusLevels, numResponses ./ totalTrials, 'o', 'MarkerSize',13, 'MarkerEdgeColor','#77AC30', 'MarkerFaceColor','g'); 
hold on; 
semilogx(stimulusRange, proportionCorrectFitted_asc, 'r--', 'LineWidth',3); 
semilogx(stimulusRange, proportionCorrectFitted_desc, 'b-.', 'LineWidth',3); 
semilogx(stimulusRange, proportionCorrectFitted, 'k-', 'LineWidth',3.75); 
xlabel('Aspect Ratio (AR: |b|/|a|)'); 
ylabel('Proportion of Horizontal Responses'); 
title('Cardinal Axis (With 90° Rotation)'); 
grid on; 
hold off; 
legend({'Mean data points','Ascending order','Descending order','Mean fitted curve'});

xticks([0.41,0.56,0.70,0.81,0.89,0.95,1.00,1.05,1.12,1.23,1.42,1.77,2.44]);
xticklabels({'0.41','0.56','0.70','0.81','0.89','','1.00','','1.12','1.23','1.42','1.77','2.44'})
xtickangle(90);
yticks([0:0.1:1]);
yticklabels({'0.0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0'})

%% Extract and print the results

% Calculate the 75% threshold:
threshold_75 = PAL_Logistic(paramsFitted, 0.75, 'inverse'); 

% Display the fitted parameters and goodness-of-fit results:
fprintf('Fitted Parameters:\n');
fprintf('  Threshold (alpha): %f\n', paramsFitted(1));
fprintf('  Slope (beta): %f\n', paramsFitted(2));
fprintf('  Guess Rate (gamma): %f\n', paramsFitted(3));
fprintf('  Lapse Rate (lambda): %f\n', paramsFitted(4));
fprintf('\nGoodness-of-Fit Results:\n');
fprintf('  Deviance: %f\n', Deviance);
fprintf('  p-Value: %f\n', pValue);
if pValue > 0.05
    fprintf('  The model provides a good fit to the data (p > 0.05).\n');
else
    fprintf('  The model does not provide a good fit to the data (p <= 0.05).\n');
end
fprintf('\nModel Performance:\n');
fprintf('  R-squared: %f\n', R_squared);
fprintf('75%% Threshold: %f\n', threshold_75);
