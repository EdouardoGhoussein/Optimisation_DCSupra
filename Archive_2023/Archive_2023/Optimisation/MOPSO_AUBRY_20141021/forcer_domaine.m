%forcer_domaines : Permet de conserver les particules à l'interieur de
%l'espace de Recherche
%[Essaim,Vitesses] = forcer_domaine(Essaim,Vitesses,Domaine)
%
%ARGUMENTS
%   Essaim
%       Vecteur de taille N_variables*N_particules
%       contient les paramètres de N_particules (population)
%       Vecteur de taille N_objectifs*N_particules
%       contient les valeurs des objectifs de Essaim
%   Domaine
%       Vecteur de taille N_variables*2
%       définissant les valeurs min et max de chaque paramètres
%       d'optimisation
%
%DONNEES DE RETOUR
%
%   Essaim
%       Vecteur réactualisé

function [Essaim] = forcer_domaine(Essaim,Domaine)

N_particules = length(Essaim(1,:));

if length(Domaine(1,:)==3)
    for i=1:length(Domaine(:,3))
        if Domaine(i,3)~=0
            Ecart=mod(Essaim(i,:),Domaine(i,3));
            Essaim(i,:)=Essaim(i,:)-Ecart+Domaine(i,3)*ones(1,N_particules).*(Ecart/Domaine(i,3)>rand(1,N_particules));
        end
    end
end

Essaim = max(repmat(Domaine(:,1),1,N_particules),Essaim);
Essaim = min(repmat(Domaine(:,2),1,N_particules),Essaim);


            
            
    
