function params = simulationParameters()
    % -----------------------
    % SIMULATION PARAMS
    % -----------------------
    params.sim.timeStep   = 0.01;  % [s] time step
    params.sim.endTime    = 300;   % [s] total simulation time
    params.sim.tspan = [0,300];
end