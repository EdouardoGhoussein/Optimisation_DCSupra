function [f,g,h] = J_obj1(X)
    Tmax = 90; %Maximum temperature
    
    


    
    mdl = 'Sim_avec_ScPF';

    

    Lt_obj = '/ScFCL v2p2_revLQ';
    Lt_val = 'tl';
    Lt_path = [mdl, Lt_obj];

    Rsh_obj = '/ScFCL v2p2_revLQ';
    Rsh_val = 'Rsh';
    Rsh_path = [mdl, Rsh_obj];


    
    Swarm_size = size(X,2);
    f = zeros(2,Swarm_size);
    g = zeros(2,Swarm_size);
    h = zeros(1,Swarm_size);

    for k = 1:1:Swarm_size
        
        Lt = X(1,k);
        Rsh = X(2,k);
   
    
        
        set_param(Lt_path, Lt_val, string(Lt));
        set_param(Rsh_path, Rsh_val, string(Rsh));
    
        SimIn = Simulink.SimulationInput(mdl);
        out = sim(SimIn);
        S = Is_stable(out.Vcpl.signals.values, 5e-5);
        T = max(out.T_out.signals.values,[],'all') - Tmax;

        f(1,k) = Lt; 
        f(2,k) = Rsh;
        g(1,k) = S;
        g(2,k) = T;
        h(1,k) = 0;
    end
end