function main_simulation()
    % ==================================================
    % MAIN ACCESS POINT TO RUN SIMULATIONS.
    % USER HAS CONTROL OVER WHAT IS AND ISN'T SIMULATED.
    % TURN ON/OFF MODELS AND SETTINGS FROM HERE.
    % ==================================================

    clc; close all;
    % -----------------------------
    % Simulation flags
    % -----------------------------
    simFlags.enableSlosh        = false; %set all flags to false for now
    simFlags.enableMassFlow     = false;  
    simFlags.enableWind         = false;  
    simFlags.enableDrag         = false;   
    
    % meow
    simFlags.enableAero         = false;  
    simFlags.enableEngineModel  = false;  
    
    % -----------------------------
    % Load ALL Parameters & Set Simulation Flags
    % -----------------------------
    addpath('../Parameters/');
    params = loadAllParameters(simFlags);

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
    
    % Plots
    addSimulationPlots(t, stateOut)

end
