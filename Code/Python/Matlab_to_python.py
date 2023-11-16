
from cmath import cos ,atan,sin
import numpy as np
from scipy.integrate import quad
from math import atan2, pi, log, sqrt
import matplotlib.pyplot as plt

# 从txt文件中读取x，y
a = np.loadtxt("NACA23021.txt")
x = a[:,0]
y = a[:,1]
x = [1,0.95,0.9,0.8,0.7,0.6,
    0.5,0.4,0.3,0.25,0.2,
    0.15,0.1,0.075,0.05,0.025,0.0125,0,
    0.0125,0.025,0.05,0.075,0.1,0.15,0.2,0.25,0.3,0.4,0.5,0.6,
    0.7,0.8,0.9,0.95,1.0]
y = [0.0022,0.0153,0.0276,0.0505,0.0709,0.0890,0.1040,0.1149,
    0.1206,0.1205,0.1180,0.1119,0.1003,0.0913,0.0793,0.0641,
    0.0487,0,-0.0208,-0.0314,-0.0452,-0.0555,-0.0632,-0.0751,
    -0.0830,-0.0876,-0.0895,-0.0883,-0.0814,-0.0707,-0.0572,-0.0413,
    -0.0230,-0.0130,-0.0022]
x_control = []
y_control = []
Q = []
for i in range(len(x)-1):
    x_control.append((x[i]+x[i+1])/2)
    y_control.append((y[i]+y[i+1])/2)
    Q.append(atan2(y_control[i],x_control[i])-pi/2)

plt.plot(x,y,'-o')
plt.axis([0, 1, -0.2, 0.2])
plt.show()

Ans = []
All_Metric = np.zeros((34, 34))

# 定义积分函数
def f(xmid, ymid, x, theta1, theta2):
    A = -( x_control[i]-x )*cosh(Q[j])-(y_control[i]-y)*sinh(Q[j])
    B = ( x_control[i]-x )**2 + (y_control[i] - y)**2
    C = -1
    D = (x_control[i]-x)*cosh(Q[i])+(y_control[i]-y)*sinh(Q[i])
    sj = ((x[j+1]-x[j])**2 +(y[j+1]-y[j])**2 )**0.5
    E=(B-A**2)**0.5
    return C/2*log((sj**2+2*A*sj+B)/B)+(D-A*C)/E*(atan((sj+A)/E) - atan(A/E))

for i in range(len(x)-1):
    for j in range(len(y)-1):
            A = -( x_control[i]-x[j] )*cos(Q[j])-(y_control[i]-y[j])*sin(Q[j])
            B = ( x_control[i]-x[j] )**2 + (y_control[i] - y[j])**2
            C = -1
            D = (x_control[i]-x[j])*cos(Q[i])+(y_control[i]-y[j])*sin(Q[i])
            s = ((x[j+1]-x[j])**2 +(y[j+1]-y[j])**2 )**0.5
            E=(B-A**2)**0.5
            J = C/2*log((s**2+2*A*s+B)/B)+(D-A*C)/E*(atan((s+A)/E) - atan(A/E))
            All_Metric[i,j] = J
    Ans.append(All_Metric[i,j])
    B = ( x_control[i]-x[j] )**2 + (y_control[i] - y[j])**2

All_Metric = np.linalg.pinv(All_Metric)
Result = -np.dot(All_Metric, np.cos(Q))

#求解Vi
Vi = []
_sum = 0
for i in range(34):
    for j in range(34):
        _sum = _sum + Result[j]*All_Metric[i,j]
    Vi.append(_sum + np.cos(Q[i]+pi/2))
    _sum = 0

Vi = np.array(Vi)
cp = 1-Vi**2

plt.figure(1)
plt.scatter(x_control,Vi)
plt.xlabel('x/c')
plt.ylabel('Vi')

plt.figure(2)
plt.scatter(x_control,cp)
plt.xlabel('x/c')
plt.ylabel('cp')

plt.show()