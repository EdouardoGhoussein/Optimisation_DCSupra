function [outputs] = fct_ZDT(parameters,variables)

a = parameters(1);

m=length(variables(:,1));

f = @(x) x(1,:);
g = @(x) 1+a*sum(x(2:end,:))/(m-1);
h = @(x,y) 1-sqrt(x./y);

outputs(1,:) = f(variables);
outputs(2,:) = g(variables).*h(f(variables),g(variables));

end