%% Parameters

clear all;
close all;
Ic = 300; %[A] tape critical current @77K
Tcritique = 90; %[K] Critic temperature 
Vmax = 650; %[V] Tension max inférieure à 600V
Imax = 630; %[A] Le courant dans la charge ne doit pas venir abimer le supraconducteur
rho = 1/4.8603e8; %[S/m] Conductivité du cuivre
J = 2; %[A/mm²] Densité de courant dans le cuivre
S = (Ic/J)*1e-6; %[m²] Section de la résistance du shuntpour Ic = 300A


%% Point C_cuivre/C_supra
%{
% Point A
alpha = 1.2;
Lt = 1; %[m] tape length
nt = 1; %[-] nb of tape in parallel
Rsh = 2.0e-2; %[Ohm] shunt resistance
outA = lancement_simu(alpha, nt, Lt, Rsh);

% Point B
alpha = 1.2;
Lt = 4.24; %[m] tape length
nt = 1; %[-] nb of tape in parallel
Rsh = 5.7e-3; %[Ohm] shunt resistance
outB = lancement_simu(alpha, nt, Lt, Rsh);

% Point C
alpha = 1.2;
Lt = 59.13; %[m] tape length
nt = 1; %[-] nb of tape in parallel
Rsh = 4.1e-3; %[Ohm] shunt resistance
outC= lancement_simu(alpha, nt, Lt, Rsh);
%}

%% Point CAPEX OPEX
%{
% Point A
alpha = 1.2;
Lt = 2.6; %[m] tape length
nt = 1; %[-] nb of tape in parallel
Rsh = 6.7e-3; %[Ohm] shunt resistance
outA = lancement_simu(alpha, nt, Lt, Rsh);

% Point B
alpha = 1.2;
Lt = 2.6; %[m] tape length
nt = 1; %[-] nb of tape in parallel
Rsh = 2.2e-2; %[Ohm] shunt resistance
outB = lancement_simu(alpha, nt, Lt, Rsh);

% Point C
alpha = 1.2;
Lt = 2; %[m] tape length
nt = 1; %[-] nb of tape in parallel
Rsh = 7.4e-1; %[Ohm] shunt resistance
outC= lancement_simu(alpha, nt, Lt, Rsh);
%}

%% Point Puissance CAPEX
%{

% Point A
alpha = 1.03;
Lt = 1; %[m] tape length
nt = 1; %[-] nb of tape in parallel
Rsh = 1.0e-4; %[Ohm] shunt resistance
outA = lancement_simu(alpha, nt, Lt, Rsh);

% Point B
alpha = 1.67;
Lt = 10.3; %[m] tape length
nt = 1; %[-] nb of tape in parallel
Rsh = 2.0e-2; %[Ohm] shunt resistance
outB = lancement_simu(alpha, nt, Lt, Rsh);

% Point C
alpha = 1.68;
Lt = 56.2; %[m] tape length
nt = 2; %[-] nb of tape in parallel
Rsh = 1.1e-1; %[Ohm] shunt resistance
outC= lancement_simu(alpha, nt, Lt, Rsh);
%}

%% Point CAPEX OPEX multi type
%{
% Point A
alpha = 1.2;
Lt = 1; %[m] tape length
nt = 1; %[-] nb of tape in parallel
Rsh = 2.4e-3; %[Ohm] shunt resistance
Icrit = 75; %[A] Température critique du supra
Ecrit = 2; %[mm] épaisseur du supra
outA= lancement_simu(alpha, nt, Lt, Rsh, Icrit, Ecrit);

% Point B
alpha = 1.2;
Lt = 3; %[m] tape length
nt = 4; %[-] nb of tape in parallel
Rsh = 1.3e-2; %[Ohm] shunt resistance
Icrit = 75; %[A] Température critique du supra
Ecrit = 2; %[mm] épaisseur du supra
outB = lancement_simu(alpha, nt, Lt, Rsh, Icrit, Ecrit);

% Point C
alpha = 1.2;
Lt = 22.33; %[m] tape length
nt = 3; %[-] nb of tape in parallel
Rsh = 0.59; %[Ohm] shunt resistance
Icrit = 112.5; %[A] Température critique du supra
Ecrit = 3; %[mm] épaisseur du supra
outC = lancement_simu(alpha, nt, Lt, Rsh, Icrit, Ecrit);
%}

%% Récupération des données
% Point A
time_a = outA.time.signals.values;
icpl_a = outA.icpl.signals.values;
vcpl_a = outA.vcpl.signals.values;
Ir_a = outA.ir.signals.values;
Vr_a = outA.vr.signals.values;
Vmax_a = Vmax*ones(length(Vr_a),1);
Imax_a = Imax*ones(length(Ir_a),1);
isupra_a = outA.isupra.signals.values;
vsupra_a = outA.vsupra.signals.values;
CPcoil_a = outA.CPcoil.signals.values;
Tsupra_a = outA.Tsupra.signals.values;
Tmax_a = 90*ones(length(Tsupra_a),1);
rsupra_a = outA.rsupra.signals.values;

% Point B
time_b = outB.time.signals.values;
icpl_b = outB.icpl.signals.values;
vcpl_b = outB.vcpl.signals.values;
Ir_b = outB.ir.signals.values;
Vr_b = outB.vr.signals.values;
Vmax_b = Vmax*ones(length(Vr_b),1);
Imax_b = Imax*ones(length(Ir_b),1);
isupra_b = outB.isupra.signals.values;
vsupra_b = outB.vsupra.signals.values;
CPcoil_b = outB.CPcoil.signals.values;
Tsupra_b = outB.Tsupra.signals.values;
Tmax_b = 90*ones(length(Tsupra_b),1);
rsupra_b = outB.rsupra.signals.values;

% Point C
time_c = outC.time.signals.values;
icpl_c = outC.icpl.signals.values;
vcpl_c = outC.vcpl.signals.values;
Ir_c = outC.ir.signals.values;
Vr_c = outC.vr.signals.values;
Vmax_c = Vmax*ones(length(Vr_c),1);
Imax_c = Imax*ones(length(Ir_c),1);
isupra_c = outC.isupra.signals.values;
vsupra_c = outC.vsupra.signals.values;
CPcoil_c = outC.CPcoil.signals.values;
Tsupra_c = outC.Tsupra.signals.values;
Tmax_c = 90*ones(length(Tsupra_c),1);
rsupra_c = outC.rsupra.signals.values;


%% Tracer des courbes

% Point A

% Courbes I_cpl + I_max
subplot(3, 5, 1)
hold on;
plot(time_a, icpl_a)
plot(time_a, Imax_a)
xlabel('Time [s]')
ylabel('Intensity [A]')
legend('i_{cpl}', 'i_{max}')
axis([0 time_a(end) min(icpl_a)*0.9-10 max(Imax_a)*1.1])

% Courbes V_cpl + V_max
subplot(3, 5, 2)
hold on;
plot(time_a, vcpl_a)
plot(time_a, Vmax_a)
xlabel('Time [s]')
ylabel('Voltage [V]')
legend('v_{cpl}', 'v_{max}')
axis([0 time_a(end) min(vcpl_a)*0.9-10 max(Vmax_a)*1.1])


% Courbe T_supra + T_max
subplot(3, 5, 3)
hold on;
plot(time_a, Tsupra_a)
plot(time_a, Tmax_a)
xlabel('Time [s]')
ylabel('Temperature [T]')
legend('Tsupra', 'Tmax')
axis([0 time_a(end) min(Tsupra_a)*0.9-10 max(Tmax_a)*1.1])


% Courbe R_supra
subplot(3, 5, 4)
hold on;
plot(time_a, rsupra_a)
xlabel('Time [s]')
ylabel('Resistance [\Omega]')
legend('Resistance du supra')
axis([0 time_a(end) 0.9*min(rsupra_a) 1.1*max(rsupra_a)])


% Courbe OPEX = CPcoil + I_r*V_r + I_supra*V_supra
subplot(3, 5, 5)
hold on;
OPEX_a = CPcoil_a + Ir_a.*Vr_a + isupra_a.*vsupra_a;
plot(time_a, OPEX_a)
xlabel('Time [s]')
ylabel('Power [W]')
legend('OPEX')
axis([0 time_a(end) -10 max(OPEX_a)*1.1])


% Point B

% Courbes I_cpl + I_max
subplot(3, 5, 6)
hold on;
plot(time_b, icpl_b)
plot(time_b, Imax_b)
xlabel('Time [s]')
ylabel('Intensity [A]')
legend('i_{cpl}', 'i_{max}')
axis([0 time_b(end) min(icpl_b)*0.9-10 max(Imax_b)*1.1])

% Courbes V_cpl + V_max
subplot(3, 5, 7)
hold on;
plot(time_b, vcpl_b)
plot(time_b, Vmax_b)
xlabel('Time [s]')
ylabel('Voltage [V]')
legend('v_{cpl}', 'v_{max}')
axis([0 time_b(end) min(vcpl_b)*0.9-10 max(Vmax_b)*1.1])


% Courbe T_supra + T_max
subplot(3, 5, 8)
hold on;
plot(time_b, Tsupra_b)
plot(time_b, Tmax_b)
xlabel('Time [s]')
ylabel('Temperature [T]')
legend('Tsupra', 'Tmax')
axis([0 time_b(end) min(Tsupra_b)*0.9-10 max(Tmax_b)*1.1])


% Courbe R_supra
subplot(3, 5, 9)
hold on;
plot(time_b, rsupra_b)
xlabel('Time [s]')
ylabel('Resistance [\Omega]')
legend('Resistance du supra')
axis([0 time_b(end) 0.9*min(rsupra_b) 1.1*max(rsupra_b)])


% Courbe OPEX = CPcoil + I_r*V_r + I_supra*V_supra
subplot(3, 5, 10)
hold on;
OPEX_b = CPcoil_b + Ir_b.*Vr_b + isupra_b.*vsupra_b;
plot(time_b, OPEX_b)
xlabel('Time [s]')
ylabel('Power [W]')
legend('OPEX')
axis([0 time_b(end) -10 max(OPEX_b)*1.1])

% Point C

% Courbes I_cpl + I_max
subplot(3, 5, 11)
hold on;
plot(time_c, icpl_c)
plot(time_c, Imax_c)
xlabel('Time [s]')
ylabel('Intensity [A]')
legend('i_{cpl}', 'i_{max}')
axis([0 time_c(end) min(icpl_c)*0.9-10 max(Imax_c)*1.1])

% Courbes V_cpl + V_max
subplot(3, 5, 12)
hold on;
plot(time_c, vcpl_c)
plot(time_c, Vmax_c)
xlabel('Time [s]')
ylabel('Voltage [V]')
legend('v_{cpl}', 'v_{max}')
axis([0 time_c(end) min(vcpl_c)*0.9-10 max(Vmax_c)*1.1])


% Courbe T_supra + T_max
subplot(3, 5, 13)
hold on;
plot(time_c, Tsupra_c)
plot(time_c, Tmax_c)
xlabel('Time [s]')
ylabel('Temperature [T]')
legend('Tsupra', 'Tmax')
axis([0 time_c(end) min(Tsupra_c)*0.9-10 max(Tmax_c)*1.1])


% Courbe R_supra
subplot(3, 5, 14)
hold on;
plot(time_c, rsupra_c)
xlabel('Time [s]')
ylabel('Resistance [\Omega]')
legend('Resistance du supra')
axis([0 time_c(end) 0.9*min(rsupra_c) 1.1*max(rsupra_c)])


% Courbe OPEX = CPcoil + I_r*V_r + I_supra*V_supra
subplot(3, 5, 15)
hold on;
OPEX_c = CPcoil_c + Ir_c.*Vr_c + isupra_c.*vsupra_c;
plot(time_c, OPEX_c)
xlabel('Time [s]')
ylabel('Power [W]')
legend('OPEX')
axis([0 time_c(end) -10 max(OPEX_c)*1.1])