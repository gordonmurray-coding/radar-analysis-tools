% radar_residual_accuracy_dashboard.m
% Dashboards biases, sigmas, and RMS for azimuth/elevation/range/range-rate residuals
% Loads PC_RADAR_OBS.csv from ./data and saves a figure under ./results

close all; clc;
% --- Configurable thresholds ---
az_thresh_deg   = 0.04;   % azimuth threshold (deg)
el_thresh_deg   = 0.04;   % elevation threshold (deg)
range_thresh_km = 0.03;   % range threshold (km)
rr_thresh_mps   = 2.0;    % range rate threshold (m/s)

dataFile = fullfile('data','PC_RADAR_OBS.csv');
if ~exist(dataFile,'file')
    error('PC_RADAR_OBS.csv not found. Place it under ./data and re-run.');
end

% Load the CSV file
data = readtable(dataFile);

% Prefer named columns if present; otherwise fall back to indices 8..11
varNames = strtrim(data.Properties.VariableNames);
getcol = @(name, idx) (get_col_by_name(data, varNames, name, idx));

azimuthResidual   = getcol('AZ_RES_deg', 8);
elevationResidual = getcol('EL_RES_deg', 9);
rangeResidual     = getcol('RANGE_RES_km', 10);
% Handle both RATE_RES_km/sec and RATE_RES_km_sec variants
if any(strcmpi(varNames,'RATE_RES_km/sec'))
    rr = data.('RATE_RES_km/sec');
elseif any(strcmpi(varNames,'RATE_RES_km_sec'))
    rr = data.('RATE_RES_km_sec');
else
    rr = getcol('', 11);
end
rangeRateResidual = rr * 1000;  % Convert km/sec to m/sec

% Calculate stats helper
stats = @(v) struct('mu',mean(v,'omitnan'), 'sigma',std(v,'omitnan'), 'rms',sqrt(mean(v.^2,'omitnan')));
A = stats(azimuthResidual);
E = stats(elevationResidual);
R = stats(rangeResidual);
RR = stats(rangeRateResidual);

% Create figures
fig = figure('Position',[100,100,1200,800]);

% Azimuth
subplot(2,2,1);
histogram(azimuthResidual);
title('Azimuth Accuracy - (SENID = 393)');
xlabel('Azimuth (deg)'); ylabel('Count'); legend('Azimuth Data','Location','NorthEast');
annotate_stats(A, az_thresh_deg, azimuthResidual, 'deg');

% Elevation
subplot(2,2,2);
histogram(elevationResidual);
title('Elevation Accuracy - (SENID = 393)');
xlabel('Elevation (deg)'); ylabel('Count'); legend('Elevation Data','Location','NorthEast');
annotate_stats(E, el_thresh_deg, elevationResidual, 'deg');

% Range
subplot(2,2,3);
histogram(rangeResidual);
title('Range Accuracy - (SENID = 393)');
xlabel('Range (km)'); ylabel('Count'); legend('Range Data','Location','NorthEast');
annotate_stats(R, range_thresh_km, rangeResidual, 'km');

% Range Rate
subplot(2,2,4);
histogram(rangeRateResidual);
title('Range Rate Accuracy - (SENID = 393)');
xlabel('Range Rate (m/sec)'); ylabel('Count'); legend('Range Rate Data','Location','NorthEast');
annotate_stats(RR, rr_thresh_mps, rangeRateResidual, 'm/s');

% Save
outPath = fullfile('results','residual_accuracy_dashboard.png');
saveas(fig, outPath);
disp(['Saved ', outPath]);

% --- helpers ---
function v = get_col_by_name(T, names, target, idx)
    if ~isempty(target) && any(strcmpi(names, target))
        v = T.(target);
    else
        % Fallback to positional column (as per original script 8..11)
        v = T{:, idx};
    end
end

function annotate_stats(S, thr, vec, unit)
    text(0.1, 0.90, sprintf('\mu = %.6f', S.mu), 'Units','normalized');
    text(0.1, 0.85, sprintf('\sigma = %.6f', S.sigma), 'Units','normalized');
    text(0.1, 0.80, sprintf('rms = %.6f', S.rms), 'Units','normalized');
    withinThreshold = sum(abs(vec) <= thr);
    totalDataPoints = numel(vec);
    pct = (withinThreshold / max(1,totalDataPoints)) * 100;
    text(0.1, 0.75, sprintf('Within %.3g %s: %.2f%%', thr, unit, pct), 'Units','normalized');
    ylim([0, max([histcounts(vec), 1])]);
end
