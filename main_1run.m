clear all; close all; clc;

% fonction qui lance la simu et de récupe les indicateurs de performances

run("param.m")

% Define model name
model = 'DC_grid_noSCPF'; % Change this to your actual Simulink model name

% Load the Simulink model
load_system(model);

% Run the simulation
simOut = sim(model);

% Close the model (optional)
close_system(model, 0);

% Extract results
time = simOut.tout;
data = simOut.yout;

vcpl = data{1}.Values.Data;

first_time = 0.112;
indices = time < first_time;
maxIV = max(vcpl(indices));

final_time = 0.2;
indices = time > first_time;
maxfV = max(vcpl(indices));

if maxIV < maxfV 
    disp("AAAAAAAAAAAAAAAAA")
else
    disp("sweethome alebama")
end

% Display some results
disp('Simulation completed.');
plot(time, vcpl);
xlabel('Time (s)');
ylabel('Output Data');
title('Simulation Results');
