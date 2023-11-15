%% 计算积分
syms r 
fun = 4*pi*4.17*10^(-3)*r^2
result = int(fun,r,0.5,0.5001)
vpa(result)

%% 热量计算
C = 2.02*10^3;
m = 2.02*1000*(842*pi*(0.5001^2-0.5^2))
t = 1;
Q = result *2
T = C*m*t/Q
vpa(T,5)