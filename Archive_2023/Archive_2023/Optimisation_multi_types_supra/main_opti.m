function []=main_opti()
% Performs MOPSO of the systeme with supraconductor and with parameters.
%
% REQUIRED: MOPSO_AUBRY_20141021
%
% AUTHOR: 20230306, L.Queval (loic.queval@gmail.com)
%         20230309, L.Dupont

%% Initialization
clear all, close all, clc
addpath('MOPSO_AUBRY_20141021\')
addpath('functions\')



%% Parameters
tsim = 1.5; %[s] simulation time
Ts = 2e-5; %[s] solver time step
ts = Ts;
Ve = 540; %[V] input voltage
R = 11.7e-3; %[Ohm] RLC resistance
L = 11.66e-6; %[H] RLC inductance
C = 583e-6; %[F] RLC capacitance
Ps_ref = 170.5e3; %[W] power reference
alpha = 1.2;
Ps = alpha*Ps_ref;
% ScPF
Ic = [75 112.5 150 225 300 450]; %[A] tape critical current @77K
Ep = [2 3 4 6 12 12]; %[mm] tape width
%Lt = 100; %[m] tape length
%nt = 2; %[-] nb of tape in parallel
%Rsh = 50e-3; %[Ohm] shunt resistance
Tmax = 90; %[K] Critic temperature 
Vmax = 650; %[V] Tension max inférieure à 650V
Imax = 630; %[A] Le courant dans la charge ne doit pas venir abimer le supraconducteur (2*I_nom)

rho = 1 / 4.8603e8; %[S/m] Résistivité du cuivre @77K
J = 2; %[A/mm2] Densité de courant dans le cuivre 

parameters=var2struct([],tsim, Ts, Ep, ts, Ve, C, Ic, Ps_ref, L, R, Tmax, Vmax, Imax, rho, J, alpha, Ps);


%% Variables
variables=var2struct([]);

%% Define settings MOPSO

% Domain of the optimization variables
Domaine = [
    0.1e-3 1 0; %[Ohms] Shunt resistance
    1 100 0; %[m] Longueur des rubans
    1 8 1;   %[-] Nombre de rubans en parallèle
    1 6 1]; %[-] index of the caracteristics of the superconductor



fonction = @(Essaim)fct_myobjcon(Essaim);

options = struct( ...
    ... %Parametres de l'algorithme
    'AlgParams', struct(...
    'N_particules',     3,...    %Nombre de particules 100
    'N_iterations',     150,...    %Nombre d'iteration 100
    'N_variables',      length(Domaine(:,1)), ...   %Nombres de variables
    'N_archive',        100),...   %Taille de l'archive
    ...  %Parametres de strategie
    'StraParams', struct(...
    'Accel_memoire',    1, ...     %Acceleration cognitive
    'Accel_guide',      1, ...     %Acceleration sociale
    'Inertie_debut',    0.8, ...   %Valeur de l'inertie au debut de l'algorithme
    'Inertie_fin',      0.8, ...   %Valeur de l'inertie a la fin de l'algorithme
    'Proba_mut',        0.01, ...  %Proportion de particules mutees
    'Fact_constrict',   0), ...    %Facteur de constriction
    ...  %Fonction objectif
    'Objectif', struct(...
    'fonction',         fonction, ... %Handle de la fonction a minimiser
    'Domaine',          Domaine), ... %Domaine de l'espace de recherche matrice (N_variable*2)
    ...  %Parametres de sauvegarde
    'Sauvegarde', struct(...
    'Etat',             true,...    %true, on sauvegarde, false, on sauvegarde pas
    'Fichier',          'Results\Resultat_MOPSO_TEMP.mat'),...  %Nom du fichier dans lequel on sauvegarde les donn�es
    ...  %Parametres d'initialisation
    'Initialisation', struct(...
    'Etat',             false,...   %true, on charge, false, on charge pas
    'Fichier',          'Results\Resultat_MOPSO_TEMP.mat'),...  %Nom du fichier que l'on va charger
    ...  %Parametres d'affichage
    'Affichage', struct(...
    'Etat',             false)...    %true, on affiche, false, on affiche pas
    );

%% Run optimization with MOPSO
disp('Optimizing ...');
tic
MOPSO(options);
toc

%% Display optimization result
% plot_MOPSO_out


%% Objective and constraint function
function [f,g,Divers] = fct_myobjcon(Essaim)
    % Loop on each particule
    for k=1:1:size(Essaim,2)
        
        % Read the value of the opti variable for this particle
        variables.Rsh = Essaim(1,k);
        variables.Lt = Essaim(2,k);
        variables.nt = Essaim(3,k);
        variables.index = Essaim(4,k);
        %variables.alpha = Essaim(4,k);

        %variables.Ps = variables.alpha * parameters.Ps_ref;
        variables.Icrit = Ic(variables.index);
        variables.Ecrit = Ep(variables.index);
        variables.S = (variables.Icrit * variables.nt / parameters.J)*1e-6; %[m2] Section de la résistance de shunt pour Ic = 300A
        variables.L_cuivre = variables.Rsh * variables.S / parameters.rho;
        

        % Solve the matlab function for this particule
        outputs=fct_modelesupra(variables,parameters);
        
        % Objectifs (to be minimized)
        % f(1,k) = variables.L_cuivre;
        % f(1,k)= -variables.alpha;
        f(1,k)= mean(outputs.CPcoil) + mean(outputs.isupra .* outputs.vsupra) + mean(outputs.Ir .* outputs.Vr); %OPEX
        f(2,k)= 100*variables.nt * variables.Lt * Ep(variables.index)/12 + variables.L_cuivre; %CAPEX
        %f(2,k) = 100*variables.nt * variables.Lt;
    
        % Constraints (must be negative or null)
        g(1,k)= is_stable(outputs.Iout); %[-] Stabilité (-1 si le système est stable, 1 sinon)
        g(2,k)= max(outputs.Vout) - parameters.Vmax; %[V] Tension de la charge < Vmax
        g(3,k)= -min(outputs.Vout); %[V] Tension de la charge positive
        g(4,k)= max(outputs.Tsupra,[],'all') - parameters.Tmax; %[K] Temperature du supra < Tcritique
        g(5,k)= max(outputs.Iout) - parameters.Imax; %[A] Courant dans la charge < Imax

    
        %Divers
        Divers(1,k)= 0; %[unit] blabla
    end
end


end