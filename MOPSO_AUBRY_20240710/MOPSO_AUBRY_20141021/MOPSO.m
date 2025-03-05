%MOPSO : Algorithme d'optimisation multiobjectif par essaims particulaires
%   [Front_Pareto,Front_Pareto_Objectifs]=MOPSO(options)
%
%ARGUMENT
%
%   options : Structure matlab comprenant tous les paramètres dont
%   l'algorithme a besoins
%   EXEMPLE
%   options = struct( ...
%     ...%Paramètres de l'algorithme
%     'AlgParams', struct(...    
%     ...     %Nombre de particules
%     'N_particules',     20,...
%     ...     %Nombre d'itérations
%     'N_iterations',     2000,...
%     ...     %Nombre de paramètres d'optimisation
%     'N_variables',      length(Domaine(:,1)), ...
%     ...     %Nombre de particules optimales au sens de Pareto conservées en mémoire
%     'N_archive',        20),...
%     ...%Paramètres de strategie
%     'StraParams', struct(...
%     ...     %Acceleration cognitive : tendance à suivre sa meilleure position en mémoire
%     'Accel_memoire',    1.4, ...
%     ...     %Acceleration sociale : tendance à suivre la meilleure position du groupe
%     'Accel_guide',      1.4, ... 
%     ...     %Inertie : tendance à suivre son élan
%     'Inertie_debut',    0.8, ...   %Valeur au debut de l'algorithme
%     'Inertie_fin',      0.8, ...    %Valeur à la fin de l'algorithme
%     ...     %Proportion de particules mutées à chaque itération
%     'Proba_mut',        0.01, ...
%     ...     %Facteur de constriction : Il réduit à chaque itération l'ensemble de ces paramètres de stratégie jusqu'à Fact_constrict fois leurs valeurs initiales
%     ...     %Il permet, une fois le front atteint, de mieux le définir localement (avoir un front plus lisse)
%     'Fact_constrict',   .1), ...
%     ...%Fonction objectif
%     'Objectif', struct(...
%     ...     %Handle Matlab de la fonction objectif
%     'fonction',         fonction, ...
%     ...     %Espace de recherches des paramètres d'optimisation
%     'Domaine',          Domaine), ...
%     ...%Paramètres de sauvegarde
%     'Sauvegarde', struct(...
%     ...     %true, on sauvegarde, false, on sauvegarde pas
%     'Etat',             true,...
%     ...     %Nom du fichier dans lequel on sauvegarde les données
%     'Fichier',          'Resultat_MOPSO_voiture'),... 
%     ...%Parametres d'initialisation
%     'Initialisation', struct(...
%     ...     %true, on charge, false, on charge pas
%     'Etat',             false,...
%     ...     %Nom du fichier que l'on va charger
%     ...     %Le fichier chargé ne peut être qu'un fichier de sauvegarde d'une optimisation avec le même nombre de particules
%     ...     %Utile lorsque l'optimisation a planté, car la sauvegarde est réactualisé à chaque itération
%     'Fichier',          'Resultat_MOPSO_voiture'),...  %Nom du fichier que l'on va charger
%     ...  %Parametres d'affichage
%     'Affichage', struct(...
%     ...     %On affiche ou pas, les résultats à chaque itération
%     'Etat',             true)...
%     );
%
%DONNEES DE RETOUR
%
%   Front_Pareto_Parametres
%       Vecteur de taille N_variables*N_archive
%       contient N_archives particules optimales, respectant les
%       contraintes et triés selon le premier objectif
%   Front_Pareto_Objectifs
%       Contient les valeurs des objectifs associées aux particules
%       contenues dans Front_Pareto_Parametres
%

function [Front_Pareto_Parametres,Front_Pareto_Objectifs]=MOPSO(options)

%Initialisation du generateur aleatoire
rand('state',sum(100*clock));

%Definition des paramï¿½tres de l'algorithme
N_variables=options.AlgParams.N_variables;
N_particules=options.AlgParams.N_particules;
N_iterations=options.AlgParams.N_iterations;
N_archive=options.AlgParams.N_archive;

set(0,'RecursionLimit',100)

%Definition des paramï¿½tres de la fonction objectif
fonction = options.Objectif.fonction;
Domaine = options.Objectif.Domaine;

%Definition des paramï¿½tres de sauvegarde
Etat_Sauve = options.Sauvegarde.Etat;
Fichier_Sauve = options.Sauvegarde.Fichier;

%Definition des paramï¿½tres d'initialisation
Etat_Init = options.Initialisation.Etat;
Fichier_Init = options.Initialisation.Fichier;

%Definition des paramï¿½tres de stratï¿½gie
Inertie_debut = options.StraParams.Inertie_debut;
Inertie_fin = options.StraParams.Inertie_fin;
Accel_memoire = options.StraParams.Accel_memoire;
Accel_guide = options.StraParams.Accel_guide;
Proba_mut = options.StraParams.Proba_mut;
Fact_constrict = options.StraParams.Fact_constrict;

if Etat_Init==1
    load(Fichier_Init,'Essaim','Objectifs','Contraintes','Divers',...
        'Memoires_Parametres','Memoires_Objectifs','Memoires_Contraintes',...
        'Front_Pareto_Parametres','Front_Pareto_Objectifs','Front_Pareto_Contraintes','Front_Pareto_Divers','Distance','Vitesses','Somme_Viols_Memoires');
elseif Etat_Init==2
    load(Fichier_Init,'Front_Pareto_Parametres','Front_Pareto_Objectifs','Front_Pareto_Contraintes','Front_Pareto_Divers');
    %Generation du premier essaim
    Essaim = repmat(Domaine(:,1),1,N_particules)+repmat(Domaine(:,2)-Domaine(:,1),1,N_particules).*rand(N_variables,N_particules);
    %Effet quantique pour les variables discretes
    Essaim = forcer_domaine(Essaim,Domaine);
    %Initialisation des vitesses
    Vitesses = repmat(Domaine(:,1),1,N_particules)+repmat(Domaine(:,2)-Domaine(:,1),1,N_particules).*rand(N_variables,N_particules);
    %Evaluation de l'essaim
    [Objectifs,Contraintes,Divers] = feval(fonction,Essaim);
    %Initialisation des mï¿½moires individuelles
    Memoires_Parametres = Essaim;
    Memoires_Objectifs = Objectifs;
    Memoires_Contraintes = Contraintes;
    [Memoires_Parametres,Memoires_Objectifs,Memoires_Contraintes,Somme_Viols_Memoires] ...
        = MAJ_Memoires(Essaim,Objectifs,Contraintes,Memoires_Parametres,Memoires_Objectifs,Memoires_Contraintes);
    %Mise a jour du front de Pareto
    if length(Objectifs(:,1))==2
        [Front_Pareto_Parametres,Front_Pareto_Objectifs,Front_Pareto_Contraintes,Front_Pareto_Divers] ...
            = extraire_front([Essaim Front_Pareto_Parametres],[Objectifs Front_Pareto_Objectifs],[Contraintes Front_Pareto_Contraintes],[Divers Front_Pareto_Divers]);
    elseif length(Objectifs(:,1))==3
        [Front_Pareto_Parametres,Front_Pareto_Objectifs,Front_Pareto_Contraintes,Front_Pareto_Divers] ...
            = extraire_front_3obj([Essaim Front_Pareto_Parametres],[Objectifs Front_Pareto_Objectifs],[Contraintes Front_Pareto_Contraintes],[Divers Front_Pareto_Divers]);
    else
        disp('error')
        return
    end
    %Ajustement de l'archive
    [Front_Pareto_Parametres,Front_Pareto_Objectifs,Front_Pareto_Contraintes,Front_Pareto_Divers,Distance] ...
        = ajuster_archive(Front_Pareto_Parametres,Front_Pareto_Objectifs,Front_Pareto_Contraintes,Front_Pareto_Divers,N_archive);
elseif Etat_Init==3
    load(Fichier_Init,'Essaim');
    %Effet quantique pour les variables discretes
    Essaim = forcer_domaine(Essaim,Domaine);
    %Initialisation des vitesses
    Vitesses = repmat(Domaine(:,1),1,N_particules)+repmat(Domaine(:,2)-Domaine(:,1),1,N_particules).*rand(N_variables,N_particules);
    %Evaluation de l'essaim
    [Objectifs,Contraintes,Divers] = feval(fonction,Essaim);
    %Initialisation des memoires individuelles
    Memoires_Parametres = Essaim;
    Memoires_Objectifs = Objectifs;
    Memoires_Contraintes = Contraintes;
    [Memoires_Parametres,Memoires_Objectifs,Memoires_Contraintes,Somme_Viols_Memoires] ...
        = MAJ_Memoires(Essaim,Objectifs,Contraintes,Memoires_Parametres,Memoires_Objectifs,Memoires_Contraintes);
    %Mise ï¿½ jour du front de Pareto
    if length(Objectifs(:,1))==2
        [Front_Pareto_Parametres,Front_Pareto_Objectifs,Front_Pareto_Contraintes,Front_Pareto_Divers] ...
            = extraire_front([Essaim ],[Objectifs ],[Contraintes ],[Divers ]);
    elseif length(Objectifs(:,1))==3
        [Front_Pareto_Parametres,Front_Pareto_Objectifs,Front_Pareto_Contraintes,Front_Pareto_Divers] ...
            = extraire_front_3obj([Essaim ],[Objectifs ],[Contraintes ],[Divers ]);
    else
        disp('error')
        return
    end
    %Ajustement de l'archive
    [Front_Pareto_Parametres,Front_Pareto_Objectifs,Front_Pareto_Contraintes,Front_Pareto_Divers,Distance] ...
        = ajuster_archive(Front_Pareto_Parametres,Front_Pareto_Objectifs,Front_Pareto_Contraintes,Front_Pareto_Divers,N_archive);
else
    %Generation du premier essaim
    Essaim = repmat(Domaine(:,1),1,N_particules)+repmat(Domaine(:,2)-Domaine(:,1),1,N_particules).*rand(N_variables,N_particules);
    %Effet quantique pour les variables discretes
    Essaim = forcer_domaine(Essaim,Domaine);
    %Initialisation des vitesses
    Vitesses = repmat(Domaine(:,1),1,N_particules)+repmat(Domaine(:,2)-Domaine(:,1),1,N_particules).*rand(N_variables,N_particules);
    Vitesses(:)=0;
    %Evaluation de l'essaim
    [Objectifs,Contraintes,Divers] = feval(fonction,Essaim);
    %Initialisation des memoires individuelles
    Memoires_Parametres = Essaim;
    Memoires_Objectifs = Objectifs;
    Memoires_Contraintes = Contraintes;
    [Memoires_Parametres,Memoires_Objectifs,Memoires_Contraintes,Somme_Viols_Memoires] ...
        = MAJ_Memoires(Essaim,Objectifs,Contraintes,Memoires_Parametres,Memoires_Objectifs,Memoires_Contraintes);
    %Initialiation de l'archive
    if length(Objectifs(:,1))==2
        [Front_Pareto_Parametres,Front_Pareto_Objectifs,Front_Pareto_Contraintes,Front_Pareto_Divers] ...
            = extraire_front(Essaim,Objectifs,Contraintes,Divers);
    elseif length(Objectifs(:,1))==3
        [Front_Pareto_Parametres,Front_Pareto_Objectifs,Front_Pareto_Contraintes,Front_Pareto_Divers] ...
            = extraire_front_3obj(Essaim,Objectifs,Contraintes,Divers);
    else
        disp('error')
        return
    end
    %Ajustement de l'archive
    [Front_Pareto_Parametres,Front_Pareto_Objectifs,Front_Pareto_Contraintes,Front_Pareto_Divers,Distance] ...
        = ajuster_archive(Front_Pareto_Parametres,Front_Pareto_Objectifs,Front_Pareto_Contraintes,Front_Pareto_Divers,N_archive);
end
Mut=false(1,N_particules);
Guides=ones(1,N_particules);
%A executer pendant N_itï¿½rations
cycle=1;
cycle_temp=1;

while (cycle <= N_iterations && cycle_temp <= 100 )   
    %Choix d'un guide pour chaque particule
    Guides = choisir_guides(N_particules,Objectifs,Front_Pareto_Objectifs,Somme_Viols_Memoires,Guides,Mut);
    %Determination de la vitesse de chaque particules
    %Vitesse individuelle
    U1=Accel_memoire*rand(N_variables,N_particules);
    Vitesse_individuelle = U1.*(Memoires_Parametres-Essaim);
    %Acceleration sociale
    if isempty(Front_Pareto_Parametres)
        U2=Accel_guide*rand(N_variables,N_particules);
        Vitesse_sociale = U2.*(Memoires_Parametres(:,Guides)-Essaim);
    else
        U2=Accel_guide*rand(N_variables,N_particules);
        Vitesse_sociale = U2.*(Front_Pareto_Parametres(:,Guides)-Essaim);
    end
    %Acceleration inertielle
    Vitesse_inertielle=(Inertie_debut+(Inertie_fin-Inertie_debut)*cycle/N_iterations)*Vitesses;
    %Calcul de la vitesse globale
    Vitesses=Vitesse_inertielle+Vitesse_individuelle+Vitesse_sociale;
    %Constriction de la vitesse
    Vitesses=(1-(1-Fact_constrict)*cycle/N_iterations)*Vitesses;
    
    %Rajouter une perturbation
    Mut=false(1,N_particules);
    if cycle <= 2/3*N_iterations
        parfor i=1:N_particules
            Indice=find(all(repmat(Essaim(:,i),1,size(Front_Pareto_Parametres,2))==Front_Pareto_Parametres));
            if Indice
                Mut(i)=true;
            end
        end
    else
        Mut = rand(1,N_particules);
        Mut = Mut<(1-(1-Fact_constrict)*cycle/N_iterations)*Proba_mut;
    end

    Perturbation = 4*diag(Domaine(:,2)-Domaine(:,1),0)*randn(N_variables,N_particules);
    Essaim(:,Mut)=Essaim(:,Mut)+Perturbation(:,Mut);
    Vitesses(:,Mut)=zeros(N_variables,sum(Mut));
    %Generer nouvel essaim
    Essaim = Essaim + Vitesses; 
    

    
    %Forcer les particules ï¿½ rester dans les domaines de variation
    [Essaim] = forcer_domaine(Essaim,Domaine);
    %Evaluation de l'essaim
    [Objectifs,Contraintes,Divers] = feval(fonction,Essaim);
    %Mise a jour des memoires individuelles
    [Memoires_Parametres,Memoires_Objectifs,Memoires_Contraintes,Somme_Viols_Memoires] ...
        = MAJ_Memoires(Essaim,Objectifs,Contraintes,Memoires_Parametres,Memoires_Objectifs,Memoires_Contraintes);
    %Mise a jour du front de Pareto
    if length(Objectifs(:,1))==2
        [Front_Pareto_Parametres,Front_Pareto_Objectifs,Front_Pareto_Contraintes,Front_Pareto_Divers] ...
            = extraire_front([Essaim Front_Pareto_Parametres],[Objectifs Front_Pareto_Objectifs],[Contraintes Front_Pareto_Contraintes],[Divers Front_Pareto_Divers]);
    elseif length(Objectifs(:,1))==3
        [Front_Pareto_Parametres,Front_Pareto_Objectifs,Front_Pareto_Contraintes,Front_Pareto_Divers] ...
            = extraire_front_3obj([Essaim Front_Pareto_Parametres],[Objectifs Front_Pareto_Objectifs],[Contraintes Front_Pareto_Contraintes],[Divers Front_Pareto_Divers]);
    else
        disp('error')
        return
    end
    %Ajustement de l'archive
    [Front_Pareto_Parametres,Front_Pareto_Objectifs,Front_Pareto_Contraintes,Front_Pareto_Divers,Distance]...
        =ajuster_archive(Front_Pareto_Parametres,Front_Pareto_Objectifs,Front_Pareto_Contraintes,Front_Pareto_Divers,N_archive);
    
    %Determination des coordonnées des points extrêmes du Front de Pareto
    if isempty(Front_Pareto_Objectifs)
            Extremes(:,cycle)=NaN(length(Objectifs(:,1)),1);
        else
            Extremes(:,cycle)=min(Front_Pareto_Objectifs,[],2);
    end
    Taille_archive(cycle)=length(Front_Pareto_Parametres(1,:));
    %Sauvegarde de la generation
    if Etat_Sauve
        save(Fichier_Sauve,'options','Domaine',...
            'Essaim','Objectifs','Contraintes','Divers','Vitesses',...
            'Memoires_Parametres','Memoires_Objectifs','Memoires_Contraintes',...
            'Front_Pareto_Parametres','Front_Pareto_Objectifs','Front_Pareto_Contraintes','Front_Pareto_Divers',...
            'Distance','Extremes','Somme_Viols_Memoires','Taille_archive');
    end
    
    fprintf( 'generation %d ', cycle);
    fprintf(' Taille Archive %d \n', length(Front_Pareto_Parametres(1,:)) );
    
    %Affichage des résultats dans l'espace des objectifs
    if options.Affichage.Etat && mod(cycle,10)==1
        
        subplot(2,2,1),
        plot(Objectifs(1,:),Objectifs(2,:),'x'); hold on
        plot(Memoires_Objectifs(1,:),Memoires_Objectifs(2,:),'og');
        plot(Front_Pareto_Objectifs(1,:),Front_Pareto_Objectifs(2,:),'or');
        hold off
%         if length(Front_Pareto_Parametres(1,:))==1
%         Vue = [min(Front_Pareto_Objectifs(1,:)) max(Front_Pareto_Objectifs(1,:)),
%             min(Front_Pareto_Objectifs(2,:)) max(Front_Pareto_Objectifs(2,:))];
%         Vue = (Vue(:,2)-Vue(:,1))*[-0.1 0.1]+Vue+[-0.01 0.01;-0.01 0.01] ;
%         axis([Vue(1,:) Vue(2,:)]);
%         end
%         if length(Front_Pareto_Parametres(1,:))>1
%         Vue = [min(Front_Pareto_Objectifs(1,:)) max(Front_Pareto_Objectifs(1,:)),
%             min(Front_Pareto_Objectifs(2,:)) max(Front_Pareto_Objectifs(2,:))];
%         Vue = (Vue(:,2)-Vue(:,1))*[-0.1 0.1]+Vue+[-0.01 0.01;-0.01 0.01];
%         axis([Vue(1,:) Vue(2,:)]);
%         end
        %xlim([-3e5 0])
        %ylim([0 1e6])
        grid
        pause(.0001*(N_particules))
        
        subplot(2,2,2)
        plot(Taille_archive);
        
        subplot(2,2,3) %plot variable 8
        plot(Objectifs(1,:),Essaim(8,:),'x'); hold on
        plot(Memoires_Objectifs(1,:),Memoires_Parametres(8,:),'og');
        plot(Front_Pareto_Objectifs(1,:),Front_Pareto_Parametres(8,:),'or');
        hold off
        %xlim([-3e5 0])
        %ylim([0 10])
        grid
        pause(.0001*(N_particules))
        
        subplot(2,2,4) %plot variable 3
        plot(Objectifs(1,:),Essaim(3,:),'x'); hold on
        plot(Memoires_Objectifs(1,:),Memoires_Parametres(3,:),'og');
        plot(Front_Pareto_Objectifs(1,:),Front_Pareto_Parametres(3,:),'or');
        hold off
        %xlim([-3e5 0])
        %ylim([0 800])
        grid
        pause(.0001*(N_particules))
        

        %pause
        %axis square
%                 
%         %axes('Fontsize',16)
%         title(strcat('Pareto front iteration=',num2str(cycle)),'Fontsize',16)
%         xlabel('Mean electrical power (W)','Fontsize',16)
%         ylabel('Electrical chain cost (euro)','Fontsize',16)
%         axis([-2.42e5 -2.3e5 0 10e5]);
%         set(gcf,'Position',[100 100 1500 1000])
%         F(cycle_temp+cycle-1) = getframe(gcf);
%         pause(0.03)
%         close(gcf)
    end
    
%     if options.Affichage.Etat
%         plot3(Objectifs(1,:),Objectifs(2,:),Objectifs(3,:),'x');
%         hold on
%         plot3(Memoires_Objectifs(1,:),Memoires_Objectifs(2,:),Memoires_Objectifs(3,:),'og');
%         hold on
%         plot3(Front_Pareto_Objectifs(1,:),Front_Pareto_Objectifs(2,:),Front_Pareto_Objectifs(3,:),'or');
%         hold off
%         %         if length(Front_Pareto_Parametres(1,:))==1
%         %         Vue = [min(Front_Pareto_Objectifs(1,:)) max(Front_Pareto_Objectifs(1,:)),
%         %             min(Front_Pareto_Objectifs(2,:)) max(Front_Pareto_Objectifs(2,:))];
%         %         Vue = (Vue(:,2)-Vue(:,1))*[-0.1 0.1]+Vue+[-0.01 0.01;-0.01 0.01] ;
%         %         axis([Vue(1,:) Vue(2,:)]);
%         %         end
%         if length(Front_Pareto_Parametres(1,:))>1
%             Vue = [min(Front_Pareto_Objectifs(1,:)) max(Front_Pareto_Objectifs(1,:));
%                 min(Front_Pareto_Objectifs(2,:)) max(Front_Pareto_Objectifs(2,:));
%                 min(Front_Pareto_Objectifs(3,:)) max(Front_Pareto_Objectifs(3,:))];
%             %Vue = (Vue(:,2)-Vue(:,1))*[-0.1 0.1]+Vue+[-0.01 0.01;-0.01 0.01];
%             axis([Vue(1,:) Vue(2,:) Vue(3,:)]);
%             
%         end
%         pause(.0001*(N_particules))
%         %pause
%     end
    
        %Affichage des résultats dans l'espace des paramètres
%     if options.Affichage.Etat
%         subplot(3,4,1)
%         plot(Objectifs(1,:),Objectifs(2,:),'x');
%         hold on
%         plot(Memoires_Objectifs(1,:),Memoires_Objectifs(2,:),'og');
%         hold on
%         plot(Front_Pareto_Objectifs(1,:),Front_Pareto_Objectifs(2,:),'or');
%         hold off
%         if length(Front_Pareto_Parametres(1,:))==1
%         Vue = [min(Front_Pareto_Objectifs(1,:)) max(Front_Pareto_Objectifs(1,:)),
%             min(Front_Pareto_Objectifs(2,:)) max(Front_Pareto_Objectifs(2,:))];
%         Vue = (Vue(:,1))*[-0.1 0.1]+Vue;
%         axis([Vue(1,:) Vue(2,:)]);
%         end
%         if length(Front_Pareto_Parametres(1,:))>1
%         Vue = [min(Front_Pareto_Objectifs(1,:)) max(Front_Pareto_Objectifs(1,:)),
%             min(Front_Pareto_Objectifs(2,:)) max(Front_Pareto_Objectifs(2,:))];
%         Vue = (Vue(:,2)-Vue(:,1))*[-0.1 0.1]+Vue+[-0.01 0.01;-0.01 0.01] ;
%         axis([Vue(1,:) Vue(2,:)]);
%         end
%         for i=1:11
%             subplot(3,4,i+1)
%             plot(Objectifs(1,:),Essaim(i,:),'x');
%             hold on
%             plot(Memoires_Objectifs(1,:),Memoires_Parametres(i,:),'og');
%             hold on
%             plot(Front_Pareto_Objectifs(1,:),Front_Pareto_Parametres(i,:),'or');
%             hold off
% %             if length(Front_Pareto_Parametres(1,:))==1
% %                 Vue = [min(Front_Pareto_Objectifs(1,:)) max(Front_Pareto_Objectifs(1,:)),
% %                     min(Front_Pareto_Parametres(i,:)) max(Front_Pareto_Parametres(i,:))];
% %                 Vue = (Vue(:,1))*[-0.1 0.1]+Vue;
% %                 axis([Vue(1,:) Vue(2,:)]);
% %             end
%         end
%       end
%        pause(.05)
    
    if ~isempty(Front_Pareto_Objectifs)
        cycle = cycle+1;
    end
    if isempty(Front_Pareto_Objectifs)
        cycle_temp = cycle_temp+1;
    end
end
%movie2avi(F,'pareto','compression','None','FPS',5);

