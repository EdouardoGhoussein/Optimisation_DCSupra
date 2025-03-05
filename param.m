%% Parametres

clear all; close all; clc;

%% Parametres
Ve = 5e3;           %[V] dource voltage
R = 40e-3;          %[Ohm] resistance
L = 0.6e-3;         %[H] inductance
C = 1.4e-3;         %[F] capacitance
Ps_ref = 2e6;       %[W] reference power


Ic = 300;           %[A] critical current
Lt = 100;           %[m] tape length
Rsh = 50e-3;        %[Ohm] shunt resistance
nt = 2;             % nb tapes in parallele

ts = 1e-4;          %[s] step time
%% Variables
%% Set stability limit
Ps_max = R*C/L*Ve^2;