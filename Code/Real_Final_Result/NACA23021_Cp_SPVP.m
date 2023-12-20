%**************************************************
%Time:2023年12月20日
%Puncton:实现NACA23021的压力分布系数的计算，使用涡面法和面源结合法进行计算
%People:敖洋智
%*************************************************


%获取数据
nodes = 200;
[X_AoA_0_Xfoil,Y_AoA_0_Xfoil,XB_AoA_0_Xfoil,YB_AoA_0_Xfoil,Cp_AoA_0_Xfoil,Cp_AoA_0,XC_AoA_0] = SPVP_Cp(nodes,0);
[X_AoA_10_Xfoil,Y_AoA_10_Xfoil,XB_AoA_10_Xfoil,YB_AoA_10_Xfoil,Cp_AoA_10_Xfoil,Cp_AoA_10,XC_AoA_10] = SPVP_Cp(nodes,10);
[X_AoA_15_Xfoil,Y_AoA_15_Xfoil,XB_AoA_15_Xfoil,YB_AoA_15_Xfoil,Cp_AoA_15_Xfoil,Cp_AoA_15,XC_AoA_15] = SPVP_Cp(nodes,15);
[X_AoA_20_Xfoil,Y_AoA_20_Xfoil,XB_AoA_20_Xfoil,YB_AoA_20_Xfoil,Cp_AoA_20_Xfoil,Cp_AoA_20,XC_AoA_20] = SPVP_Cp(nodes,20);


subplot(2,2,1)
subtitle("VPM-AoA-0")
My_plot_Cp(X_AoA_0_Xfoil,Cp_AoA_0_Xfoil,Cp_AoA_0,XC_AoA_0)
subplot(2,2,2)
subtitle("VPM-AoA-10")
My_plot_Cp(X_AoA_10_Xfoil,Cp_AoA_10_Xfoil,Cp_AoA_10,XC_AoA_10)
subplot(2,2,3)
subtitle("VPM-AoA-15")
My_plot_Cp(X_AoA_15_Xfoil,Cp_AoA_15_Xfoil,Cp_AoA_15,XC_AoA_15)
subplot(2,2,4)
subtitle("VPM-AoA-20")
My_plot_Cp(X_AoA_20_Xfoil,Cp_AoA_20_Xfoil,Cp_AoA_20,XC_AoA_20)
