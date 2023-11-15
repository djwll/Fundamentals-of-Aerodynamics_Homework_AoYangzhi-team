%% 计算积分
syms s ;
fun = (C*s+D)/(s^2 + 2*A*s+B);
A = -1.3065;
B = 2.5607;
C = -1;
D = 1.3065;
E = 0.9239;
IS = int(fun,s,0,0.7654),vpa(IS,5)%不给后面的参数会给出fun的一个原函数

%% 将计算过程普遍化,以便进行循环,先对第四块板子进行计算
Polar_x = [-0.9239,-0.6533,0,0.6533,0.9239,0.6533,0,-0.6533];
Polar_y = [0,0.6533,0.9239,0.6533,0,-0.6533,-0.9239,-0.6533];

Circle_x = [-0.9239,-0.9239,-0.3827,0.3827,0.9239,0.9239,0.3827,-0.3827];
Circle_y = [-0.3827,0.3827,0.9239,0.9239,0.3827,-0.3827,-0.9239,-0.9239];

Q = [90/180*pi,45/180*pi,0*pi,315/180*pi,270/180*pi,45/180*pi,0,90/180*pi];
syms s ; 

    Xj = -0.9239;
    Xj2 = -0.3827;
    Yj = 0.3827;
    Yj2 = 0.9239;
    Qi = 315/180*pi ;
    Qj = 45/180*pi ;
    
    xi = 0.6533;
    yi = 0.6533;

    B = (xi-Xj)^2 + (yi - Yj)^2;
    C = sin(Qi-Qj);
    D = (yi - Yj)*cos(Qi)-(xi-Xj)*sin(Qi);
    sj = ((Xj2-Xj)^2 + (Yj2 - Yj)^2)^0.5
    E = (B-A^2)^0.5  ;

%% 引入下标
%计算I4,2,即第二块板对于第四块的面源作用
A = -( Polar_x(4)-Circle_x(2) )*cos(Qj)-(Polar_y(4)-Circle_y(2))*cos(Qj)
B = ( Polar_x(4)-Circle_x(2) )^2 + (Polar_y(4) - Circle_y(2))^2
C = sin(Qi-Qj)
D = (Polar_y(4)-Circle_y(2))*cos(Qi)-(Polar_x(4)-Circle_x(2))*sin(Qi)
sj = ( (Circle_x(3)-Circle_x(2) )^2 + (Circle_y(3)-Circle_y(2) )^2 )^0.5

E = (B-A^2)^0.5  
I = (C*s+D)/(s^2 + 2*A*s+B);
IS = int(I,s,0,sj),vpa(IS,5)

%% 进行循环，计算其他板对于第四块板子的作用
Q = [90/180*pi,45/180*pi,0*pi,315/180*pi,270/180*pi,225/180*pi,180/180*pi,135/180*pi];
Polar_x = [-0.9239,-0.6533,0,0.6533,0.9239,0.6533,0,-0.6533];
Polar_y = [0,0.6533,0.9239,0.6533,0,-0.6533,-0.9239,-0.6533];

Circle_x = [-0.9239,-0.9239,-0.3827,0.3827,0.9239,0.9239,0.3827,-0.3827];
Circle_y = [-0.3827,0.3827,0.9239,0.9239,0.3827,-0.3827,-0.9239,-0.9239];
Ans = [];
clc
for j = 1:1:8 
A = -( Polar_x(4)-Circle_x(j) )*cos(Q(j))-(Polar_y(4)-Circle_y(j))*sin(Q(j));
B = ( Polar_x(4)-Circle_x(j) )^2 + (Polar_y(4) - Circle_y(j))^2;
C = sin(Q(4)-Q(j));
D = (Polar_y(4)-Circle_y(j))*cos(Q(4))-(Polar_x(4)-Circle_x(j))*sin(Q(4));
if j<=7
sj = ( (Circle_x(j+1)-Circle_x(j) )^2 + (Circle_y(j+1)-Circle_y(j) )^2 )^0.5;
else 
sj = ( (Circle_x(1)-Circle_x(8) )^2 + (Circle_y(1)-Circle_y(8) )^2 )^0.5;
end
E = (B-A^2)^0.5;
I = (C*s+D)/(s^2 + 2*A*s+B);   
IS = int(I,s,0,sj);
Ans(end+1)= IS;
end
Ans
vpa(Ans,4)

%% 尝试panel_1

Q = [90/180*pi,45/180*pi,0*pi,315/180*pi,270/180*pi,45/180*pi,180*pi/2,135/180*pi];
Polar_x = [-0.9239,-0.6533,0,0.6533,0.9239,0.6533,0,-0.6533];
Polar_y = [0,0.6533,0.9239,0.6533,0,-0.6533,-0.9239,-0.6533];

Circle_x = [-0.9239,-0.9239,-0.3827,0.3827,0.9239,0.9239,0.3827];
Circle_y = [-0.3827,0.3827,0.9239,0.9239,0.3827,-0.3827,-0.9239,-0.9239];
Ans = [];
clc

for j = [1]
cos(Q(j))
A = -( Polar_x(4)-Circle_x(j) )*cos(Q(j))-(Polar_y(4)-Circle_y(j))*cos(Q(j))
B = ( Polar_x(4)-Circle_x(j) )^2 + (Polar_y(4) - Circle_y(j))^2
C = sin(Q(4)-Q(j))
D = (Polar_y(4)-Circle_y(j))*cos(Q(4))-(Polar_x(4)-Circle_x(j))*sin(Q(4))
sj = 0.7654;
E = (B-A^2)^0.5;
I = (C*s+D)/(s^2 + 2*A*s+B);   
IS = int(I,s,0,sj);
Ans(end+1)= IS;
Ans
end

vpa(Ans,5)


%% 尝试板一和板7
%错误原因，公式代入错误,42未错误的原因，过于特殊，位置十分特殊

Q = [90/180*pi,45/180*pi,0*pi,315/180*pi,270/180*pi,45/180*pi,180*pi/2,135/180*pi];
Polar_x = [-0.9239,-0.6533,0,0.6533,0.9239,0.6533,0,-0.6533];
Polar_y = [0,0.6533,0.9239,0.6533,0,-0.6533,-0.9239,-0.6533];

Circle_x = [-0.9239,-0.9239,-0.3827,0.3827,0.9239,0.9239,0.3827];
Circle_y = [-0.3827,0.3827,0.9239,0.9239,0.3827,-0.3827,-0.9239,-0.9239];
Ans = [];
clc

for j = [1]
cos(Q(j))
A = -( Polar_x(4)-Circle_x(j) )*cos(Q(j))-(Polar_y(4)-Circle_y(j))*sin(Q(j));
B = ( Polar_x(4)-Circle_x(j) )^2 + (Polar_y(4) - Circle_y(j))^2;
C = sin(Q(4)-Q(j));
D = (Polar_y(4)-Circle_y(j))*cos(Q(4))-(Polar_x(4)-Circle_x(j))*sin(Q(4));
sj = 0.7654;
E = (B-A^2)^0.5;
I = (C*s+D)/(s^2 + 2*A*s+B);   
IS = int(I,s,0,sj);
Ans(end+1)= IS;
Ans
end

vpa(Ans,5)

%%  成功计算版本，原始计算
Q = [90/180*pi,45/180*pi,0*pi,315/180*pi,270/180*pi,225/180*pi,180/180*pi,135/180*pi];
Polar_x = [-0.9239,-0.6533,0,0.6533,0.9239,0.6533,0,-0.6533];
Polar_y = [0,0.6533,0.9239,0.6533,0,-0.6533,-0.9239,-0.6533];

Circle_x = [-0.9239,-0.9239,-0.3827,0.3827,0.9239,0.9239,0.3827,-0.3827];
Circle_y = [-0.3827,0.3827,0.9239,0.9239,0.3827,-0.3827,-0.9239,-0.9239];
Ans = [];
clc
for j = 1:1:8 
A = -( Polar_x(4)-Circle_x(j) )*cos(Q(j))-(Polar_y(4)-Circle_y(j))*sin(Q(j));
B = ( Polar_x(4)-Circle_x(j) )^2 + (Polar_y(4) - Circle_y(j))^2;
C = sin(Q(4)-Q(j));
D = (Polar_y(4)-Circle_y(j))*cos(Q(4))-(Polar_x(4)-Circle_x(j))*sin(Q(4));
if j<=7
sj = ( (Circle_x(j+1)-Circle_x(j) )^2 + (Circle_y(j+1)-Circle_y(j) )^2 )^0.5;
else 
sj = ( (Circle_x(1)-Circle_x(8) )^2 + (Circle_y(1)-Circle_y(8) )^2 )^0.5;
end
E = (B-A^2)^0.5;
I = (C*s+D)/(s^2 + 2*A*s+B);   
IS = int(I,s,0,sj);
Ans(end+1)= IS;
end
Ans
vpa(Ans,4)

%% 八块panel进行循环计算,并加入Result计算
syms s ;
Q = [90/180*pi,45/180*pi,0*pi,315/180*pi,270/180*pi,225/180*pi,180/180*pi,135/180*pi];
Polar_x = [-0.9239,-0.6533,0,0.6533,0.9239,0.6533,0,-0.6533];
Polar_y = [0,0.6533,0.9239,0.6533,0,-0.6533,-0.9239,-0.6533];
Ans = [];
Circle_x = [-0.9239,-0.9239,-0.3827,0.3827,0.9239,0.9239,0.3827,-0.3827];
Circle_y = [-0.3827,0.3827,0.9239,0.9239,0.3827,-0.3827,-0.9239,-0.9239];
clc
All_Metric = zeros(8);
for i = 1:1:8
    for j = 1:1:8 
        A = -( Polar_x(i)-Circle_x(j) )*cos(Q(j))-(Polar_y(i)-Circle_y(j))*sin(Q(j));
        B = ( Polar_x(i)-Circle_x(j) )^2 + (Polar_y(i) - Circle_y(j))^2;
        C = sin(Q(i)-Q(j));
        D = (Polar_y(i)-Circle_y(j))*cos(Q(i))-(Polar_x(i)-Circle_x(j))*sin(Q(i));
        E = (B-A^2)^0.5;
        sj = 0.7654;
        I = (C*s+D)/(s^2 + 2*A*s+B);   
        IS = int(I,s,0,sj);
        Ans(end + 1) = IS;
        if C ==0
        All_Metric(i,j) = pi;
        else 
        All_Metric(i,j) = Ans(end);
        end
    end
    Ans;
    Ans = [];
end 
All_Metric

Result = -inv(All_Metric)*[cos(180/180*pi);cos(135/180*pi);cos(90/180*pi);...
    cos(45/180*pi);cos(0/180*pi);cos(315/180*pi);cos(270/180*pi);cos(225/180*pi);]

%% 使用圆的坐标进行书写
syms s;
Circle_x = [];
Circle_y = [];
Polar_x = [];
Polar_y = [];
Q =[];
%计算Circle_x
for Angle = 9*pi/8:-pi/4: -2*pi + 9*pi/8
    Circle_x(end +1) = cos(Angle);
    Circle_y(end +1) = sin(Angle);
end
for i = 1:1:8
    Q(end+1) = atan((y(i+1)-y(i))/(x(i+1)-x(i)));
    if i == 8
        Polar_x(end +1) = ( Circle_x(8) + Circle_x(1) )/2;
        Polar_y(end +1) = ( Circle_y(8) + Circle_y(1) )/2;
    else
        Polar_x(end +1) = ( Circle_x(i) + Circle_x(i+1) )/2;
        Polar_y(end +1) = ( Circle_y(i) + Circle_y(i+1) )/2;
    end
end
vpa(Circle_x,5)
vpa(Circle_y,5)
vpa(Polar_x,5)
vpa(Polar_y,5)

% 而后与之前的代码一致
Q = [90/180*pi,45/180*pi,0*pi,315/180*pi,270/180*pi,225/180*pi,180/180*pi,135/180*pi];
Ans = [];
All_Metric = zeros(8);
for i = 1:1:8
    for j = 1:1:8 
        A = -( Polar_x(i)-Circle_x(j) )*cos(Q(j))-(Polar_y(i)-Circle_y(j))*sin(Q(j));
        B = ( Polar_x(i)-Circle_x(j) )^2 + (Polar_y(i) - Circle_y(j))^2;
        C = sin(Q(i)-Q(j));
        D = (Polar_y(i)-Circle_y(j))*cos(Q(i))-(Polar_x(i)-Circle_x(j))*sin(Q(i));
        E = (B-A^2)^0.5;
        sj = 0.7654;
        I = (C*s+D)/(s^2 + 2*A*s+B);   
        IS = int(I,s,0,sj);
        Ans(end + 1) = IS;
        if C ==0
        All_Metric(i,j) = pi;
        else 
        All_Metric(i,j) = Ans(end);
        end
    end
    Ans;
    Ans = [];
end 
All_Metric

Result = -inv(All_Metric)*[cos(180/180*pi);cos(135/180*pi);cos(90/180*pi);...
    cos(45/180*pi);cos(0/180*pi);cos(315/180*pi);cos(270/180*pi);cos(225/180*pi);]
%% 使用解析方法求解
clc
theta = [0:0.1:2*pi];
y = 1-4*sin(theta).^2;
plot(theta,y)
hold on
% 使用数值方法求解
clc
syms s;
Circle_x = [];
Circle_y = [];
Polar_x = [];
Polar_y = [];

%计算Circle_x
for Angle = 9*pi/8:-pi/4: -2*pi + 9*pi/8
    Circle_x(end +1) = cos(Angle);
    Circle_y(end +1) = sin(Angle);
end
for i = 1:1:8
    if i == 8
        Polar_x(end +1) = ( Circle_x(8) + Circle_x(1) )/2;
        Polar_y(end +1) = ( Circle_y(8) + Circle_y(1) )/2;
    else
        Polar_x(end +1) = ( Circle_x(i) + Circle_x(i+1) )/2;
        Polar_y(end +1) = ( Circle_y(i) + Circle_y(i+1) )/2;
    end
end
sum = 0;
V_num=[];
theta = [0:pi/4:2*pi]
for i = 1:1:8
    for j = 1:1:8
        sum = sum + Result(j)*All_Metric(i,j);
    end
    V_num(end+1) = sum + sin(Q(i));
    sum = 0;
end 
V_num(end + 1) = V_num(1);
cp = 1-(V_num).^2
scatter(theta,cp)
hold off
