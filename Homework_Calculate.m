%% 计算汽车的尺寸
clc
V_reality = 160*1000/3600;
V_Experiment = 60;
L_reality = 1.5;

L_Experiment = L_reality*V_reality/V_Experiment%雷洛数

%% 计算阻力
clc
F_Experiment = 1.5 * 10^3;

F_Reality = (L_reality*V_reality)*F_Experiment/(L_Experiment*V_Experiment)%牛顿准数

%% 计算风洞的风速和压力
clc
V_reality = 400 ; 
L_reality = 1 ;
T_reality = 228;
p_reality= 30.2 ;
Miu_reality = Miu(T_reality);
L_Experiment = 1/20;
T_experiment = 288;
Miu_experiment = Miu(T_experiment);
V_Experiment = V_reality*L_reality/Miu_reality/(L_Experiment/Miu_experiment);
p_experiment = p_reality/(V_reality)^2*V_Experiment^2;
vpa(Miu_reality,5)
vpa(Miu_experiment,5)
vpa(p_experiment,5)
vpa(V_Experiment,5)
function [output] = Miu(T)
    output = (T)^1.5/(T + 110.4);
end

%% 保角变换的推导
