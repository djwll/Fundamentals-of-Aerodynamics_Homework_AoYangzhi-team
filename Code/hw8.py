import numpy as np


class PanelElement:
    def __init__(self, c_location, Boundary, angle, length):
        self.location = c_location
        self.angle = angle
        self.Boundary = Boundary
        self.length = length


def integral(i, j):
    A = -((Panel[i].location[0] - Panel[j].Boundary[0]) * np.cos(Panel[j].angle)
          + (Panel[i].location[1] - Panel[j].Boundary[1]) * np.sin(Panel[j].angle))
    B = np.square(Panel[i].location[0] - Panel[j].Boundary[0]) + np.square(Panel[i].location[1] - Panel[j].Boundary[1])
    C = np.sin(Panel[i].angle - Panel[j].angle)
    D = ((Panel[i].location[1] - Panel[j].Boundary[1]) * np.cos(Panel[i].angle) -
         (Panel[i].location[0] - Panel[j].Boundary[0]) * np.sin(Panel[i].angle))
    E = np.sqrt(B - np.square(A))
    L = 2 * (np.sqrt(2) - 1) * a
    result = (C / 2 * np.log((np.square(L) + 2 * A * L + B) / B) +
              (D - A * C) / E * (np.arctan((L + A) / E) - np.arctan(A / E)))
    return result/(2 * np.pi)


# 初始条件
a = np.sqrt(1/(4 - 2 * np.sqrt(2)))
b = a / np.sqrt(2)
L = 2 * (np.sqrt(2) - 1) * a
c_location = [[-a, 0], [-b, b], [0, a], [b, b], [a, 0], [b, -b], [0, -a], [-b, -b]]
angle = np.zeros(8)
angle[0] = np.pi / 2
for i in range(1, 8):
    angle[i] = angle[0] - i * np.pi / 4
Boundary = [[-a, -L / 2], [-a, L / 2], [-L / 2, a], [L / 2, a],
            [a, L / 2], [a, -L / 2], [L / 2, -a], [-L / 2, -a]]
Panel = []
for i in range(0, 8):
    Panel.append(PanelElement(c_location[i], Boundary[i], angle[i], L))
# 构建线性方程组
A = np.diag(0.5 * np.ones(8))
for i in range(0, 8):
    for j in range(0, 8):
        if i != j:
            A[i][j] = integral(i, j)

# v_inf 为无穷远处来流速度
v_inf = 1
b = []
for i in range(0, 8):
    b.append(v_inf * np.sin(Panel[i].angle))


# 解线性方程组
# lamb 为点源强度
lamb = np.linalg.solve(A, b)
# 绝对值很小的项（10^-17）可视为0
for i in range(0, 8):
    if np.abs(lamb[i]) < 1e-6:
        lamb[i] = 0
print(lamb)
# 计算表面的速度以及压力系数
v_1 = []
cp = []
for i in range(0, 8):
    v_1.append(v_inf * np.sin(Panel[i].angle) + np.dot(A[i], lamb))
    cp.append(1 - np.square((v_1[i])/v_inf))
print(v_1)
print(cp)
