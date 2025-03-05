% Plots MOPSO results of a bi-objetive optimization
%
% REQUIRED: MOPSO_AUBRY_20141021
%
% AUTHOR: 20240710, L.Queval (loic.queval@gmail.com)

clear all, close all, clc

%% Parameters
simout = load('Resultat_MOPSO_TEMP'); %

%% Display pareto front data

TAB_Pareto = [
    %nb, variables', f(:,k)', g(:,k)', Divers(:,k)'
    num2str([[1:size(simout.Front_Pareto_Parametres,2)]', simout.Front_Pareto_Parametres', simout.Front_Pareto_Objectifs', simout.Front_Pareto_Contraintes']);
    ];
format short g, disp(TAB_Pareto)

%% Pareto front

figure(1),grid on,hold on,box on
    plot(simout.Front_Pareto_Objectifs(1,:),simout.Front_Pareto_Objectifs(2,:),'or'); %pareto
    plot(simout.Objectifs(1,:),simout.Objectifs(2,:),'.r','Markersize',4); %particules de l'essaim
xlabel('f1 []');
ylabel('f2 []');

%% Constraints

Nb_const = size(simout.Front_Pareto_Contraintes,1);

figure(2)
for k = 1:Nb_const
    subplot(Nb_const,1,k), grid on, hold on, box on
    plot(simout.Front_Pareto_Objectifs(1,:),simout.Front_Pareto_Contraintes(k,:),'or'); %variables
    xlabel('f_1 []');
    ylabel(strcat('g_',string(k),' []'));
end

%% Opti variables

Nb_variables = size(simout.Front_Pareto_Parametres,1);

figure(3)
for k = 1:Nb_variables
    subplot(Nb_variables,1,k), grid on, hold on, box on
    plot(simout.Front_Pareto_Objectifs(1,:),simout.Front_Pareto_Parametres(k,:),'or'); %variables
    yline(simout.Domaine(k,1),'--r'); %lower bound
    yline(simout.Domaine(k,2),'--r'); %upper bound
    xlabel('f_1 []');
    ylabel(strcat('x_',string(k),' []'));
end


%% Export
