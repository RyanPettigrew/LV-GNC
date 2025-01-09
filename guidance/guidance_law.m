function guidanceCmds = guidance_law(t, state, params)
    mu =3.986e14; 

    % current state
    r_earth = 6378e3;
    r_vec = state(1:3);
    v_vec = state(4:6);
    mass = state(13); 
    current_COE = coe_from_sv(r, v, mu);
    alt = norm(r_vec) - earthRadius;

    % target state
    target = params.targetOrbit;
    guidanceCmds.pitchCmd  = 0;
    guidanceCmds.yawCmd    = 0;
    guidanceCmds.throttle  = 1.0;

    % simple guidance logic for now
    if alt < 20000
        guidanceCmds = guidancePhase1(t, state, params);
    elseif alt < target.insert
        guidanceCmds = guidancePhase2(t, state, params);
    else
        guidanceCmds = guidancePhase3(t, state, params);
    end

end

function cmds = guidancePhase1(t, state, params)
    % pitch vehicle untill 45deg
    desiredPitch = deg2rad(45) * (t / 100);
    desiredPitch = min(desiredPitch, deg2rad(45));
    cmds.pitchCmd = desiredPitch;
    cmds.yawCmd   = 0;
    cmds.throttle = 1.0;
end

function cmds = guidancePhase2(t, state, params)
    desiredPitch = deg2rad(90);  %horizontal trajectory
    desiredYaw = 0;
    cmds.pitchCmd = desiredPitch;
    cmds.yawCmd   = desiredYaw;
    cmds.throttle = 1.0;
end

function cmds = guidancePhase3(t, state, params)
    cmds.pitchCmd  = 0; 
    cmds.yawCmd    = 0;
    cmds.throttle  = 0.7;
end
