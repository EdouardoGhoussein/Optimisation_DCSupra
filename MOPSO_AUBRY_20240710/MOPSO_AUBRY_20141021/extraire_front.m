%extraire_front: Extrat les particules non dominées d'une population
%[Front_Pareto,Front_Pareto_Objectifs,Front_Pareto_Contraintes,Front_Pareto_Divers] ...
%    = extraire_front(Essaim,Objectifs,Contraintes,Divers)
%
%ARGUMENTS
%   Essaim
%       Vecteur de taille N_variables*N_particules
%       contient les paramètres de N_particules (population)
%       Vecteur de taille N_objectifs*N_particules
%       contient les valeurs des objectifs de Essaim
%   Objectifs
%       Vecteur de taille N_objectifs*N_particules
%       contient les valeurs des objectifs de Essaim
%   Contraintes
%       Vecteur de taille N_contraintes*N_particules
%       contient les valeurs des contraintes de Essaim
%   Divers
%       Vecteur de taille N_divers*N_particules
%       contient les valeurs de données relatives à chaque particule mais
%       non utile à l'algorithme (pratique pour conserver des données de
%       calcul intermédiaires)
%
%DONNEES DE RETOUR
%
%   Front_Pareto_Parametres
%   Front_Pareto_Objectifs
%   Front_Pareto_Contraintes
%   Front_Pareto_Divers


function [Front_Pareto_Parametres,Front_Pareto_Objectifs,Front_Pareto_Contraintes,Front_Pareto_Divers] ...
    = extraire_front(Essaim,Objectifs,Contraintes,Divers)


%Enlever les particules violant au moins une contrainte
Somme = sum(max(Contraintes,0),1);
indices = find(Somme>0);
Essaim(:,indices)=[];
Objectifs(:,indices)=[];
Contraintes(:,indices)=[];
Divers(:,indices)=[];

%Trier les particules en ordre croissant par rapport à l'objectif 1
[poubelle,Indices] = sort(Objectifs(1,:),'ascend');
Essaim = Essaim(:,Indices);
Objectifs = Objectifs(:,Indices);
Contraintes = Contraintes(:,Indices);
Divers = Divers(:,Indices);

N=length(Essaim(1,:));

% Si tous les individus violent les contraintes alors renvoyer des vecteurs
% vides
if N==0
    Front_Pareto_Parametres = Essaim;
    Front_Pareto_Objectifs = Objectifs;
    Front_Pareto_Contraintes = Contraintes;
    Front_Pareto_Divers = Divers;
    return
end

% %Trouver les particules non dominï¿½es
% Front_Pareto_Parametres = Essaim;
% Front_Pareto_Objectifs = Objectifs;
% Front_Pareto_Contraintes = Contraintes;
% Front_Pareto_Divers = Divers;
% 
% j=1;
% while j<=length(Front_Pareto_Objectifs(1,:))
%     %Trouver les particules dominï¿½es au sens large par la particule j
%     condition = Front_Pareto_Objectifs(1,:) >= Front_Pareto_Objectifs(1,j) ...
%         & Front_Pareto_Objectifs(2,:) >= Front_Pareto_Objectifs(2,j);
%     indices = find(condition);
%     indices(indices==j)=[];
%     %Supprimer ces particules dominï¿½es
%     Front_Pareto_Parametres(:,indices)=[];
%     Front_Pareto_Objectifs(:,indices)=[];
%     Front_Pareto_Contraintes(:,indices)=[];
%     Front_Pareto_Divers(:,indices)=[];
%     %Si aucune particule d'indice infï¿½rieure ï¿½ j n'a ï¿½tï¿½ supprimï¿½e ->
%     %incrï¿½menter j
%     %Sinon donner ï¿½ j l'indice le plus faible des particules supprimï¿½es
%     if isempty(find(indices<j,1))
%         j=j+1;
%     else
%         j=min(indices);
%     end
% end
% 

% New_solutions=1;
% k=1;
% while k<length(Objectifs(1,:))-1
%     Coefs_dir=(Objectifs(2,k+1:end)-Objectifs(2,k))...
%         ./(Objectifs(1,k+1:end)-Objectifs(1,k));
%     
%     [foo,indice]=min(Coefs_dir);
%     if foo>0
%         break;
%     end
%     New_solutions=[New_solutions k+indice];
%     k=k+indice;
% end
% Front_Pareto_Parametres = Essaim(:,New_solutions);
% Front_Pareto_Objectifs = Objectifs(:,New_solutions);
% Front_Pareto_Contraintes = Contraintes(:,New_solutions);
% Front_Pareto_Divers = Divers(:,New_solutions);

% Appeller la fonction de Tri
[Front_Pareto_Parametres,Front_Pareto_Objectifs,Front_Pareto_Contraintes,Front_Pareto_Divers] ...
    = sous_fonction_recursive(Essaim,Objectifs,Contraintes,Divers);

return


function [Front_Pareto_Parametres,Front_Pareto_Objectifs,Front_Pareto_Contraintes,Front_Pareto_Divers] ...
    = sous_fonction_recursive(Essaim,Objectifs,Contraintes,Divers)

%condition d'arrêt : Si l'appel ce la fonction se fait avec une population
%de taille 1, alors renvoyer cette particule

N=length(Essaim(1,:));
if N==1
    Front_Pareto_Parametres = Essaim;
    Front_Pareto_Objectifs = Objectifs;
    Front_Pareto_Contraintes = Contraintes;
    Front_Pareto_Divers = Divers;
    return
end

% Sinon appeller cette fonction sur deux moitiés de la population
[Partie_haute,Partie_haute_Objectifs,Partie_haute_Contraintes,Partie_haute_Divers] ...
    =sous_fonction_recursive(Essaim(:,1:floor(N/2)),Objectifs(:,1:floor(N/2)),Contraintes(:,1:floor(N/2)),Divers(:,1:floor(N/2)));
[Partie_basse,Partie_basse_Objectifs,Partie_basse_Contraintes,Partie_basse_Divers] ...
    =sous_fonction_recursive(Essaim(:,floor(N/2)+1:end),Objectifs(:,floor(N/2)+1:end),Contraintes(:,floor(N/2)+1:end),Divers(:,floor(N/2)+1:end));

% Rassembler les deux fronts de Pareto resultants
Test = Partie_basse_Objectifs(2,:) < Partie_haute_Objectifs(2,end);
Indice = find(Test,1);

Test2=0;
if ~isempty(Indice)
    Test2 = Partie_basse_Objectifs(1,Indice) == Partie_haute_Objectifs(1,end);
end

Front_Pareto_Parametres=[Partie_haute(:,1:end-1*Test2) Partie_basse(:,Indice:end)];
Front_Pareto_Objectifs=[Partie_haute_Objectifs(:,1:end-1*Test2) Partie_basse_Objectifs(:,Indice:end)];
Front_Pareto_Contraintes=[Partie_haute_Contraintes(:,1:end-1*Test2) Partie_basse_Contraintes(:,Indice:end)];
Front_Pareto_Divers=[Partie_haute_Divers(:,1:end-1*Test2) Partie_basse_Divers(:,Indice:end)];
return




    

