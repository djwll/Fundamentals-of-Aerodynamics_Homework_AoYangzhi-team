function [Cp,XC] = COMPUTE_VPM_Cp(X_0,Y_0,Cp_0,XB,YB,angle_input)
numPts = length(XB);                                                        
numPan = numPts - 1; 
XC   = zeros(numPan,1);                                                    
YC   = zeros(numPan,1);                                                     
S    = zeros(numPan,1);                                                     
phiD = zeros(numPan,1);  
AoA = angle_input;
Vinf = 1;

for i = 1:1:numPan                                                          
    XC(i)   = 0.5*(XB(i)+XB(i+1));                                         
    YC(i)   = 0.5*(YB(i)+YB(i+1));                                         
    dx      = XB(i+1)-XB(i);                                               
    dy      = YB(i+1)-YB(i);                                               
    S(i)    = (dx^2 + dy^2)^0.5;                                           
	phiD(i) = atan2d(dy,dx);                                                
    if (phiD(i) < 0)                                                        
        phiD(i) = phiD(i) + 360;
    end
end

deltaD             = phiD + 90;                                             
betaD              = deltaD - AoA;                                          
betaD(betaD > 360) = betaD(betaD > 360) - 360;                              

phi  = phiD.*(pi/180);                                                      
beta = betaD.*(pi/180);                                                     

[K,L] = COMPUTE_KL_VPM(XC,YC,XB,YB,phi,S);                                  

A = zeros(numPan,numPan);                                                   
for i = 1:1:numPan                                                          
    for j = 1:1:numPan                                                      
        if (j == i)                                                         
            A(i,j) = 0;                                                     
        else                                                                
            A(i,j) = K(i,j);                                               
        end
    end
end

b = zeros(numPan,1);                                                        
for i = 1:1:numPan                                                          
    b(i) = -Vinf*2*pi*cos(beta(i));                                        
end
%加入库塔条件
pct    = 100;                                                               
panRep = floor((pct/100)*numPan);                                           
if (panRep == 0)                                                            
    panRep = 1;                                                             
end
A(panRep,:)   = 0;                                                          
A(panRep,1)   = 1;                                                          
A(panRep,end) = 1;                                                          
b(panRep)     = 0;                                                          
gamma = A\b;                                                                
Vt = zeros(numPan,1);                                                       
Cp = zeros(numPan,1);                                                       
for i = 1:1:numPan                                                          
    addVal  = 0;                                                            
    for j = 1:1:numPan                                                      
        addVal = addVal + (gamma(j)/(2*pi))*L(i,j);                         
    end
    
    Vt(i) = Vinf*sin(beta(i)) + addVal - gamma(i)/2;                        
    Cp(i) = 1-(Vt(i)/Vinf)^2;                                               
end