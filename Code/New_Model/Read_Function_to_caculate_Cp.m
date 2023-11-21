%生成翼型
num = 1000;
[xl,xu,yl,yu] = y_Function(num);
x = cat(2,xl,xu)
y = cat(2,yl,yu)
figure(1)
plot(x,y,'-o')

%生成控制点
x_control = []
y_control = []
Q = []
for i = 1:1:length(x)-1
    x_control(end + 1)=(x(i)+x(i+1))/2;
    y_control(end + 1)=(y(i)+y(i+1))/2;
    Q(end +1) = atan2(y_control(i),x_control(i))-pi/2;
end

%% 涡面法计算
Ans = [];
All_Metric = zeros(2*num+1);
syms s;
for i = 1:1:length(x)-1
    for j = 1:1:length(y)-1
        A = -( x_control(i)-x(j) )*cos(Q(j))-(y_control(i)-y(j))*sin(Q(j));
        B = ( x_control(i)-x(j) )^2 + (y_control(i) - y(j))^2;
        C = -1;
        D = (x_control(i)-x(j))*cos(Q(i))+(y_control(i)-y(j))*sin(Q(i));
        sj = ((x(j+1)-x(j))^2 +(y(j+1)-y(j))^2 )^0.5;
        E=(B-A^2)^0.5;
        J = C/2*log((sj^2+2*A*sj+B)/B)+(D-A*C)/E*(atan((sj+A)/E) - atan(A/E));
        %I = (C*s+D)/(s^2 + 2*A*s+B);   
        %J= int(I,s,0,sj);
        Ans(end+1) = J;
        All_Metric(i,j) = Ans(end);
        B;
    end
    i;
    Ans;
end 
All_Metric
%在这里加入相应的库塔条件
Result = -inv(All_Metric)*cos(Q)'

%求解Vi
Vi = [];
sum = 0;
for i = 1:1:2*num+1
    for j = 1:1:2*num+1
        sum = sum + Result(j)*All_Metric(i,j);
    end
    Vi(end+1) = sum + cos(Q(i)+pi/2);
    sum = 0;
end 
Vi;
length(Vi)
length(x_control)
cp = 1-Vi.^2;
figure(2)
scatter(x_control,Vi)
xlabel('x/c')
ylabel('Vi')
figure(3)
scatter(x_control,cp)
xlabel('x/c')
ylabel('cp')

%% 生成NACA23021
function [output1,output2,output3,output4] = y_Function(num)
    y_temp= [];
    xu = [];
    xl = [];
    yu = [];
    yl = [];
    for i = 0:1/num:1
        y_temp(end +1 ) = yc(i);
        %theta = atan2(yc(i+0.01) -yc(i),0.01 );
        save_tan = (yc(i+0.01) -yc(i))/0.01 ;
        save_sin = save_tan / sqrt(save_tan ^ 2 + 1);
        save_cos = 1 / sqrt(save_tan ^ 2 + 1);
        xu(end+1) = i - yt(i)*save_sin;
        xl(end+1) = i + yt(i)*save_sin;
        yu(end+1) = y_temp(end) + yt(i)*save_cos;
        yl(end+1) = y_temp(end) - yt(i)*save_cos;
    end
    % yl(end +1) = 0;
    % yu(end+1)=0;
    % xu(end+1) = 1;
    % xl(end+1) =1 ;
    output1=xu;output2=xl;output3=yu;output4=yl;
    function output = yc(x)
        k1 = 15.957;
        m = 0.2025;
         if x < m
             output = k1/6*(x^3-3*m*x^2+m^2*(3-m)*x);
         elseif x>m
             output =  k1*m^3/6*(1-x);
         end
            
    end
    function output = yt(x)
        t = 0.21;
        output = t/0.2*(0.2969*(x)^0.5 - 0.126*(x)-0.3516*(x)^2 + 0.2843*(x)^3 ...
    -0.1036*(x)^4); 
            
    end
    
end
