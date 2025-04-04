%% simulink parameters

%inital conditions
vandenberg_lat = deg2rad(34.6430);  % rad
vandenberg_lon = deg2rad(-120.5885); % rad
vandenberg_alt = 10; %m
initial_ecef = [vandenberg_lat vandenberg_lon vandenberg_alt];

Ix_0 = 28;
Iy_0 = 28;
Iz_0 = 12;

Ix_empty = 18;
Iy_empty = 18;
Iz_empty = 8;

% waypoints[x y z; vx; vy; vz] - implement gturn trajectory here instead
% use these for testing 

waypoints = [
    0,    0,    0;    %inital start - turn this into lat long later 
    0,   1,   10; 
    0,   1,    15;
    0,   1,  10; 
    0,   0,    5;   
    0,   0,    0  
];

% time points- secs
time_points = [0, 10, 20, 30, 40, 50, 60];
test_times = [0, 5, 15, 25, 35, 45, 55, 60];

% rocket geometry params
geometry = struct();
geometry.length = 3.0;
geometry.diameter = 0.15;
geometry.noseLength = 0.5;  
geometry.noseShape = 'ogive';

% mass properties 
geometry.mass = 50.0;           %total mass (kg)
geometry.centerOfGravity = 1.5;
geometry.MOI = [5.0, 50.0, 50.0];

% stability params
geometry.centerOfPressure = 1.8; % dist from nose to CP (m)
geometry.staticMargin = (geometry.centerOfPressure - geometry.centerOfGravity) / geometry.diameter; % In calibers

% TVC params
geometry.gimbalLocation = 2.8;   % dist from nose to tvc
geometry.gimbalToBodyCG = [geometry.gimbalLocation - geometry.centerOfGravity; 0; 0]; % 3x1 from CG to gimbal (m)
geometry.maxGimbalAngle = 5 * pi/180; %max gimbal angle

% skin friction - use in thermal model later
geometry.surfaceRoughness = 0.000002; %m


