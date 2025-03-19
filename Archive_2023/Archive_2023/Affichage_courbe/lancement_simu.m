function [out] = lancement_simu(alpha_pt, nt_pt, Lt_pt, Rsh_pt, Icrit_pt, Ecrit_pt)
%% Paramétrisation
nt = nt_pt;
alpha = alpha_pt;
Lt = Lt_pt;
Rsh = Rsh_pt;
Icrit = Icrit_pt;
Ecrit = Ecrit_pt;
tsim = 1; %[s] simulation time
Ts = 2e-5; %[s] solver time step
ts = Ts;
Ve = 540; %[V] input voltage
R = 11.7e-3; %[Ohm] RLC resistance
L = 11.66e-6; %[H] RLC inductance
C = 583e-6; %[F] RLC capacitance
Ps_ref = 170.5e3; %[W] power reference
Ps = alpha*Ps_ref;
Tcritique = 90; %[K] Critic temperature 
Vmax = 650; %[V] Tension max inférieure à 600V
Imax = 630; %[A] Le courant dans la charge ne doit pas venir abimer le supraconducteur
rho = 1/4.8603e8; %[S/m] Conductivité du cuivre
J = 2; %[A/mm²] Densité de courant dans le cuivre
S = (Icrit/J)*1e-6; %[m²] Section de la résistance du shuntpour Ic = 300A

assignin("base", "alpha", alpha)
assignin("base", "nt", nt)
assignin("base", "tsim", tsim)
assignin("base", "Ts", Ts)
assignin("base", "Ve", Ve)
assignin("base", "C", C)
assignin("base", "R", R)
assignin("base", "L", L)
assignin("base", "alpha", alpha)
assignin("base", "nt", nt)
assignin("base", "Rsh", Rsh)
assignin("base", "ts", ts)
assignin("base", "Ps_ref", Ps_ref)
assignin("base", "Ps", Ps)
assignin("base", "Icrit", Icrit)
assignin("base", "Ecrit", Ecrit)

%% Sortie
open_system('./systeme_with_supra.slx', 'loadonly'); % Charge le modèle
out=sim("./systeme_with_supra.slx"); % Simule le modèle
end