% Plots MOPSO results of a bi-objetive optimization
%
% REQUIRED: MOPSO_AUBRY_20141021
%
% AUTHOR: 20230306, L.Queval (loic.queval@gmail.com)

clear all, close all, clc
addpath('Results\')

% Parameters
simout = load('opti capex opex multi types supra 40 180 0.1e-3 1 1 100 18 1 6'); %

% Display pareto front data

TAB_Pareto = [
    %nb, variables', f(:,k)', g(:,k)', Divers(:,k)'
    num2str([[1:size(simout.Front_Pareto_Parametres,2)]', simout.Front_Pareto_Parametres', simout.Front_Pareto_Objectifs', simout.Front_Pareto_Contraintes']);
    ];
format short g, disp(TAB_Pareto)

% Pareto front

figure(1),grid on,hold on,box on
    plot(simout.Front_Pareto_Objectifs(2,:),simout.Front_Pareto_Objectifs(1,:),'-ob','Markersize',4, 'DisplayName',''); %pareto
    plot(simout.Memoires_Objectifs(2,:),simout.Memoires_Objectifs(1,:),'.r','Markersize',4); %memory

simout = load('opti CAPEX OPEX 40 150 29 03 2023.mat'); %

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
xlabel('CAPEX');
ylabel('OPEX');
%axis([0 200 -2.8e6 -2.4e6]);
title('Front de pareto');
legend('off');

%% Opti variables
simout = load('Resultat_MOPSO_TEMP');
Nb_variables = size(simout.Front_Pareto_Parametres,1);

figure(2)

for k = 1:Nb_variables
    subplot(Nb_variables,1,k), grid on, hold on, box on
    plot(simout.Front_Pareto_Objectifs(2,:),simout.Front_Pareto_Parametres(k,:),'or','Markersize',4); %variables
    xlabel('f_1 []');
    ylabel(strcat('x_',string(k),' []'));
end


%% Export
