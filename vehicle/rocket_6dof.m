function [t, stateOut] = rocket_6dof(tspan, state0, params)
% ROCKET_6DOF
    options = odeset('RelTol',1e-7,'AbsTol',1e-7);
    [t, stateOut] = ode45(@(t, state) eom6dof(t, state, params), tspan, state0, options);
end

% ========================================================================
% 6DOF equations of motion
% ========================================================================
function dstate = eom6dof(t, state, params)
    % Unpack state vector
    % Position inertial
    x   = state(1);
    y   = state(2);
    z   = state(3);

    % Velocity
    vx  = state(4);
    vy  = state(5);
    vz  = state(6);

    % Euler angles
    phi   = state(7);
    theta = state(8);
    psi   = state(9);

    % Angular rates
    p   = state(10);
    q   = state(11);
    r   = state(12);

    % Mass
    m   = state(13);

    % -------------------------------------------------
    %  environment
    % -------------------------------------------------
    g = params.env.g;
    % implement gravity model later: rho = atmosphereModel(x,y,z,params)
    
    windBody = [0; 0; 0];  % default is no wind
    % turn on wind
    if isfield(params.simFlags, 'enableWind') && params.simFlags.enableWind
        windBody = [10; 0; 0];  
        % or add random disturbance wind model
    end

    % -------------------------------------------------
    %  thrustsimFlags.enableEngineModel 
    % -------------------------------------------------
    T = params.engine.thrustSea;
    T_engine = [0;0;T]; % thrust is along the z-axis
    if isfield(params.simFlags, 'enableEngineModel') && params.simFlags.enableEngineModel
        T = computeThrust(t, m, params);
        % T_missAlignments = [0;0;0]; %I'll implement this later
    end

    % -------------------------------------------------
    % Aerodynamic forces & moments
    % -------------------------------------------------
    M_aero = [0; 0; 0];
    F_aero = [0; 0; 0];
    if isfield(params.simFlags, 'enableAero') && params.simFlags.enableAero
        [F_aero, M_aero] = computeAero([vx; vy; vz], [p; q; r], phi, theta, psi, params);
    end

    % -------------------------------------------------
    % Slosh
    % -------------------------------------------------
    M_slosh = [0; 0; 0];
    F_slosh = [0; 0; 0];
    if isfield(params.simFlags, 'enableSlosh') && params.simFlags.enableSlosh
        [F_slosh, M_slosh] = computeSloshMoment(t, state, params);
    end

    
    % -------------------------------------------------
    % Compute mass flow
    % -------------------------------------------------
    mdot = 0;
    % assumes constant mass unless mass flow rate is turned on 
    if isfield(params.simFlags, 'enableMassFlow') && params.simFlags.enableMassFlow
        mdot = computeMassFlow(t, m, params);
    end
    
    % -------------------------------------------------
    % Compute rotation matrices
    % -------------------------------------------------
    % body to inertial 
    Cbi = euler2dcm(phi, theta, psi);   % returns a 3x3 matrix

    % -------------------------------------------------
    % Translational eqs (inertial)
    % -------------------------------------------------
    % Body forces in inertial frame:
    Fbody_b    = T_engine + F_aero + F_slosh;     % net body-axis forces
    Fbody_i    = Cbi * Fbody_b;                   % transform to inertial frame

    % Gravity in inertial frame
    W_i        = [0; 0; -m*g];

    % Acceleration in inertial frame
    accel_i    = (Fbody_i + W_i) / m;   % [ax_i, ay_i, az_i]^T

    % -------------------------------------------------
    % Rotational eqs
    % -------------------------------------------------
    Ixx = 10; 
    Iyy = 10; 
    Izz = 5;  % placeholders
    I   = diag([Ixx, Iyy, Izz]);

    % Sum moments in body frame
    Mtotal_b = M_aero + M_slosh;  % placeholder

    % Euler's rotational EOM in body frame:
    % I^-1 * (M - omega x (I*omega))
    omega_b  = [p; q; r];
    pqrDot   = I \ ( Mtotal_b - cross(omega_b, I*omega_b) );

    % -------------------------------------------------
    % Kinematics
    % -------------------------------------------------
    % Position
    dx = vx;
    dy = vy;
    dz = vz;

    % Velocity components
    dvx = accel_i(1);
    dvy = accel_i(2);
    dvz = accel_i(3);

    % Euler angles
    eulRates = eulerRates(phi, theta, psi, p, q, r);
    dphi     = eulRates(1);
    dtheta   = eulRates(2);
    dpsi     = eulRates(3);

    % Angular rates
    dp = pqrDot(1);
    dq = pqrDot(2);
    dr = pqrDot(3);

    % -------------------------------------------------
    % Mass derivative
    % -------------------------------------------------
    dm = -mdot;  % rocket mass decreases with fuel consumption

    % -------------------------------------------------
    % Derivative state vector
    % -------------------------------------------------
    dstate = zeros(size(state));
    dstate(1)  = dx;
    dstate(2)  = dy;
    dstate(3)  = dz;
    dstate(4)  = dvx;
    dstate(5)  = dvy;
    dstate(6)  = dvz;
    dstate(7)  = dphi;
    dstate(8)  = dtheta;
    dstate(9)  = dpsi;
    dstate(10) = dp;
    dstate(11) = dq;
    dstate(12) = dr;
    dstate(13) = dm; % mass is the "13th state vector" but not controlled
end

%% FUNCTIONS 
% ========================================================================
% THRUST
% ========================================================================
function Thrust = computeThrust(time, params)
    if time < 30 % simple
        Thrust = params.engine.thrustSea;
    else
        Thrust = params.engine.thrustVac;
    end
end
% ========================================================================
% MASS FLOW
% ========================================================================
function mdot = computeMassFlow(~, m, params)
    % If mass above dry mass, burn at a fixed rate
    if m > params.mass.empty
        mdot = 50;  % [kg/s]
    else
        mdot = 0;
    end
end
% ========================================================================
% SLOSH MOMENT
% ========================================================================
function [F_slosh, M_slosh] = computeSlosh(~, state, params)
    % specify slosh model type
    F_slosh = [0;0;0];
    M_slosh = [0;0;0];
end
% ========================================================================
% AERODYNAMICS FORCES & MOMENTS
% ========================================================================
function [F_aero, M_aero] = computeAero(vel_b, omega_b, phi, theta, psi, params)
    F_aero = [0; 0; 0];
    M_aero = [0; 0; 0];
end

% ========================================================================
% ROTATION MATRIX
% ========================================================================
function C = euler2dcm(phi, theta, psi)
    % DCM from body to inertial using Z-Y-X or 3-2-1
    cphi = cos(phi);
    sphi = sin(phi);
    cthe = cos(theta); 
    sthe = sin(theta);
    cpsi = cos(psi);
    spsi = sin(psi);
    C = [ cpsi*cthe,  cpsi*sthe*sphi - spsi*cphi,  cpsi*sthe*cphi + spsi*sphi
          spsi*cthe,  spsi*sthe*sphi + cpsi*cphi,  spsi*sthe*cphi - cpsi*sphi
          -sthe,      cthe*sphi,                  cthe*cphi ];
end

function euler_rates = eulerRates(phi, theta, ~, p, q, r)
    % Euler angle rates: 3-2-1 rotation sequence
    sphi = sin(phi); 
    cphi = cos(phi);
    cthe = cos(theta); 
    sthe = sin(theta);
    T = [ 1, sphi*sthe/cthe, cphi*sthe/cthe
          0,         cphi,           -sphi
          0, sphi/cthe,         cphi/cthe ];
    
    euler_rates = T * [p; q; r];
end
