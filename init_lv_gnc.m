function init_lv_gnc()
% =============================================================
% --------------- INITIALIZE LAUNCH VEHICLE GNC ---------------
% =============================================================

% Initialize launch vehicle GNC folder structure:
%   1) Creates missing folders
%   2) Creates any missing placeholder files
%   3) Generating/Updates a README.md with a summary
%   If the file already exists, no changes are made.
%
% HOW TO USE:
%   1. BASE_DIR points to your existing or desired root folder.
%   2. Edit `placeholderFiles` cell array to add new folders/files.
%   3. Run: 
%          >> initialize_lv_gnc
%   4. The script will create any missing subfolders or placeholder files
%      & update the README.md
%
% NOTE: bbbb
%   - If you want a new top level folder (ie "orbits"), add it
%     to the `subDirs` cell array first.
%     Example: SubDirs ={'orbits'}
%   - If you want new files in the "orbits" folder (ie "orbit_propagation.m"), 
%     add a row to `placeholderFiles`. 
%      Example:  placeholderFiles = {'orbits',  {'orbit_propagation.m'}
%   - This script only creates new folders/files.
%   - Rerun this script when you want to add/update your file structure.
%   - GIT commit any changes on your local before pushing to the repo.
% =========================================================================

    % Base folder
    BASE_DIR = 'lv_gnc'; 

    % Top lvl subdirectories here:
    subDirs = { ...
        'docs/mission_requirements', ...
        'environment', ...
        'vehicle', ...
        'vehicle/propellant', ...  
        'vehicle/actuators', ...   
        'vehicle/propulsion', ...  
        'guidance', ...
        'navigation', ...
        'control', ...
        'simulation', ...
        'test', ...
        'toolbox'...
    };

    % Subdirectories here:
    placeholderFiles = {
        'environment',                  {'atmosphere_model.m', 'gravity_model.m'};
        'vehicle',                      {'rocket_6dof.m', 'parameters.m'};
        'vehicle/propellant',           {'tank_slosh_model.m'};
        'vehicle/actuators',            {'linear_actuator_model.m'};
        'vehicle/propulsion',           {'engine_model.m'};
        'guidance',                     {'guidance_law.m'};
        'navigation',                   {'sensor_fusion.m', 'gnss_model.m'};
        'control',                      {'control_law.m'};
        'simulation',                   {'main_simulation.m'};
        'test',                         {'test_environment.m', ...
                                        'test_vehicle_dynamics.m', ...
                                        'test_guidance.m', ...
                                        'test_navigation.m', ...
                                        'test_control.m'}; ...
        'toolbox',                      {'conversions.m', 'helper_functions.m'}...
    };
    
    % create directories 
    createDir(BASE_DIR);
    for i = 1:length(subDirs)
        createDir(fullfile(BASE_DIR, subDirs{i}));
    end

    for i = 1:size(placeholderFiles,1)
        dirName = placeholderFiles{i,1};
        filesInDir = placeholderFiles{i,2};
        for j = 1:length(filesInDir)
            createPlaceholderFile(fullfile(BASE_DIR, dirName), filesInDir{j});
        end
    end
    createReadMe(BASE_DIR);
end

% =========================================================================
% DIRECTORY CREATION FUNCTIONS
% =========================================================================

function createDir(directory)
    if ~exist(directory, 'dir')
        mkdir(directory);
    end
end

function createPlaceholderFile(directory, filename)
    if ~exist(directory, 'dir')
        mkdir(directory);
    end
    fullPath = fullfile(directory, filename);
    if ~exist(fullPath, 'file')
        fid = fopen(fullPath, 'w');
        if fid == -1
            warning('Could not create file: %s', fullPath);
            return;
        end
        fprintf(fid, '%% Placeholder for %s\n', filename);
        fprintf(fid, '%% To be implemented...\n');
        fclose(fid);
    end
end

function createReadMe(baseDir)
    readmePath = fullfile(baseDir, 'README.md');
    if ~exist(readmePath, 'file')
        fid = fopen(readmePath, 'w');
        if fid == -1
            warning('Could not create README.md in %s', baseDir);
            return;
        end
        fprintf(fid, '# Launch Vehicle GNC \n');
        fprintf(fid, 'This folder contains the GNC subteam repository.\n\n');
        fprintf(fid, '## Folder Structure\n');
        fprintf(fid, '- **docs/mission_requirements**: Mission requirements/objective, orbital params, constraints, etc...\n');
        fprintf(fid, '- **environment**: Atmospheric, gravity and other env models used in the sim.\n');
        fprintf(fid, '- **vehicle**: Primary 6DOF dynamics.\n');
        fprintf(fid, '  - **propellant**: Propellant slosh model.\n');
        fprintf(fid, '  - **actuators**: Linear actuators, gimbals, etc...\n');
        fprintf(fid, '  - **propulsion**: Engine performance and related models.\n');
        fprintf(fid, '- **guidance**: Guidance algorithms.\n');
        fprintf(fid, '- **navigation**: Sensor fusion & state estimation.\n');
        fprintf(fid, '- **control**: Control laws.\n');
        fprintf(fid, '- **simulation**: Main access point for running sims.\n');
        fprintf(fid, '- **test**: Scripts for unit testing.\n\n');
        fclose(fid);
    end
end
