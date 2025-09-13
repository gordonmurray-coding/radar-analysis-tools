function run_demo()
% RUN_DEMO  Radar Analysis Tools quickstart
% Creates results/ with QA plots using PC_RADAR_OBS.csv if available.
% Also attempts to run theoretical scripts if present.

close all; clc;
ensure_dir('results');
ensure_dir('data');

% Try to locate data (copy your CSV into ./data if not found)
obs_csv = find_csv({'PC_RADAR_OBS.csv', 'pc_radar_obs.csv'});

if ~isempty(obs_csv)
    T = readtable(obs_csv);
    % Normalize column names
    T.Properties.VariableNames = strtrim(T.Properties.VariableNames);

    % 1) Range over time
    if any(strcmpi(T.Properties.VariableNames,'RANGE_km'))
        fig = figure;
        plot(1:height(T), T.RANGE_km);
        xlabel('Observation index'); ylabel('Range (km)');
        title('Observed Range Over Time');
        saveas(fig, fullfile('results','range_time.png'));
    end

    % 2) Residual histograms
    fig = figure;
    hold on; leg = {};
    if any(strcmpi(T.Properties.VariableNames,'RANGE_RES_km'))
        histogram(T.RANGE_RES_km); leg{end+1} = 'Range Residual (km)';
    end
    if any(strcmpi(T.Properties.VariableNames,'RATE_RES_km_sec'))
        histogram(T.RATE_RES_km_sec); leg{end+1} = 'Rate Residual (km/s)';
    elseif any(strcmpi(T.Properties.VariableNames,'RATE_RES_km/sec'))
        histogram(T.('RATE_RES_km/sec')); leg{end+1} = 'Rate Residual (km/s)';
    end
    if ~isempty(leg)
        xlabel('Residual'); ylabel('Count'); title('Observation Residuals'); legend(leg);
        saveas(fig, fullfile('results','residuals_hist.png'));
    else
        close(fig);
    end
else
    warning('PC_RADAR_OBS.csv not found. Place it under ./data and re-run.');
end

% Optional: run theoretical scripts if present
try_run('scripts/Radar_theoretical_max_accuracy_formulas.m');
try_run('scripts/Radar_theoretical_max_accuracy_formulas_waveforms.m');
try_run('scripts/SDA_theoretical_test.m');

disp('Done. Results saved under results/');
end

function ensure_dir(p); if ~exist(p,'dir'), mkdir(p); end; end
function p = find_csv(cands)
    p = '';
    for i = 1:numel(cands)
        if exist(fullfile('data', cands{i}),'file')
            p = fullfile('data', cands{i}); return;
        end
    end
end
function try_run(f)
    if exist(f,'file')
        try
            run(f);
        catch ME
            warning('Failed running %s: %s', f, ME.message);
        end
    end
end
