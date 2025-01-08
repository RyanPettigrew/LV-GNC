function addSimulationPlots(t, state)
    % -----------------------------
    % PLOTS
    % -----------------------------
    figure;
    subplot(3,1,1);
    plot(t, state(:,1));
    ylabel('Position X [m]'); xlabel('Time [s]');
    title('Altitude'); grid on;

    subplot(3,1,2);
    plot(t, state(:,2));  % vertical velocity
    ylabel('Y Position [m/s]'); xlabel('Time [s]');
    title('Y Position'); grid on;

    subplot(3,1,3);
    plot(t, state(:,3)); % mass
    ylabel('X [m]'); xlabel('Time [s]');
    title('X Position'); grid on;
    sgtitle('Rocket Position');
end