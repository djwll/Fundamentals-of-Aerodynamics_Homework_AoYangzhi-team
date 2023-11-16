import numpy as np
from matplotlib import pyplot as plt
# 先把翼型上面的点给画出来
def naca_coordinates(num, m, k1,c ,t):
    x = np.array([])
    x = np.linspace(0, 0.2, int(num * 0.4))
    x = np.append(x, np.linspace(0.2 + 0.2 / (num * 0.4), 1, int(num * 0.6)))

    yc = np.where(x <= m, k1/6*(x**3-3*m*x**2+m**2*(3-m)*x),
                  k1*(m**3)/6*(1-x))
    yt = 5 * t * (0.2969 * np.sqrt(x) - 0.1260 * x - 0.3516 * x ** 2 +
                  0.2843 * x ** 3 - 0.1036 * x ** 4)
    # 开始处理正切值
    save_tan = np.gradient(yc, x)
    save_sin = save_tan / np.sqrt(save_tan ** 2 + 1)
    save_cos = 1 / np.sqrt(save_tan ** 2 + 1)
    xu = x - yt * save_sin
    xl = x + yt * save_sin
    yu = yc + yt * save_cos
    yl = yc - yt * save_cos
    return xu, xl, yu, yl

#print(naca_coordinates(100,0.025,15.967,1.5,0.21))
xu,xl,yu,yl=naca_coordinates(100,0.025,15.967,1.5,0.21)
print(xu,xl,yu,yl)

 
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
print(xl,yl)
plt.scatter(x,y)
plt.plot(xu,yu)
plt.plot(xl,yl)
plt.xlim (0,1)
plt.ylim (-0.3,0.3)
plt.show()
