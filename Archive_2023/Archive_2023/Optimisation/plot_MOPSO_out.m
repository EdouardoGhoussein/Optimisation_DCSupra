% Plots MOPSO results of a bi-objetive optimization
%
% REQUIRED: MOPSO_AUBRY_20141021
%
% AUTHOR: 20230306, L.Queval (loic.queval@gmail.com)

clear all, close all, clc
addpath('Results\')

% Parameters
simout = load('Resultat_MOPSO_TEMP.mat'); %

% Display pareto front data

TAB_Pareto = [
    %nb, variables', f(:,k)', g(:,k)', Divers(:,k)'
    num2str([[1:size(simout.Front_Pareto_Parametres,2)]', simout.Front_Pareto_Parametres', simout.Front_Pareto_Objectifs', simout.Front_Pareto_Contraintes']);
    ];
format short g, disp(TAB_Pareto)

% Pareto front

figure(1),grid on,hold on,box on
    plot(simout.Front_Pareto_Objectifs(1,:),simout.Front_Pareto_Objectifs(2,:),'-or','Markersize',4, 'DisplayName',''); %pareto
    plot(simout.Memoires_Objectifs(1,:),simout.Memoires_Objectifs(2,:),'.r','Markersize',4); %memory
xlabel('CAPEX [€]');
ylabel('OPEX [W]');
legend('off');

%% tracer 2 fronts sur même graphe
% Parameters
simout = load('opti alpha ntlt.mat'); %

% Pareto front

figure(1),grid on,hold on,box on
    plot(simout.Front_Pareto_Objectifs(2,:),simout.Front_Pareto_Objectifs(1,:),'-ob','Markersize',4,'DisplayName','Moins de points et d itérations'); %pareto
    plot(simout.Memoires_Objectifs(2,:),simout.Memoires_Objectifs(1,:),'.b','Markersize',4); %memory

%% Opti variables
close(figure(2))
simout = load('Resultat_MOPSO_TEMP.mat');
Nb_variables = size(simout.Front_Pareto_Parametres,1);

figure(2)

for k = 1:Nb_variables
    subplot(Nb_variables,1,k), grid on, hold on, box on
    plot(simout.Front_Pareto_Objectifs(2,:),simout.Front_Pareto_Parametres(k,:),'or','Markersize',4); %variables
    xlabel('f_1 []');
    ylabel(strcat('x_',string(k),' []'));
end

