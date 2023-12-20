%****************************
% @Time 2023_12_20
% @Punction：实现翼型剖面的画图
% @People:敖洋智
%*****************************

%利用Xfiol导入翼型数据
nodes = 200;
AoA = 0;
[X_0,Y_0,XB,YB,Cp_0]  = NACA23021_Input(nodes,AoA);

figure('Name',"翼型剖面")
plot(XB,YB,'-*')
axis([0 1 -0.5 0.5])
xlabel('XB')
ylabel('YB')