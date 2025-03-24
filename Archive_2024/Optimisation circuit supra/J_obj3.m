function [f,g,h] = J_obj3(X)
    Tmax = 90; %Maximum temperature
    
    


    
    mdl = 'Sim_avec_ScPF';

    

    %Psc_obj = '/ScFCL v2p2_revLQ';  % Remplace Lt_obj
    %Psc_val = 'Psc';  % Remplace Lt_val
    %Psc_path = [mdl, Psc_obj];  % Remplace Lt_path

    nt_path = 'Sim_avec_ScPF/ScFCL v2p2_revLQ';
    nt_val = 'nt';
    
    Lt_path = [mdl, '/ScFCL v2p2_revLQ'];
    Lt_val = 'tl';


    Rsh_obj = '/ScFCL v2p2_revLQ';
    Rsh_val = 'Rsh';
    Rsh_path = [mdl, Rsh_obj];


    
    Swarm_size = size(X,2);
    f = zeros(2,Swarm_size);
    g = zeros(3,Swarm_size);
    h = zeros(1,Swarm_size);

    for k = 1:1:Swarm_size
        
         nt = X(1,k);
        Lt = X(2,k);
        Rsh = X(3,k);
        P=X(4,k);
   
        %Feed inputs to model and simulate
        set_param(nt_path, nt_val, string(nt));
        set_param(Lt_path, Lt_val, string(Lt));
        set_param(Rsh_path, Rsh_val, string(Rsh));
        
        SimIn = Simulink.SimulationInput(mdl);
        SimIn = setVariable(SimIn, 'P', P);
        out = sim(SimIn);

        Psc = mean(out.Psc.signals.values());  % Récupérer Psc de la sortie Simulink
        %disp(['Itération ', num2str(k), ' : Psc = ', num2str(Psc), ', Rsh = ', num2str(Rsh), ', Ps_ref = ',num2str(P)]);
        
        Vcpl=out.Vcpl.signals.values;
        Icpl=out.Icpl.signals.values;
        Pcpl=Vcpl.*Icpl;
        Pcpl_mean = mean(Pcpl(end-10:end));

        

        S = Is_stable(Vcpl, 5e-5);
        T = max(out.T_out.signals.values,[],'all') - Tmax;
        P_const =abs(Pcpl_mean-P)<P/1000;

        f(:, k) = [Psc; -P]; 
        g(:,k)= [S;T;-P_const];
        h(1,k) = 0;
    end
end