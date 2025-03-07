function [time, Vcpl, Icpl,Vsc,Isc] = fct_run_model(model)
    load_system(model);
    % Run the simulation
    simOut = sim(model);

    % Extract results
    time = simOut.tout;
    data = simOut.yout;
    
    Vcpl = data{1}.Values.Data;
    Icpl = data{2}.Values.Data;
    Vsc=data{3}.Values.Data;
    Isc=data{4}.Values.Data;
    close_system(model, 0);
end