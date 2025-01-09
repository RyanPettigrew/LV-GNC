function targetOrbit = missionParams()
    % Target Orbit Parameters
    targetOrbit.a     = 6778e3;            %semi major axis [m]
    targetOrbit.e     = 0.0;               %eccentricity
    targetOrbit.i     = deg2rad(51.6);     %inc [rad]
    targetOrbit.Omega = deg2rad(0);        %raan [rad]
    targetOrbit.omega = deg2rad(0);        %arg of perigee [rad]
    targetOrbit.nu    = deg2rad(0);        %True anomaly @ epoch [rad]

    % Guidance Parameters
    targetOrbit.insertionAlt = 400000; %[m]
    targetOrbit.beginPitchAlt = 400;   %[m]
end
