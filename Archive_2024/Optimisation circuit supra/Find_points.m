clear all, close all, clc
%%

graph_ratios = 0
%%
%Find extrema and intermediate point of interest

res = load("Resultats_MOPSO_OPTI1_30.mat"); %nom du fichier d'optimisation



pt_nb = size(res.Front_Pareto_Objectifs,2);
pt_dist = zeros(1,pt_nb);
for k = 1:1:pt_nb
    pt_dist(k) = norm(res.Front_Pareto_Objectifs(:,k),2);   %remplacer par la fonction de selection de point intermédiaire voulue
end

[~,mind] = min(pt_dist)


pt_param = res.Front_Pareto_Parametres(:,[1,mind,end])

%%
%Calculate objectives

load_system('Sim_avec_ScPF')
[f,g,h] = J_obj2data(pt_param);
f
g;

%%
%Reset
mdl = 'Sim_avec_ScPF';
nt_obj = '/ScFCL v2p2_revLQ';
nt_val = 'nt';
nt_path = [mdl, nt_obj];

Lt_obj = '/ScFCL v2p2_revLQ';
Lt_val = 'tl';
Lt_path = [mdl, Lt_obj];

Rsh_obj = '/ScFCL v2p2_revLQ';
Rsh_val = 'Rsh';
Rsh_path = [mdl, Rsh_obj];

set_param(nt_path, nt_val, 'nt');
set_param(Lt_path, Lt_val, 'Lt');
set_param(Rsh_path, Rsh_val, 'Rsh');

%%
%Graph objectives contributions

if graph_ratios
for i = 1:3
    figure(i)
    subplot(1,2,1)
    piechart(f(1,2:3,i),["Copper", "Superconductor"])
    subplot(1,2,2)
    piechart(f(2,2:3,i),["Cooling", "Waste"])
    shg
end
end