% Plots MOPSO results of a bi-objetive optimization
%
% REQUIRED: MOPSO_AUBRY_20141021
%
% AUTHOR: 20230306, L.Queval (loic.queval@gmail.com)

clear all, close all, clc

%% Parameters
simout = load('Resultats_MOPSO_OPTI2_2_30'); %

%% Display pareto front data

TAB_Pareto = [
    %nb, variables', f(:,k)', g(:,k)', Divers(:,k)'
    num2str([[1:size(simout.Front_Pareto_Parametres,2)]', simout.Front_Pareto_Parametres', simout.Front_Pareto_Objectifs', simout.Front_Pareto_Contraintes']);
    ];
format short g, disp(TAB_Pareto)

%% Pareto front

figure(1),grid on,hold on,box on
    plot(simout.Front_Pareto_Objectifs(1,:),simout.Front_Pareto_Objectifs(2,:),'-or','Markersize',4); %pareto
    plot(simout.Memoires_Objectifs(1,:),simout.Memoires_Objectifs(2,:),'.r','Markersize',4); %memory
xlabel('f1 []');
ylabel('f2 []');

%% Opti variables

Nb_variables = size(simout.Front_Pareto_Parametres,1);

figure(2)

for k = 1:Nb_variables
    subplot(Nb_variables,1,k), grid on, hold on, box on
    plot(simout.Front_Pareto_Objectifs(1,:),simout.Front_Pareto_Parametres(k,:),'or','Markersize',4); %variables
    xlabel('f_1 []');
    ylabel(strcat('x_',string(k),' []'));
end


% Plots MOPSO results of a bi-objetive optimization
%
% REQUIRED: MOPSO_AUBRY_20141021
%
% AUTHOR: 20230306, L.Queval (loic.queval@gmail.com)

clear all, close all, clc

%% Parameters
simout = load('Resultats_MOPSO_OPTI2_2_30'); %

%% Display pareto front data

TAB_Pareto = [
    %nb, variables', f(:,k)', g(:,k)', Divers(:,k)'
    num2str([[1:size(simout.Front_Pareto_Parametres,2)]', simout.Front_Pareto_Parametres', simout.Front_Pareto_Objectifs', simout.Front_Pareto_Contraintes']);
    ];
format short g, disp(TAB_Pareto)

%% Pareto front

figure(1),grid on,hold on,box on
    plot(simout.Front_Pareto_Objectifs(1,:),simout.Front_Pareto_Objectifs(2,:),'-or','Markersize',4); %pareto
    plot(simout.Memoires_Objectifs(1,:),simout.Memoires_Objectifs(2,:),'.r','Markersize',4); %memory
xlabel('f1 []');
ylabel('f2 []');
xlim([4000, 7000]);
ylim([40000, 50000]);

%% Opti variables

Nb_variables = size(simout.Front_Pareto_Parametres,1);

figure(2)

for k = 1:Nb_variables
    subplot(Nb_variables,1,k), grid on, hold on, box on
    plot(simout.Front_Pareto_Objectifs(1,:),simout.Front_Pareto_Parametres(k,:),'or','Markersize',4); %variables
    xlabel('f_1 []');
    ylabel(strcat('x_',string(k),' []'));
end

% Trouver l'indice du point le plus à gauche du front de Pareto
[~, indice_point_gauche] = min(simout.Front_Pareto_Objectifs(1,:));

% Trouver l'indice du point le plus à droite du front de Pareto
[~, indice_point_droite] = max(simout.Front_Pareto_Objectifs(1,:));

% Calculer le centre du front de Pareto (moyenne des coordonnées)
centre_x = mean(simout.Front_Pareto_Objectifs(1,:));
centre_y = mean(simout.Front_Pareto_Objectifs(2,:));

% Calculer les distances des points au centre
distances_au_centre = sqrt((simout.Front_Pareto_Objectifs(1,:) - centre_x).^2 + (simout.Front_Pareto_Objectifs(2,:) - centre_y).^2);

% Trouver l'indice du point le plus proche du centre
[~, indice_point_centre] = min(distances_au_centre);

% Récupérer les coordonnées des points extrêmes
x_gauche = simout.Front_Pareto_Objectifs(1, indice_point_gauche);
y_gauche = simout.Front_Pareto_Objectifs(2, indice_point_gauche);
x_droite = simout.Front_Pareto_Objectifs(1, indice_point_droite);
y_droite = simout.Front_Pareto_Objectifs(2, indice_point_droite);
x_centre = simout.Front_Pareto_Objectifs(1, indice_point_centre);
y_centre = simout.Front_Pareto_Objectifs(2, indice_point_centre);

% Récupérer les variables correspondantes
variables_gauche = simout.Front_Pareto_Parametres(:, indice_point_gauche);
variables_droite = simout.Front_Pareto_Parametres(:, indice_point_droite);
variables_centre = simout.Front_Pareto_Parametres(:, indice_point_centre);

% Afficher les caractéristiques des points
fprintf('Point le plus à gauche du front de Pareto : (%f, %f)\n', x_gauche, y_gauche);
fprintf('Variables correspondantes :\n');
disp(variables_gauche');

fprintf('\nPoint le plus à droite du front de Pareto : (%f, %f)\n', x_droite, y_droite);
fprintf('Variables correspondantes :\n');
disp(variables_droite');

fprintf('\nPoint le plus proche du centre du front de Pareto : (%f, %f)\n', x_centre, y_centre);
fprintf('Variables correspondantes :\n');
disp(variables_centre');


%% Export

