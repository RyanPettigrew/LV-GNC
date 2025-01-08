function params = parameters()
% =============================================================
% -------------------- VEHICLE PARAMETERS ---------------------
% =============================================================

% This file returns a struct containing all vehicle parameters.

% EXAMPLE:
%   params = parameters(); 
%   disp(params.mass.empty);        % Access empty vehicle mass
%
%   Load parameters into the main simulation/subsystem model using:
%       params = parameters();
%
% NOTE:
%   - Keep parameter names as clear as possible by using full name.
% =============================================================

    % -----------------------
    % MASS PROPERTIES
    % -----------------------
    params.mass.empty       = 12000;   % [kg] rocket dry mass
    params.mass.propellant  = 30000;   % [kg] nominal propellant mass
    params.mass.payload     = 1000;    % [kg] payload mass capacity
    params.mass.oxFlowRate = 100;      % [kg/sec]
    params.mass.oxFlowRate = 100;      % [kg/sec]
    params.mass.propellant = 200;      % [kg]

    % -----------------------
    % STRCUTURE GEOMETRY
    % -----------------------
    params.geometry.lengthBody  = 15.0; % [m]  rocket length
    params.geometry.diameter = 5;       % [m]  body diameter
    
    % -----------------------
    % PROPELLANT PROPERTIES
    % -----------------------
    params.propellant.type    = 'RP-1/LOX';
    params.propellant.rp1Density = 750;  % [kg/m3]
    params.propellant.loxDensity = 1000; % [kg/m3]
    params.propellant.sloshModel = 'pendulum';
    params.propellant.sloshFreq  = 0.5;  % [Hz]  slosh frequency

    % -----------------------
    % AERODYNAMICS
    % -----------------------
    params.aero.Cd       = 0.30;
    params.aero.Cl       = 0.1;
    params.aero.refArea  = pi*params.geometry.diameter^2 /4;

    % -----------------------
    % PROPULSION
    % -----------------------
    params.engine.ispSea     = 300;   % [s]
    params.engine.thrustSea  = 500000; % [N] Sea-level thrust
    params.engine.thrustVac  = 500000; % [N] Sea-level thrust
    params.engine.numEngines = 5;     % number of main engines
    
    % -----------------------
    % FINITE ELEMENT ANALYSIS (FEA)
    % -----------------------
    params.fea.flexMode  = 0.0001; % [m]

    % -----------------------
    % GRID FINS
    % -----------------------
    params.gridfin.count   = 4;    % number of grid fins
    params.gridfin.area    = 1;    % [m2]
    params.gridFins.Cd     = 0.2;  % drag coeff of each fin

    % -----------------------
    % ENVIRONMENTAL CONSTANTS
    % -----------------------
    params.env.g    = 9.81;  % only use below some altitude
    params.env.stdAtmModel  = 'standardAtmosphere';

    % -----------------------
    % SIMULATION PARAMS
    % -----------------------
    params.sim.timeStep   = 0.01;  % [s] time step
    params.sim.endTime    = 300;   % [s] total simulation time
    params.sim.tspan = [0,300];

end
