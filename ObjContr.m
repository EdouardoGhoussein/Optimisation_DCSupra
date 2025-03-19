function [Objectifs, Contraintes,Divers]= ObjContr(Essaim)
 [l,c]= size(Essaim);
 %disp(l);
 %disp(c);
Objectifs=zeros(2,c);
Contraintes=-ones(2,c);
Divers=zeros(100,100);



for index  = 1:c
    %Ps_ref=Essaim(1,index);
    disp(Essaim(index))
    nt=Essaim(1,index);
    %disp(Essaim);
    %disp(nt);
    assignin('base','nt',nt);
    
    try
    [time,Vcpl,Icpl,Vsc,Isc]=fct_run_model("DC_grid_SCPF");
    catch
        Contraintes(1,index)=1;
        Objectifs(1,index)=5e9;
        continue
    end
    P = Vsc.*Isc;
    P_ref= Vcpl.* Icpl;
    

    Psc=max(P(time > 4));
    Ps_ref=max(P_ref(time > 4));
    disp(P +" "+nt);
    assignin('base','Psc',Psc);
    Contraintes(1,index)=fct_stable(time,Vcpl);
    Objectifs(1,index)=-Psc;
    %disp(Ps_ref+ ": "+Contraintes(1,index));

    Objectifs(2,index)=-Psc;
    
    
    
    
end

end
    
