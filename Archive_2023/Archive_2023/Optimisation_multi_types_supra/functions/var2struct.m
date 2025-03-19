% Function to add field to a struct variable with the format
% Variable "X" will be pass to struct VAR --> VAR.X
% y = var2struct(input,input1,input2....)
% Input: 
% - input: []: TO create new struct with fields input1, input2,...
% - input: If not empty: to update the struct variable "input" with new
% field input1, input2,...
% Output:
% A struct variable taking all variables as its field name and values are
% values of those variables
% Example:
% a = 4; b = 5; c = 9;
% y = var2struct([],a,b) 
% gives new y with only two fields a and b: y.a = 4; y.b = 5;
% y = var2struct(y,c) 
% gives y with added field c: y.a = 4; y.b = 5; y.c = 9;

function y = var2struct(y,varargin)
for n = 2:nargin                                                            % Access only new fields name (specified in varargin)                      
	y.(inputname(n)) = varargin{n-1};                                       % Passing variables to fields
end
