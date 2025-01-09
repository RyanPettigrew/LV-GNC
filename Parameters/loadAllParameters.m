function params = loadAllParameters(simFlags)
% INPUT:
%   simFlags - Struct containing local flags that override default settings
% OUTPUT:
%   params - Struct containing all params
    % Load all parameters
    vParams = vehicleParameters();      % Load vehicle params
    mParams = missionParameters();      % Load mission params
    sParams = simulationParameters();   % Load sim params
    params = struct();
    % Combine all parameters into a single params struct
    if isfield(vParams, 'mass')
        params.mass = vParams.mass;
    end
    if isfield(vParams, 'geometry')
        params.geometry = vParams.geometry;
    end
    if isfield(vParams, 'propellant')
        params.propellant = vParams.propellant;
    end
    if isfield(vParams, 'aero')
        params.aero = vParams.aero;
    end
    if isfield(vParams, 'engine')
        params.engine = vParams.engine;
    end
    if isfield(vParams, 'fea')
        params.fea = vParams.fea;
    end
    if isfield(vParams, 'env')
        params.env = vParams.env;
    end

    % mission parameters
    if isfield(mParams, 'targetOrbit')
        params.targetOrbit = mParams.targetOrbit;
    end

    % sim settings and flags
    if isfield(sParams, 'simFlags')
        params.simFlags = sParams.simFlags;
    else
        params.simFlags = struct();
    end
    params.simFlags = mergeStructs(params.simFlags, simFlags);
end

function merged = mergeStructs(struct1, struct2)
% Merges two structures...struct2 overrides those in struct1.
    merged = struct1;
    fields = fieldnames(struct2);
    for i = 1:numel(fields)
        merged.(fields{i}) = struct2.(fields{i});
    end
end
