
%Constants PID

Kp_phi=4;
Ti_phi=100000000;
Td_phi=0.1833;

Kp_theta=2;
Ti_theta=10000000;
Td_theta=0.275;

Kp_psi=1.5;
Ti_psi=1000000;
Td_psi=0.42;

Kp_z=8;
Ti_z=1000000000;
Td_z=0.5; 

%Imprimir PID
figure(1)
subplot(4,1,1)
hold on
plot(t,phiref,t,phi)
legend('phiref','phi')
xlabel('t')
ylabel('phi (deg)')
grid on

subplot(4,1,2)
hold on
plot(t,thetaref,t,theta)
legend('thetaref','theta')
xlabel('t')
ylabel('theta (deg)')
grid on

subplot(4,1,3)
hold on
plot(t,psiref,t,psi)
legend('psiref','psi')
xlabel('t')
ylabel('psi (deg)')
grid on

subplot(4,1,4)
hold on
plot(t,zref,t,z)
legend('zref','z')
xlabel('t')
ylabel('z (m)')
grid on