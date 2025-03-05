function [Objectifs, Contraintes,Divers]= ObjContr(Essaim)
 [l,c]= size(Essaim);
Objectifs=zeros(2,c);
Contraintes=zeros(1,c);
Divers=zeros(100,100);



for index  = 1:l 
    Ps_ref=Essaim(1,index);
    assignin('base','Ps_ref',Ps_ref);
    
    
    [time,Vcpl,~]=fct_run_model("DC_grid_noSCPF");
    Contraintes(1,index)=fct_stable(time,Vcpl);
    Objectifs(1,index)=-Essaim(1,index);
    disp(Ps_ref+ ": "+Contraintes(1,index));

    Objectifs(2,index)=-Essaim(1,index);
    
    
    
    
end

end
    
