%% Plot bifurcation curves versus time variation (for oblique axis)

clc
clear

%% Simulation Parameters

% Fixed system parameters:
A = 1.0432; % equal to the preference parameter (gamma)
B = 1.0;    % always 1
g = 1.0024; % mutual inhibition parameter

% Time span for the simulation:
tspan = [0, 100];
t = linspace(0, 100, 10000);

%% Simulate the 'Forward' sweep (alpha increases from 0 to 1)

% Define a function for the time-dependent parameter 'alpha':
alpha_forward = @(t) 0.5 * (1 + tanh((t - 50) / 10));

% Initial conditions (A1, A2) - start with A1 dominant:
initial_state_forward = [1.0214; 0.0];

% Solve the ODEs using ode45:
[~, solution_forward] = ode45(@(t, state) model(t, state, A, B, g, alpha_forward), t, initial_state_forward);
A1_forward = solution_forward(:, 1);
A2_forward = solution_forward(:, 2);

%% Simulate the 'Backward' sweep (alpha decreases from 1 to 0)

% Define a function for the time-dependent parameter 'alpha':
alpha_backward = @(t) 0.5 * (1 - tanh((t - 50) / 10));

% Initial conditions (A1, A2) - start with A2 dominant:
initial_state_backward = [0.0; 1.0];

% Solve the ODEs using ode45
[~, solution_backward] = ode45(@(t, state) model(t, state, A, B, g, alpha_backward), t, initial_state_backward);
A1_backward = solution_backward(:, 1);
A2_backward = solution_backward(:, 2);

%% Plot

figure('Position', [100, 100, 750, 320]); % Set figure size for a more horizontal plot

% Plot A1 from the forward sweep (A1 is increasing)
plot(t, flipud(A1_forward), 'LineWidth', 3, 'Color', 'b');
hold on;

% Plot A2 from the backward sweep (A2 is decreasing)
plot(t, A2_backward, '-.', 'LineWidth', 3, 'Color', 'r');
hold off;

% title('A_1 & A_2 vs. Time (Oblique Axis)', 'FontSize', 16);
title('Amplitudes vs. Time', 'FontSize', 16);
xlabel('Time (a.u.)','FontSize',14,'FontWeight','bold');
ylabel('A_1, A_2 (a.u.)','FontSize',14,'FontWeight','bold');
grid on;
legend({'A_1: 135°','A_2: 45°'},'FontSize',12);

xticks([0:10:100]);
xticklabels({'0','10','20','30','40','50','60','70','80','90','100'})
yticks([0:0.2:1.2]);
yticklabels({'0.0','0.2','0.4','0.6','0.8','1.0','1.2'})
ylim([0,1.2])
