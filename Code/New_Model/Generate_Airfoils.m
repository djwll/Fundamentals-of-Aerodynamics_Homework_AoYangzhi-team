clc
a = load("../source_model/NACA23021.dat")
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
%% NACA23021生成
k1 = 15.957;
m = 0.2025;
c = 1.5;
x1 = [0:0.01:m];
x2 = [m:0.01:1];
t = 0.21;%相对厚度
y1 = k1/6*(x1.^3-3*m*x1.^2+m^2*(3-m)*x1);
dy1 = k1/6*(3*x1.^2-6*m*x1+m^2*(3-m))
y2 = k1*m^3/6*(1-x2);
dy2 = -k1*m^3/6
yt1 = t/0.2*c*(0.2969*(x1/c).^0.5 - 0.126*(x1/c)-0.3516*(x1/c).^2 + 0.2843*(x1/c).^3 ...
    -0.1036*(x1/c).^4);
yt2 = t/0.2*c*(0.2969*(x2/c).^0.5 - 0.126*(x2/c)-0.3516*(x2/c).^2 + 0.2843*(x2/c).^3 ...
    -0.1036*(x2/c).^4);
xu1 = x1 - yt1.*sin(atan(dy1));
xl1 = x1 + yt1.*sin(atan(dy1));
xu2 = x2 - yt2.*sin(atan(dy2));
xl2 = x2 + yt2.*sin(atan(dy2));
yu1 = y1 + yt1.*cos(atan(dy1));
yu2 = y2 + yt2.*cos(atan(dy2));
yl1 = y1 - yt1.*cos(atan(dy1));
yl2 = y2 - yt2.*cos(atan(dy2));

plot(xu1,yu1,xu2,yu2)
hold on 
plot(xl1,yl1,xl2,yl2)
hold on 
scatter(x_control,y_control,'red','*')
hold off
%% 简化代码
x1 = [1,0.95,0.9,0.8,0.7,0.6,...
    0.5,0.4,0.3,0.25,0.2,...
    0.15,0.1,0.075,0.05,0.025,0.0125,0,...
    0.0125,0.025,0.05,0.075,0.1,0.15,0.2,0.25,0.3,0.4,0.5,0.6,...
    0.7,0.8,0.9,0.95,1.0]
y1 = [0.0022,0.0153,0.0276,0.0505,0.0709,0.0890,0.1040,0.1149,...
    0.1206,0.1205,0.1180,0.1119,0.1003,0.0913,0.0793,0.0641,...
    0.0487,0,-0.0208,-0.0314,-0.0452,-0.0555,-0.0632,-0.0751,...
    -0.0830,-0.0876,-0.0895,-0.0883,-0.0814,-0.0707,-0.0572,-0.0413,...
    -0.0230,-0.0130,-0.0022]
x = [0:0.01:1];
y = [];
xu = [];
xl = [];
yu = [];
yl = [];
for i = 0:0.01:0.99
    y(end +1 ) = yc(i);
    %theta = atan2(yc(i+0.01) -yc(i),0.01 );
    save_tan = (yc(i+0.01) -yc(i))/0.01 ;
    save_sin = save_tan / sqrt(save_tan ^ 2 + 1);
    save_cos = 1 / sqrt(save_tan ^ 2 + 1);
    xu(end+1) = i - yt(i)*save_sin;
    xl(end+1) = i + yt(i)*save_sin;
    yu(end+1) = y(end) + yt(i)*save_cos;
    yl(end+1) = y(end) - yt(i)*save_cos;
end
yl(end +1) = 0;
yu(end+1)=0;
xu(end+1) = 1;
xl(end+1) =1 ;
plot(xl,yl,xu,yu)
hold on 
scatter(x1,y1)
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

%% 封装为函数

