clear all, close all, clc
addpath('MOPSO_AUBRY_20141021');
load_system('Sim0')


%%Parametres
R = 4e-2;
P = 2e6;
Ve = 5e3;
L = 6e-4;
C = 1.4e-3;
Ts = 1e-4;
t0 = 0.1;
Tsim = 1;

%%Bornes
lb = [5e-3; 1e6];
ub = [100e-3; 10e6];
vartyp = [0; 0];



options.AlgParams.N_particules = 10;                                %Population size
options.AlgParams.N_iterations = 10;                                %# of generations
options.AlgParams.N_variables = length(vartyp);                     %# of variables
options.AlgParams.N_archive = options.AlgParams.N_particules*20;    %Storage size for past optimal points

options.StraParams.Accel_memoire = 1;
options.StraParams.Accel_guide = 1;
options.StraParams.Inertie_debut = 0.8;
options.StraParams.Inertie_fin = 0.8;
options.StraParams.Proba_mut = 0.01;
options.StraParams.Fact_constrict = 0;



options.Objectif.fonction = @J_obj0;                                %Objective function
options.Objectif.Domaine = [lb ub vartyp];                          %Domain of each variable (in order: lower bound, upper bound, type (continuous/discrete)

options.Sauvegarde.Etat = true;                                    %Whether to save after each iteration
options.Sauvegarde.Fichier = 'Resultats_MOPSO_TEMP.mat';            %filename for save


options.Initialisation.Etat = false;                                    %Initialization type
options.Initialisation.Fichier = 'Resultats_MOPSO_TEMP.mat';        %Initialization file (if true)

options.Affichage.Etat = false;



%%DefMOPSO
MultiObj.fun = @(x) J_obj0(x);
MultiObj.nVar = 2;
MultiObj.var_min = lb;
MultiObj.var_max = ub;

% Parameters
params.Np = 200;        % Population size
params.Nr = 200;        % Repository size
params.maxgen = 100;    % Maximum number of generations
params.W = 0.4;         % Inertia weight
params.C1 = 2;          % Individual confidence factor
params.C2 = 2;          % Swarm confidence factor
params.ngrid = 20;      % Number of grids in each dimension
params.maxvel = 5;      % Maxmium vel in percentage
params.u_mut = 0.5;     % Uniform mutation percentage

%%
%[REP,MDO] = MDOMOPSO(MultiObj.fun,MultiObj.nVar, MultiObj.var_min, MultiObj.var_max, params);
tic
[Pareto_X, Pareto_obj] = MOPSO(options);
toc
%Reset
mdl = 'Sim1';
Pobj = '/Constant2';
Pval = 'Value';
Ppath = [mdl, Pobj];

Robj = '/Series RLC Branch';
Rval = 'Resistance';
Rpath = [mdl, Robj];

set_param(Ppath, Pval, 'P');
set_param(Rpath, Rval, 'R');


%%
hold on
mopso_plot0()

simout = load('Resultats_MOPSO_TEMP.mat');
res = simout.Front_Pareto_Objectifs;

rel_nom = C/L*Ve^2
rel_exp = mean(-1*res(2,:)./res(1,:))


xnom = linspace(lb(1,1), ub(1,1), 10);
ynom = rel_nom*xnom*1e-6;
plot(xnom,ynom,'DisplayName','Front théorique')
legend()
shg
hold off




