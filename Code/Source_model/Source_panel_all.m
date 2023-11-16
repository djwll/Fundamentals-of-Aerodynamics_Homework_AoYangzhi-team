%% 使用圆的坐标进行书写
syms s;
clc
Circle_x = [];
Circle_y = [];
Polar_x = [];
Polar_y = [];
Q =[];
%计算Circle_x
Q = [90/180*pi,45/180*pi,0*pi,-45/180*pi,-90/180*pi,-135/180*pi,180/180*pi,135/180*pi]
for Angle = 9*pi/8:-pi/4: -2*pi + 9*pi/8
    Circle_x(end +1) = cos(Angle);
    Circle_y(end +1) = sin(Angle);
end
Q=[];%需要清理，否则容易不断拓展，如果不小型的话
for i = 1:1:8
    if i == 8
        Polar_x(end +1) = ( Circle_x(8) + Circle_x(1) )/2;
        Polar_y(end +1) = ( Circle_y(8) + Circle_y(1) )/2;
    else
        Polar_x(end +1) = ( Circle_x(i) + Circle_x(i+1) )/2;
        Polar_y(end +1) = ( Circle_y(i) + Circle_y(i+1) )/2;
    end
    Q(end +1) = atan2(Polar_y(i),Polar_x(i))-pi/2;%tan的取值还得和象限有关系
end
Q      
% 而后与之前的代码一致
%Q = [90/180*pi,45/180*pi,0*pi,315/180*pi,270/180*pi,225/180*pi,180/180*pi,135/180*pi]
Ans = [];
All_Metric = zeros(8);
for i = 1:1:8
    for j = 1:1:8 
        A = -( Polar_x(i)-Circle_x(j) )*cos(Q(j))-(Polar_y(i)-Circle_y(j))*sin(Q(j));
        B = ( Polar_x(i)-Circle_x(j) )^2 + (Polar_y(i) - Circle_y(j))^2;
        C = sin(Q(i)-Q(j));
        D = (Polar_y(i)-Circle_y(j))*cos(Q(i))-(Polar_x(i)-Circle_x(j))*sin(Q(i));
        E = (B-A^2)^0.5;
        sj = ((Circle_x(j+1)-Circle_x(j))^2 +(Circle_y(j+1)-Circle_y(j))^2 )^0.5;;
        J = C/2*log((sj^2+2*A*sj+B)/B)+(D-A*C)/E*(atan((sj+A)/E) - atan(A/E))
        Ans(end + 1) = J;
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
y = 1-4*sin(theta ).^2;
plot(theta,y)
hold on
% 使用数值方法求解
clc
syms s;
Circle_x = [];
Circle_y = [];
Polar_x = [];
Polar_y = [];
sum = 0;
V_num=[];
for i = 1:1:8
    for j = 1:1:8
        sum = sum + Result(j)*All_Metric(i,j);
    end
    V_num(end+1) = sum + sin(Q(i));
    sum = 0;
end 
cp = 1-(V_num).^2;
Q
scatter(Q,cp)
hold off
