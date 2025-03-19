function [f,g,h] = J_obj2(X)
    Tmax = 90; %Maximum temperature
    T0 = 77; %Ambient temperature
    Tcarac = 38.7; %Copper characteristic temperature
    rho_Cu = (17e-9)*(T0-Tcarac)/(20+273.5-Tcarac); %Copper resistivity (may need checking)
    J_Cu = 5e6; %Copper current density for intermediate length periods
    J_Cu_max = 100e6; %Copper current density for short spikes
    eta = 0.0712; %Cooling cycle efficiency
    m_Cu = 8940; %Density of Copper (kg.m^-3)
    Cu_cost = 50; %Copper cost ($.kg^-1)
    Sc_cost = 90; %YBCO cost ($.m^-1)


    
    %Define paths to modify variables
    mdl = 'Sim_avec_ScPF';

    nt_obj = '/ScFCL v2p2_revLQ';
    nt_val = 'nt';
    nt_path = [mdl, nt_obj];

    Lt_obj = '/ScFCL v2p2_revLQ';
    Lt_val = 'tl';
    Lt_path = [mdl, Lt_obj];

    Rsh_obj = '/ScFCL v2p2_revLQ';
    Rsh_val = 'Rsh';
    Rsh_path = [mdl, Rsh_obj];


    %Allocate space for outputs
    Swarm_size = size(X,2);
    f = zeros(2,Swarm_size);
    g = zeros(2,Swarm_size);
    h = zeros(1,Swarm_size);

    for k = 1:1:Swarm_size
        nt = X(1,k);
        Lt = X(2,k);
        Rsh = X(3,k);
   
        %Feed inputs to model and simulate
        set_param(nt_path, nt_val, string(nt));
        set_param(Lt_path, Lt_val, string(Lt));
        set_param(Rsh_path, Rsh_val, string(Rsh));
    
        SimIn = Simulink.SimulationInput(mdl);
        out = sim(SimIn);


        %Define intermediate variables and constraints
        N = round(0.05*length(out.Vcpl.signals.values));

        S = Is_stable(out.Vcpl.signals.values, 5e-5);
        T = max(out.T_out.signals.values,[],'all') - Tmax;

        
        Imax = max(abs(out.Ish.signals.values));
        Imean = mean(abs(out.Ish.signals.values(end-N:end)));
        S_Cu = max([Imax/J_Cu_max Imean/J_Cu]);
        V_Cu = Rsh/rho_Cu * S_Cu^2;
        CPcoil = out.CPcoil.signals.values(end-N:end);


        %Calculate CAPEX and OPEX
        CAPEX_Cu = Cu_cost*V_Cu*m_Cu;
        CAPEX_Sc = Sc_cost*nt*Lt;

        CAPEX = CAPEX_Sc + CAPEX_Cu; %Capital Expenses
        

        OPEX_coil = mean(CPcoil)/eta;
        Waste_out = mean(out.RScFCL.signals.values(end-N:end).*(out.i_ScFCL.signals.values(end-N:end).^2));
        
        OPEX = OPEX_coil + Waste_out; %Operating Expenses
    
        
        f(1,k) = CAPEX; 
        f(2,k) = OPEX;
        g(1,k) = S;
        g(2,k) = T;
        h(1,k) = 0;
    end
end