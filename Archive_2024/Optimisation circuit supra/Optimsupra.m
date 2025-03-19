clear all, close all, clc
%%

load_system('Sim_avec_ScPF')


%%Parametres
R = 4e-2;
Ve = 5e3;
L = 6e-4;
C = 1.4e-3;
Ts = 1e-4;
t0 = 0.1;
Tsim = 1;

P = 4e6;


%Parametres supraconducteur
Rsh = 50e-3;
Lt = 100;
nt = 2;
Ic = 300;
Tc = 92;
tw = 4;
ts = Ts;
n0 = 21;



%%Bornes
lb = [1; 1; 1e-3];
ub = [5; 300; 600e-3];
vartyp = [1; 0; 0];

bounds = [lb ub vartyp];

options.AlgParams.N_particules = 100;                                %Population size
options.AlgParams.N_iterations = 20;                                %# of generations
options.AlgParams.N_variables = length(vartyp);                     %# of variables
options.AlgParams.N_archive = options.AlgParams.N_particules*20;    %Storage size for past optimal points

options.StraParams.Accel_memoire = 1;
options.StraParams.Accel_guide = 1;
options.StraParams.Inertie_debut = 0.8;
options.StraParams.Inertie_fin = 0.8;
options.StraParams.Proba_mut = 0.01;
options.StraParams.Fact_constrict = 0;



options.Objectif.fonction = @J_obj2;                                %Objective function
options.Objectif.Domaine = bounds;                          %Domain of each variable (in order: lower bound, upper bound, type (continuous/discrete)

options.Sauvegarde.Etat = true;                                    %Whether to save after each iteration
options.Sauvegarde.Fichier = 'Resultats_MOPSO2_TEMP.mat';            %filename for save


options.Initialisation.Etat = true;                                    %Initialization type
options.Initialisation.Fichier = 'Resultats_MOPSO2_TEMP.mat';        %Initialization file (if true)

options.Affichage.Etat = false;


%%
tic
[Pareto_X, Pareto_obj] = MOPSO(options);
toc

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
hold on
plt_options.filename = 'Resultats_MOPSO2_TEMP.mat';
plt_options.obj_labels = ["CAPEX","OPEX"];
plt_options.var_labels = ["n_{t}" "L_{t}" "R_{sh}"];
plt_options.title = 'Optimisation de CAPEX et OPEX';
plt_options.bounds = bounds;
mopso_plot(plt_options)


legend()
shg
hold off




