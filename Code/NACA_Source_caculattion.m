%% 计算J值
% 从txt文件中读取x，y
clc
a = load("NACA23021.dat")
x = a(:,1)
y = a(:,2)
x_control = []
y_control = []
Q = []
for i = 1:1:length(x)-1
    x_control(end + 1)=(x(i)+x(i+1))/2;
    y_control(end + 1)=(y(i)+y(i+1))/2;
    Q(end +1) = atan2(y_control(i),x_control(i))-pi/2;
end

k1 = 15.957;
m = 0.2025;
x1 = [0:0.01:m];
x2 = [m:0.01:1];
y1 = k1/6*(x1.^3-3*m*x1.^2+m^2*(3-m)*x1);
y2 = k1*m^3/6*(1-x2);

plot(x1,y1)
hold on 
plot(x2,y2)
hold on 
plot(x,y,'-o')
axis([0 1 -0.2 0.2])
hold on 
scatter(x_control,y_control,'red','*')
hold off

%% 将之前的source_panel的方法进行移植
clc
syms s
Ans = [];
V_num = [];
a = 34;
sum = 0;
All_Metric = zeros(a);
for i = 1:1:a
    for j = 1:1:a
        A = -( x_control(i)-x(j) )*cos(Q(j))-(y_control(i)-y(j))*sin(Q(j));
        B = ( x_control(i)-x(j) )^2 + (y_control(i) - y(j))^2;
        C = sin(Q(i)-Q(j));
        D = (y_control(i)-y(j))*cos(Q(i))-(x_control(i)-y(j))*sin(Q(i));
        sj = ((x(j+1)-x(j))^2 +(y(j+1)-y(j))^2 )^0.5;
        I = (C*s+D)/(s^2 + 2*A*s+B);   
        IS = int(I,s,0,sj);
        vpa(IS,5);
        Ans(end + 1) = IS;
        All_Metric(i,j) = Ans(end);
    end
    i
    Ans
    Ans = [];
end 
%% 结果计算
All_Metric
V_num = [];


Result = -inv(All_Metric)*cos(Q(1:1:a))'%再次简化
save Result.txt -ascii Result;
for i = 1:1:a
    for j = 1:1:a
        sum = sum + Result(j)*All_Metric(i,j);
    end
    V_num(end+1) = sum + sin(Q(i));
    sum = 0;
end 
length(Q(1:1:a))
length(V_num)
cp
cp = 1-(V_num).^2;
figure(1)
scatter(Q,cp)
figure(2)
scatter(x_control,cp)
axis([0 1 -1 1])