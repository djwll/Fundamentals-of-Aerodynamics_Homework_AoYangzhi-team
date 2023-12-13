function [Cp,XC] = COMPUTE_VPM_Cp(X_0,Y_0,Cp_0,XB,YB,angle_input)
numPts = length(XB);                                                        % Number of boundary points
numPan = numPts - 1; 
XC   = zeros(numPan,1);                                                     % Initialize control point X-coordinate array
YC   = zeros(numPan,1);                                                     % Initialize control point Y-coordinate array
S    = zeros(numPan,1);                                                     % Initialize panel length array
phiD = zeros(numPan,1);  
AoA = angle_input;
Vinf = 1;

for i = 1:1:numPan                                                          % Loop over all panels
    XC(i)   = 0.5*(XB(i)+XB(i+1));                                          % X-value of control point
    YC(i)   = 0.5*(YB(i)+YB(i+1));                                          % Y-value of control point
    dx      = XB(i+1)-XB(i);                                                % Change in X between boundary points
    dy      = YB(i+1)-YB(i);                                                % Change in Y between boundary points
    S(i)    = (dx^2 + dy^2)^0.5;                                            % Length of the panel
	phiD(i) = atan2d(dy,dx);                                                % Angle of the panel (positive X-axis to inside face) [deg]
    if (phiD(i) < 0)                                                        % Make all panel angles positive [deg]
        phiD(i) = phiD(i) + 360;
    end
end

deltaD             = phiD + 90;                                             % Angle from positive X-axis to outward normal vector [deg]
betaD              = deltaD - AoA;                                          % Angle between freestream vector and outward normal vector [deg]
betaD(betaD > 360) = betaD(betaD > 360) - 360;                              % Make all panel angles between 0 and 360 [deg]

phi  = phiD.*(pi/180);                                                      % Convert from [deg] to [rad]
beta = betaD.*(pi/180);                                                     % Convert from [deg] to [rad]

[K,L] = COMPUTE_KL_VPM(XC,YC,XB,YB,phi,S);                                  % Compute geometric integrals

A = zeros(numPan,numPan);                                                   % Initialize the A matrix
for i = 1:1:numPan                                                          % Loop over all i panels
    for j = 1:1:numPan                                                      % Loop over all j panels
        if (j == i)                                                         % If the panels are the same
            A(i,j) = 0;                                                     % Set A equal to zero
        else                                                                % If panels are not the same
            A(i,j) = -K(i,j);                                               % Set A equal to negative geometric integral
        end
    end
end

b = zeros(numPan,1);                                                        % Initialize the b array
for i = 1:1:numPan                                                          % Loop over all panels
    b(i) = -Vinf*2*pi*cos(beta(i));                                         % Compute RHS array
end

pct    = 100;                                                               % Panel replacement percentage
panRep = floor((pct/100)*numPan);                                           % Replace this panel with Kutta condition eqn.
if (panRep == 0)                                                            % If we specify the first panel
    panRep = 1;                                                             % Make sure the index is not zero
end
A(panRep,:)   = 0;                                                          % Set all columns of the replaced panel equal to zero
A(panRep,1)   = 1;                                                          % Set first column of replaced panel equal to 1
A(panRep,end) = 1;                                                          % Set last column of replaced panel equal to 1
b(panRep)     = 0;                                                          % Set replaced panel value in b array equal to zero
gamma = A\b;                                                                % Compute all vortex strength values
Vt = zeros(numPan,1);                                                       % Initialize tangential velocity array
Cp = zeros(numPan,1);                                                       % Initialize pressure coefficient array
for i = 1:1:numPan                                                          % Loop over all i panels
    addVal  = 0;                                                            % Reset the summation value to zero
    for j = 1:1:numPan                                                      % Loop over all j panels
        addVal = addVal - (gamma(j)/(2*pi))*L(i,j);                         % Sum all tangential vortex panel terms
    end
    
    Vt(i) = Vinf*sin(beta(i)) + addVal + gamma(i)/2;                        % Compute tangential velocity by adding uniform flow and i=j terms
    Cp(i) = 1-(Vt(i)/Vinf)^2;                                               % Compute pressure coefficient
end