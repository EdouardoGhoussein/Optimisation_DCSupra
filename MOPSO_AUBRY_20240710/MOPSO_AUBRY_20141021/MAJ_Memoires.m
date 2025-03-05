%MAJ_Memoires : Permet de mettre à jour les mémoires de chaque particules
%[Memoires,Memoires_Objectifs,Memoires_Contraintes,Somme_Viols_Memoires] ...
%        = MAJ_Memoires(Essaim,Objectifs,Contraintes,Memoires,Memoires_Objectifs,Memoires_Contraintes)
%
%ARGUMENTS
%   Essaim
%       Vecteur de taille N_variables*N_particules
%       contient les paramètres de N_particules (population)
%   Objectifs
%       Vecteur de taille N_objectifs*N_particules
%       contient les valeurs des objectifs de Essaim
%   Contraintes
%       Vecteur de taille N_contraintes*N_particules
%       contient les valeurs des contraintes de Essaim
%   Memoires_parametres
%       Vecteur de taille N_variables*N_particules
%       contient les valeurs des paramètres des mémoires de chaque
%       particule contenue dans Essaim
%   Memoires_objectifs
%   Memoires_contraintes
%
%DONNEES DE RETOUR
%
%   Memoires_parametres
%       Vecteur de taille N_variables*N_particules
%       contient les nouvelles valeurs des paramètres des mémoires de chaque
%       particule contenue dans Essaim
%   Memoires_objectifs
%   Memoires_contraintes
%   Somme_Viols_Memoires

function [Memoires_Parametres,Memoires_Objectifs,Memoires_Contraintes,Somme_Viols_Memoires] ...
        = MAJ_Memoires(Essaim,Objectifs,Contraintes,Memoires_Parametres,Memoires_Objectifs,Memoires_Contraintes)

% Si la nouvelle position a un Somme_Viols plus faible alors elle devient
% la mémoire
N_particules = length(Essaim(1,:));    
Contraintes_totales = [Contraintes Memoires_Contraintes];
Contraintes_max=max(Contraintes_totales,[],2);



Somme_Viols = sum( diag(1./Contraintes_max(Contraintes_max > 0),0) * max( Contraintes_totales(Contraintes_max > 0,:) , 0 ),1);

Somme_Viols_Essaim = Somme_Viols(1:N_particules);
Somme_Viols_Memoires = Somme_Viols(N_particules+1:2*N_particules);

indices = Somme_Viols_Memoires > Somme_Viols_Essaim;

Memoires_Parametres(:,indices)=Essaim(:,indices);
Memoires_Objectifs(:,indices)=Objectifs(:,indices);
Memoires_Contraintes(:,indices)=Contraintes(:,indices);

%Si la mémoire est dominée :
condition = Somme_Viols_Memoires + Somme_Viols_Essaim == 0;
condition = condition & Memoires_Objectifs(1,:) >= Objectifs(1,:) ...
        & Memoires_Objectifs(2,:) >= Objectifs(2,:);
indices = find(condition);
Memoires_Parametres(:,indices)=Essaim(:,indices);
Memoires_Objectifs(:,indices)=Objectifs(:,indices);
Memoires_Contraintes(:,indices)=Contraintes(:,indices);

%Si la mémoire est non dominée
condition = Somme_Viols_Memoires + Somme_Viols_Essaim == 0;
condition = condition ...
    &~(Memoires_Objectifs(1,:) >= Objectifs(1,:) & Memoires_Objectifs(2,:) >= Objectifs(2,:))...
    &~(Memoires_Objectifs(1,:) <= Objectifs(1,:) & Memoires_Objectifs(2,:) <= Objectifs(2,:));
indices = find(condition);
Memoires_Parametres(:,indices)=Essaim(:,indices);
Memoires_Objectifs(:,indices)=Objectifs(:,indices);
Memoires_Contraintes(:,indices)=Contraintes(:,indices);