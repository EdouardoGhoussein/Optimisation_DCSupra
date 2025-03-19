function [outputs]=fct_modelesupra(variables, parameters)
struct2var(parameters);
struct2var(variables);

open_system('systeme_with_supra', 'loadonly'); % Charge le modèle
out=sim("systeme_with_supra"); % Simule le modèle

% Récupération des données
Iout = out.Iout.signals.values;
CPcoil = out.CPcoil.signals.values;
Vout = out.Vout.signals.values;
isupra = out.isupra.signals.values;
Tsupra = out.Tout.signals.values;
vsupra = out.vsupra.signals.values;
Vr = out.Vr.signals.values;
Ir = out.Ir.signals.values;

outputs=var2struct([],Iout, CPcoil, Vout, isupra, Tsupra, vsupra, Ir, Vr);
end