clear all; clc;
tspan = [0 3];
T = [tspan(1): 0.01: tspan(2)]';

for i = 1 : 100
   u_SW(i) = 450; 
end

for i = 101 : 200
   u_SW(i) = -450; 
end

for i = 201 : 301
   u_SW(i) = 0; 
end

options = simset('SrcWorkspace','current'); 
sim('Rollover_Driver',tspan,options);