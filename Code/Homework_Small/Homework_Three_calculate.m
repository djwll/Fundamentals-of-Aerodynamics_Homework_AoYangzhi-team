Prou_U_liquid = 1.36*10^4;
Prou_Experiment_air = 1.23;
g=9.8;
Proportion_A = 1/12;
delta_H = 0.1;

delta_P = Prou_U_liquid*g*delta_H,vpa(delta_P,5)%保留几位小数


v = (2*delta_P/Prou_Experiment_air/(1-(Proportion_A)^2))^0.5