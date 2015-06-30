%INITIAL INFORMATION

%Initial Conditions 
m=1.14;
Ixx=10.4*10^(-3);
Iyy=11.2*10^(-3);
Izz=2.29*10^(-2);
b=1.2*10^(-4);
d=3*10^(-6);
Jr=7.25*10^(-5);
l=0.225;

%Cuadricopter Parametres
x0=0;
x0dot=0;
y0=0;
y0dot=0;
z0=0;
z0dot=0;

phi0=0;
phi0dot=0;
theta0=0;
theta0dot=0;
psi0=0;
psi0dot=0;

xf=-5;
yf=5;
zf=50;

xfdot=0;
yfdot=0;
zfdot=0;

%Reductions
a1=(Iyy-Izz)/Ixx;
a2=Jr/Ixx;
a3=(Izz-Ixx)/Iyy;
a4=Jr/Iyy;
a5=(Ixx-Iyy)/Izz;

b1=1/Ixx;
b2=1/Iyy;
b3=1/Izz;

%Trajectory generator
 alp1=20;
 alp2=10;
 alp3=20;
 
 k1x=0.5;
     if xf<x0;
         k1x=-k1x;
     end
 k1y=0.5;
     if yf<y0;
         k1y=-k1y;
     end
 k1z=2;
      if zf<z0;
         k1z=-k1z;
      end

