function main_simulation()
    clc; close all;
    % -----------------------------
    % Simulation flags
    % -----------------------------
    simFlags.enableSlosh    = false;   % Turn off all models
    simFlags.enableMassFlow = false;  
    simFlags.enableWind     = false;  
    simFlags.enableDrag     = false;   
    simFlags.enableAero     = false;  
    simFlags.enableEngineModel = false;  

    % -----------------------------
    % Load vehicle parameters
    % -----------------------------
    addpath('../vehicle');
    addpath('Plots\');
    params = parameters();
    params.sim = simFlags;       % embed toggles in params.sim

    % -----------------------------
    % Initial Vehicle State Vector
    % -----------------------------
    % [ x, y, z, vx, vy, vz, phi, theta, psi, p, q, r, mass]
    x0     = 0;   % [m]
    y0     = 0;   
    z0     = 0;   
    vx0    = 0;   % [m/s]
    vy0    = 0;
    vz0    = 0;
    phi0   = 0;   % [rad]
    theta0 = 0;
    psi0   = 0;
    p0     = 0;   % [rad/s]
    q0     = 0;
    r0     = 0;
    m0     = params.mass.empty + params.mass.propellant;  % total mass
    state0 = [x0; y0; z0; vx0; vy0; vz0; phi0; theta0; psi0; p0; q0; r0; m0];
    
    % Simulation Time
    tspan = [0, 300];

    % -----------------------------
    % Run 6dof simulation
    % -----------------------------
    [t, stateOut] = rocket_6dof(tspan, state0, params);
    
    % plots
    addSimulationPlots(t, stateOut)

end
