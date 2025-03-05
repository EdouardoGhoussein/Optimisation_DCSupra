function [Front_Pareto_Parametres,Front_Pareto_Objectifs,Front_Pareto_Contraintes,Front_Pareto_Divers,Distance]...
    =ajuster_archive(Front_Pareto_Parametres,Front_Pareto_Objectifs,Front_Pareto_Contraintes,Front_Pareto_Divers,N_archive)

[poubelle,Indices] = sort(Front_Pareto_Objectifs(1,:),'ascend');
Front_Pareto_Parametres = Front_Pareto_Parametres(:,Indices);
Front_Pareto_Objectifs=Front_Pareto_Objectifs(:,Indices);
Front_Pareto_Contraintes=Front_Pareto_Contraintes(:,Indices);
Front_Pareto_Divers=Front_Pareto_Divers(:,Indices);

if isempty(Indices)
    Distance = [];
    return
elseif length(Indices)==1
    Distance = 1;
elseif length(Indices)==2
    Distance = [1 1];
else
    Nadir=max(Front_Pareto_Objectifs,[],2)';
    Ecart(1,:)=Nadir(1)-Front_Pareto_Objectifs(1,:);
    Ecart(1,:)=Ecart(1,:)/max(Ecart(1,:));
    Ecart(2,:)=Nadir(2)-Front_Pareto_Objectifs(2,:);
    Ecart(2,:)=Ecart(2,:)/max(Ecart(2,:));
    Angle=atan(Ecart(2,:)./Ecart(1,:))*180/pi;
    Angle=repmat(Angle,N_archive,1);
    Angle_souhaite=linspace(0,90,N_archive);
    Angle_souhaite=repmat(Angle_souhaite',1,length(Angle(1,:)));
    Distance=abs(Angle_souhaite-Angle);
    [Minimums,Indices]=min(Distance,[],2);
end

Indices=unique(Indices);

Front_Pareto_Parametres = Front_Pareto_Parametres(:,Indices);
Front_Pareto_Objectifs=Front_Pareto_Objectifs(:,Indices);
Front_Pareto_Contraintes=Front_Pareto_Contraintes(:,Indices);
Front_Pareto_Divers=Front_Pareto_Divers(:,Indices);
Distance = Distance(:,Indices);