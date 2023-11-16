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


plot(x,y,'-o')
axis([0 1 -0.2 0.2])