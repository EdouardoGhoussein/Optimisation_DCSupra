function [Objectifs, Contraintes,Divers]= ObjContr(Essaim)
 [l,c]= size(Essaim);
Objectifs=zeros(2,c);
Contraintes=-ones(2,c);
Divers=zeros(100,100);



for index  = 1:l 
    %Ps_ref=Essaim(1,index);
    nt=Essaim(1,index);
    assignin('base','nt',nt);
    
    try
    [time,Vcpl,~,Vsc,Isc]=fct_run_model("DC_grid_SCPF");
    catch
        Contraintes(1,index)=1;
        Objectifs(1,index)=-5e9;
        continue
    end
    P = Vsc.*Isc;
    disp(P +" "+nt);

    Psc=max(P(time > 4));
    assignin('base','Psc',Psc);
    Contraintes(1,index)=fct_stable(time,Vcpl);
    Objectifs(1,index)=-Psc;
    %disp(Ps_ref+ ": "+Contraintes(1,index));

    Objectifs(2,index)=-Psc;
    
    
    
    
end

end
    
