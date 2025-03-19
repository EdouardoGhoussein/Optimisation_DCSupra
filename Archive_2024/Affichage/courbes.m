load_system('Sim_avec_ScPF.slx');
out = sim('Sim_avec_ScPF.slx', 'OutputSaveName', 'out');

% Get the time vector from the 'iScPF' sub-structure
time = out.i_ScFCL.time;

% Get the iScPF data
i_ScFCL = out.i_ScFCL.signals.values;

Ish = out.T_Ish.signals.values;

% Get the rScPF data
RScFCL = out.RScFCL.signals.values;

% Get the Tsupra data
T_out = out.T_out.signals.values;

% Get the rScPF * iScPF * iScPF data
PScFCL = RScFCL .* i_ScFCL .* i_ScFCL;

% Get the CPcoil data
CPcoil = out.CPcoil.signals.values;

i_cpl = out.Icpl.signals.values;

v_cpl = out.Vcpl.signals.values;

% Create a figure for iScPF, ILayer, and Ish
figure;
plot(time, i_cpl, 'b');
xlabel('Time');
ylabel('Current (A)');
title('icpl vs. Time');

grid on;

% Create a figure for iScPF, ILayer, and Ish
figure;
plot(time, v_cpl, 'b');
xlabel('Time');
ylabel('Voltage (V)');
title('vcpl vs. Time');

grid on;

% Create a figure for iScPF, ILayer, and Ish
figure;
plot(time, i_ScFCL, 'b', time, Ish, 'g');
xlabel('Time');
ylabel('Current (A)');
title('iScPF, and Ish vs. Time');
legend('iScPF', 'Ish');
grid on;

% Create a figure for rScPF
figure;
plot(time, RScFCL, 'm');
xlabel('Time');
ylabel('Resistance (Ohms)');
title('rScPF vs. Time');
grid on;

% Create a figure for Tsupra
figure;
plot(time, T_out, 'k');
xlabel('Time');
ylabel('Temperature (K)');
title('Tsupra vs. Time');
grid on;


% Create a new figure for PScPF and CPcoil
figure;

% Plot PScPF
plot(time, PScFCL, 'c');
hold on; % To keep the current plot while adding another one
xlabel('Time');
ylabel('PScPF');
title('PScPF and CPcoil vs. Time');

grid on;

% Plot CPcoil
plot(time, CPcoil, 'm');
xlabel('Time');
ylabel('CPcoil');
legend('PScPF', 'CPcoil'); % Add a legend to distinguish between the two

grid on;

