function addSimulationPlots(t, state)
    % -----------------------------
    % POSITION PLOTS
    % -----------------------------
    figure;
    subplot(3,1,1);
    plot(t, state(:,1));
    ylabel('Position X [m]'); xlabel('Time [s]');
    title('X Position'); grid on;

    subplot(3,1,2);
    plot(t, state(:,2));
    ylabel('Y Position [m/s]'); xlabel('Time [s]');
    title('Y Position'); grid on;

    subplot(3,1,3);
    plot(t, state(:,3));
    ylabel('Z [m]'); xlabel('Time [s]');
    title('Altitude'); grid on;
    sgtitle('Rocket Position');

    % -----------------------------
    % VELOCITY PLOTS
    % -----------------------------
    figure;
    subplot(3,1,1);
    plot(t, state(:,4));
    ylabel('Vel_X [m/s]'); xlabel('Time [s]');
    title('Velocity X'); grid on;

    subplot(3,1,2);
    plot(t, state(:,5));
    ylabel('Vel_Y [m/s]'); xlabel('Time [s]');
    title('Velocity Y'); grid on;

    subplot(3,1,3);
    plot(t, state(:,6)); 
    ylabel('Vel_Z [m/S]'); xlabel('Time [s]');
    title('Velocity Z'); grid on;
    sgtitle('Rocket Velocity');
end