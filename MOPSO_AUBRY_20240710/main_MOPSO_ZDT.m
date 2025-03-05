% Performs MOPSO of the ZDT function.
%
% REQUIRED: Matlab 2023b & MOPSO_AUBRY_20141021
%
% AUTHOR: 20240710, L.Queval (loic.queval@gmail.com)

%% Initialization
clear all, close all, clc

%% Parameters
a = 9;
parameters = [a];

%% Variables


%% Define settings MOPSO
addpath(genpath('MOPSO_AUBRY_20141021'));

% Domain of the optimization variables
Domaine = [
    0 1 0; %[unit] description
    0 1 0; %[unit] description
    0 1 0; %[unit] description
    0 1 0; %[unit] description
    0 1 0; %[unit] description
    0 1 0; %[unit] description
    0 1 0; %[unit] description
    0 1 0; %[unit] description
    ];

fonction = @(variables)fct_myobjcon(parameters,variables);

options = struct( ...
    ... %Parametres de l'algorithme
    'AlgParams', struct(...
    'N_particules',     100,...    %Nombre de particules
    'N_iterations',     100,...    %Nombre d'iteration
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
    'Fichier',          'Resultat_MOPSO_TEMP.mat'),...  %Nom du fichier dans lequel on sauvegarde les donnees
    ...  %Parametres d'initialisation
    'Initialisation', struct(...
    'Etat',             false,...   %true, on charge, false, on charge pas
    'Fichier',          'Resultat_MOPSO_TEMP.mat'),...  %Nom du fichier que l'on va charger
    ...  %Parametres d'affichage
    'Affichage', struct(...
    'Etat',             false)...    %true, on affiche, false, on affiche pas
    );

%% Run optimization with MOPSO
disp('Optimization in progress ...');
tic
    MOPSO(options);
toc

%% Display optimization result
plot_MOPSO_simout


%% Objective and constraint function
function [f,g,Divers] = fct_myobjcon(parameters,Essaim)

    %%% Option 1: if the function is vectorized %%%
    
    % % Solve the matlab function for this particule
    % [outputs] = fct_ZDT(parameters,Essaim);
    %
    % % Objectifs (to be minimized)
    % f(1:2,:) = outputs(1:2,:); %[unit] blabla
    %
    % % Constraints (must be negative or null)
    % g = zeros(1,length(Essaim(1,:))); %[unit] blabla
    %
    % % Divers
    % Divers = zeros(1,length(Essaim(1,:))); %Divers
    
    %%% Option 2: if the function is not vectorized %%%
    
    % Loop on each particule
    for k=1:1:size(Essaim,2)
    
        % Read the value of the opti variable for this particle
        variables = Essaim(:,k);
    
        % Solve the matlab function for this particule
        [outputs] = fct_ZDT(parameters,variables);
    
        % Objectifs (to be minimized)
        f(1,k)= outputs(1); %[unit] blabla
        f(2,k)= outputs(2); %[unit] blabla
    
        % Constraints (must be negative or null)
        g(1,k)= 0; %[unit] blabla
    
        % Divers
        Divers(1,k)= 0; %[unit] blabla
    
        % Display result of the evaluation for this particule
        % [variables', f(:,k)', g(:,k)', Divers(:,k)']
    
    end

end