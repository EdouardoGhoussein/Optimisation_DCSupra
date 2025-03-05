%choisir_guides: Décide le guide pour chaque particule
%(accélération sociale)
%Guides = choisir_guides(N_particules,Front_Pareto,Distance,Somme_Viols_Memoires)
%
%ARGUMENTS
%   N_particules
%       Nombre de particules dans l'essaim
%   Front_Pareto_Parametres
%       Particules optimales archivées
%   Somme_Viols_Mémoires
%       Contient une somme pondérés des contraintes associées aux mémoires
%       individuelles
%
%DONNEES DE RETOUR
%
%   Guides
%       Vecteur de taille N_Particules
%       Contient les indices de chaque particules à suivre
%       Les guides sont dans Front_Pareto_Parametres

function Guides = choisir_guides(N_particules,Objectifs,Front_Pareto_Objectifs,Somme_Viols_Memoires,Guides,Mut)

if isempty(Front_Pareto_Objectifs(1,:))
    %Si aucun individu ne respectent les contraintes, on choisit de suivre
    %celui qui minimise la somme normalisée des contraintes.
    [toto,indice]=min(Somme_Viols_Memoires);
    Guides=indice*ones(1,N_particules);
    return
end

if length(Front_Pareto_Objectifs(1,:))==1
    Guides=ones(1,N_particules);
    return
end

% Nadir=max(Front_Pareto_Objectifs,[],2)';
% 
% Ecart(1,:)=Nadir(1)-Front_Pareto_Objectifs(1,:);
% Ecart(1,:)=Ecart(1,:)/max(Ecart(1,:));
% Ecart(2,:)=Nadir(2)-Front_Pareto_Objectifs(2,:);
% Ecart(2,:)=Ecart(2,:)/max(Ecart(2,:));
% Angle_Pareto=atan(Ecart(2,:)./Ecart(1,:))*180/pi;
% 
% clear Ecart
% Ecart(1,:)=Nadir(1)-Objectifs(1,:);
% Ecart(1,:)=Ecart(1,:)/max(Ecart(1,:));
% Ecart(2,:)=Nadir(2)-Objectifs(2,:);
% Ecart(2,:)=Ecart(2,:)/max(Ecart(2,:));
% Angle_Essaim=atan(Ecart(2,:)./Ecart(1,:))*180/pi;
% 
% Angle_Essaim=repmat(Angle_Essaim',1,length(Angle_Pareto));
% Angle_Pareto=repmat(Angle_Pareto,length(Angle_Essaim),1);
% Distance=abs(Angle_Essaim-Angle_Pareto);
% [foo,Guides]=min(Distance,[],2);

% Nadir=max(Front_Pareto_Objectifs,[],2)';
% Ecart(1,:)=Nadir(1)-Front_Pareto_Objectifs(1,:);
% Ecart(1,:)=Ecart(1,:)/max(Ecart(1,:));
% Ecart(2,:)=Nadir(2)-Front_Pareto_Objectifs(2,:);
% Ecart(2,:)=Ecart(2,:)/max(Ecart(2,:));
% Angle=atan(Ecart(2,:)./Ecart(1,:))*180/pi;
% 
% Angle=repmat(Angle',1,N_particules);
% Angle_souhait=linspace(0,90,N_particules);
% Angle_souhait=repmat(Angle_souhait,length(Ecart(1,:)),1);
% Distance=abs(Angle_souhait-Angle);
% [foo,Guides]=min(Distance,[],1);
% 
Guides=round(linspace(1,length(Front_Pareto_Objectifs(1,:)),N_particules));

% Guides=randi([1,length(Front_Pareto_Objectifs(1,:))],1,N_particules);
% Test=Guides>length(Front_Pareto_Objectifs(1,:));
% Guides(Test)=randi([1,length(Front_Pareto_Objectifs(1,:))],1,sum(Test));
% Guides(Mut)=randi([1,length(Front_Pareto_Objectifs(1,:))],1,sum(Mut));
