function [outputs]=fct_modelesupra(variables, parameters)
struct2var(parameters);
struct2var(variables);

open_system('systeme_with_supra', 'loadonly'); % Charge le modèle
out=sim("systeme_with_supra"); % Simule le modèle

% Récupération des données
Icpl = out.Icpl.signals.values;
Vcpl = out.Vcpl.signals.values;
CPcoil = out.CPcoil.signals.values;
Isupra = out.Isupra.signals.values;
Vsupra = out.Vsupra.signals.values;
Tsupra = out.Tsupra.signals.values;
Ir = out.Ir.signals.values;
Vr = out.Vr.signals.values;


outputs=var2struct([],Icpl, Vcpl, CPcoil, Isupra, Vsupra, Tsupra, Ir, Vr);
end