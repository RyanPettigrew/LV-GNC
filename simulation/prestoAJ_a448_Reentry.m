% A.J. Presto
% AERO 448
% Reentry Code

% Close graphs, clear workspace, and clear command window
close all; clear; clc;

%% Seconds Stage Knowns

% Note that later this will have to be in terms of eci instead of ecf to
% account for Earth's rotation when trying to land

% Second Stage & Earth Knowns
eps = 0.58; % Structural Mass Coeff
%mdotO = 20.5836; % Second Stage Ox Flow Rate
%mdotF = 6.41234; % Second Stage Fuel Flow Rate
mu = 3.986004418e14; % [m^3/s^2]
reentry_alt = 500000; % [m] Altitude of Reentry
rE = 6378000; % [m] Radius of Earth
r0 = (reentry_alt+rE); % [m] Radius of Reentry
rho0 = 1.225; % [kg/m^3] Sea Level Atmospheric Density
Cd = 0.02723; % [TEMP] Coefficient of Drag
CL = 0.11059; % [TEMP] Coefficient of Lift
S = 138; % [m^2] [TEMP] Wing Surface Area
H = 7100; % [m] Mean Scale Height
OmegaE = 7.2921159e-5; % [Rad/s] Angular Velocity of Earth

% Orbital Elements
v = 140*pi/180; % [rad] true anomaly (Keep positive, 0 to 2pi)
i = 97.4*pi/180; % [rad] inclination
omega = 0; % [rad] argument of perigee
RAAN = 56*pi/180; % [rad] RAAN
e = 0; % eccentricity
hm = sqrt((r0/1000)*mu*10^-9);
[r_ECI_0, v_ECI_0] = c2vd(v,i,omega,RAAN,e,mu*10^-9,hm);

% Angle math for North direction & angle between North & orbit
north_vec = zeros(3,1);
if dot(r_ECI_0,[0;0;1]) == 0
    north_vec = [0;0;1];
else
    m = norm(r_ECI_0)^2/dot(r_ECI_0,[0;0;1]);
    north_vec = m*[0;0;1]-r_ECI_0;
end
if (v > pi) && (v < 2*pi)
    north_vec = north_vec.*-1;
end
course_angle_CCW_params = vrrotvec(north_vec,v_ECI_0);

% Initial Conditions
lla = ecef2lla(r_ECI_0'*1000);
lon0 = lla(2)*pi/180; % [rad] Longitude
lat0 = lla(1)*pi/180; % [rad] Latitude
v0 = norm(v_ECI_0)*1000; % [m/s] Initial Velocity
y0 = -9*pi/180; % [rad] Initial flight path angle
psi0 = 2*pi-course_angle_CCW_params(4); % [rad] Initial course angle


% Define state variable for initial conditions
x0 = [r0;lon0;lat0;v0;y0;psi0];


%% Mass Calcs

m_dry = 87000; % Final Mass
m_prop = 64000; % Initial Propellant Mass
m_reentry = m_dry + m_prop*.05; % Reentry Mass (Assuming 5% Propellant Remaining)

%% Plot Results

% Create reentry time and call on simulation
tspan = 8000; % seconds
out = sim('prestoAJ_a448_Reentry_Sim');

%%

data = squeeze(out.stateVec.signals.values);
lat = data(3,:).*180/pi;
lon = data(2,:).*180/pi;
h = data(1,:)-rE;

% Plot Earth
uif = uifigure;
g = geoglobe(uif);
geoplot3(g,lat,lon,h,"r")


y0 = -5*pi/180; %
x0 = [r0;lon0;lat0;v0;y0;psi0];
out1 = sim('prestoAJ_a448_Reentry_Sim');
data1 = squeeze(out1.stateVec.signals.values);
y0 = -15*pi/180; %
x0 = [r0;lon0;lat0;v0;y0;psi0];
out2 = sim('prestoAJ_a448_Reentry_Sim');
data2 = squeeze(out2.stateVec.signals.values);

figure(2)
subplot(1,2,1)
hold on;
plot(out1.tout,data1(4,:)./1000)
plot(out.tout,data(4,:)./1000)
plot(out2.tout,data2(4,:)./1000)
hold off;
ylabel('Velocity (km/s)')
xlabel('Time (s)')
title("Velocity vs Time")
legend('5°','9°','15°')
grid on;
subplot(1,2,2)
hold on
plot(out1.tout,(data1(1,:)-rE)/1000)
plot(out.tout,(data(1,:)-rE)/1000)
plot(out2.tout,(data2(1,:)-rE)/1000)
hold off
ylabel('Altitude (km)')
xlabel('Time (s)')
title("Altitude vs Time")
legend('5°','9°','15°')
grid on;
sgtitle("Velocity & Altitude with Varying Reentry Angle")

%%

coords = lla2ecef([lat' lon' h'])./1000;

figure;
hold on
earth_sphere(gca)
view(45, 45)

% Animate the point moving along the path
for k = 2:length(coords)
    plot3(coords(k,1),coords(k,2),coords(k,3), ".", LineWidth = 2, Color = "m")
    drawnow;
    pause((out.tout(k)-out.tout(k-1))/1000)
end
hold off

figure(4)
hold on
earth_sphere(gca)
view(45, 45)
plot3(coords(:,1),coords(:,2),coords(:,3), ".", LineWidth = 2, Color = "m")
plot3(out.r_ECI.signals.values(:,1),out.r_ECI.signals.values(:,2),out.r_ECI.signals.values(:,3))

