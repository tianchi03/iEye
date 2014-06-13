function mgs_stats()
%MGS_STATS Summary of this function goes here
%   Detailed explanation goes here

%%%%%%%%%%%%%%%%
% WHAT WE WANT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%
% SRT (DONE)
% ERROR (DONE)
% GAIN (DONE)
% VALID TRIALS MATRIX (DONE)
% PERCENT TRIALS BROKE FIXATION (0 = broke, 1 = didnt break)
% BREAK UP STATS IN CATEGORIES: ALL, BROKE FIXATION, DIDN'T BREAK FIXATION
% PLOT DISTRIBUTIONS
% SPLIT DATA BY HEMIFIELD
% SPLIT DATA BY QUADRANT

ii_stats = evalin('base','ii_stats');
num_runs = length(ii_stats); % How many runs did the subject complete?

%%%%%%%%%%%%%%%%%%%%%%%%
% TOSS OUT NOGO TRIALS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%
% Throw out nogo trials (SRT > 900ms);

ii_results.num_trials = num_runs * 30;
ii_results.num_nogo = 0;

for i = 1:num_runs
    ii_stats(i).nogo_mat = ones(30,1);
    ii_stats(i).nogo_inds = find(ii_stats(i).srt>=900);
    ii_stats(i).num_nogo = 30 - length(ii_stats(i).nogo_inds); % Get # of nogo trials
    ii_stats(i).nogo_mat(ii_stats(i).nogo_inds) = 0;
    ii_results.num_nogo = ii_results.num_nogo + ii_stats(i).num_nogo;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%
% CREATE VALIDITY MATRIX %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

ii_results.num_bfix = 0;

% Find fixation breaks
for i = 1:num_runs
    ii_stats(i).break_mat = ii_stats(i).trial_compliance(:,1,1); % Find fixation breaks
    ii_stats(i).num_fix_breaks = 30 - sum(ii_stats(i).break_mat); % Get # of fixation break trials
    ii_results.num_bfix = ii_results.num_bfix + ii_stats(i).num_fix_breaks;
end

% Find left hemifield trials
for i = 1:num_runs
    ii_stats(i).left_mat = zeros(30,1);
    ii_stats(i).left_inds = find(ii_stats(i).corrective_x>=0);
    ii_stats(i).left_mat(ii_stats(i).left_inds) = 1;
    ii_stats(i).num_left_trials = 30 - length(ii_stats(i).left_inds); 
end

% Find right hemifield trials
for i = 1:num_runs
    ii_stats(i).right_mat = zeros(30,1);
    ii_stats(i).right_inds = find(ii_stats(i).corrective_x<0);
    ii_stats(i).right_mat(ii_stats(i).right_inds) = 1; 
    ii_stats(i).num_right_trials = 30 - length(ii_stats(i).right_inds);
end

% Create NO fixation break matrix
for i = 1:num_runs
    ii_stats(i).no_break_mat = zeros(30,1);
    ii_stats(i).good_inds = find(ii_stats(i).nogo_mat==1);
    ii_stats(i).no_break_inds = find(ii_stats(i).break_mat==1);
    ii_stats(i).no_break_mat(ii_stats(i).no_break_inds) = 1;
    ii_stats(i).no_break_mat = ii_stats(i).no_break_mat .* ii_stats(i).nogo_mat;
    ii_stats(i).no_break_left_mat = ii_stats(i).no_break_mat .* ii_stats(i).left_mat;
    ii_stats(i).no_break_right_mat = ii_stats(i).no_break_mat .* ii_stats(i).right_mat;
end

% Create ONLY fixation break matrix
for i = 1:num_runs
    ii_stats(i).only_break_mat = zeros(30,1);
    ii_stats(i).good_inds = find(ii_stats(i).nogo_mat==1);
    ii_stats(i).only_break_inds = find(ii_stats(i).break_mat==0);
    ii_stats(i).only_break_mat(ii_stats(i).only_break_inds) = 1;
    ii_stats(i).only_break_mat = ii_stats(i).only_break_mat .* ii_stats(i).nogo_mat;
    ii_stats(i).only_break_left_mat = ii_stats(i).only_break_mat .* ii_stats(i).left_mat;
    ii_stats(i).only_break_right_mat = ii_stats(i).only_break_mat .* ii_stats(i).right_mat;
end

%%%%%%%%%%%%%%%%%%%%
% COMBINE ALL RUNS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%
% RAW STATS (NOGO ONLY) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%

% All trials
for i = 1:num_runs
    ii_stats(i).good_inds = find(ii_stats(i).nogo_mat==1); % Get good trials
    
    % Error
    ii_stats(i).good_primary_err_x = ii_stats(i).primary_err_x(ii_stats(i).good_inds);
    ii_stats(i).good_primary_err_y = ii_stats(i).primary_err_y(ii_stats(i).good_inds);
    ii_stats(i).good_primary_err_z = ii_stats(i).primary_err_z(ii_stats(i).good_inds);
    
    ii_stats(i).good_final_err_x = ii_stats(i).final_err_x(ii_stats(i).good_inds);
    ii_stats(i).good_final_err_y = ii_stats(i).final_err_y(ii_stats(i).good_inds);
    ii_stats(i).good_final_err_z = ii_stats(i).final_err_z(ii_stats(i).good_inds);
    
    % Gain
    ii_stats(i).good_primary_gain_x = ii_stats(i).primary_gain_x(ii_stats(i).good_inds);
    ii_stats(i).good_primary_gain_y = ii_stats(i).primary_gain_y(ii_stats(i).good_inds);
    ii_stats(i).good_primary_gain_z = ii_stats(i).primary_gain_z(ii_stats(i).good_inds);
    
    ii_stats(i).good_final_gain_x = ii_stats(i).final_gain_x(ii_stats(i).good_inds);
    ii_stats(i).good_final_gain_y = ii_stats(i).final_gain_y(ii_stats(i).good_inds);
    ii_stats(i).good_final_gain_z = ii_stats(i).final_gain_z(ii_stats(i).good_inds);
    
    % SRT
    ii_stats(i).good_srt = ii_stats(i).srt(ii_stats(i).good_inds);
end

% Left trials
for i = 1:num_runs
    ii_stats(i).left_inds = find(ii_stats(i).left_mat==1); % Get good trials
    
    % Error
    ii_stats(i).left_primary_err_x = ii_stats(i).primary_err_x(ii_stats(i).left_inds);
    ii_stats(i).left_primary_err_y = ii_stats(i).primary_err_y(ii_stats(i).left_inds);
    ii_stats(i).left_primary_err_z = ii_stats(i).primary_err_z(ii_stats(i).left_inds);
    
    ii_stats(i).left_final_err_x = ii_stats(i).final_err_x(ii_stats(i).left_inds);
    ii_stats(i).left_final_err_y = ii_stats(i).final_err_y(ii_stats(i).left_inds);
    ii_stats(i).left_final_err_z = ii_stats(i).final_err_z(ii_stats(i).left_inds);
    
    % Gain
    ii_stats(i).left_primary_gain_x = ii_stats(i).primary_gain_x(ii_stats(i).left_inds);
    ii_stats(i).left_primary_gain_y = ii_stats(i).primary_gain_y(ii_stats(i).left_inds);
    ii_stats(i).left_primary_gain_z = ii_stats(i).primary_gain_z(ii_stats(i).left_inds);
    
    ii_stats(i).left_final_gain_x = ii_stats(i).final_gain_x(ii_stats(i).left_inds);
    ii_stats(i).left_final_gain_y = ii_stats(i).final_gain_y(ii_stats(i).left_inds);
    ii_stats(i).left_final_gain_z = ii_stats(i).final_gain_z(ii_stats(i).left_inds);
    
    % SRT
    ii_stats(i).left_srt = ii_stats(i).srt(ii_stats(i).left_inds);
end

% Right trials
for i = 1:num_runs
    ii_stats(i).right_inds = find(ii_stats(i).right_mat==1); % Get good trials
    
    % Error
    ii_stats(i).right_primary_err_x = ii_stats(i).primary_err_x(ii_stats(i).right_inds);
    ii_stats(i).right_primary_err_y = ii_stats(i).primary_err_y(ii_stats(i).right_inds);
    ii_stats(i).right_primary_err_z = ii_stats(i).primary_err_z(ii_stats(i).right_inds);
    
    ii_stats(i).right_final_err_x = ii_stats(i).final_err_x(ii_stats(i).right_inds);
    ii_stats(i).right_final_err_y = ii_stats(i).final_err_y(ii_stats(i).right_inds);
    ii_stats(i).right_final_err_z = ii_stats(i).final_err_z(ii_stats(i).right_inds);
    
    % Gain
    ii_stats(i).right_primary_gain_x = ii_stats(i).primary_gain_x(ii_stats(i).right_inds);
    ii_stats(i).right_primary_gain_y = ii_stats(i).primary_gain_y(ii_stats(i).right_inds);
    ii_stats(i).right_primary_gain_z = ii_stats(i).primary_gain_z(ii_stats(i).right_inds);
    
    ii_stats(i).right_final_gain_x = ii_stats(i).final_gain_x(ii_stats(i).right_inds);
    ii_stats(i).right_final_gain_y = ii_stats(i).final_gain_y(ii_stats(i).right_inds);
    ii_stats(i).right_final_gain_z = ii_stats(i).final_gain_z(ii_stats(i).right_inds);
    
    % SRT
    ii_stats(i).right_srt = ii_stats(i).srt(ii_stats(i).right_inds);
end

% All trials
ii_results.all_primary_err_x = [];
ii_results.all_primary_err_y = [];
ii_results.all_primary_err_z = [];

ii_results.all_final_err_x = [];
ii_results.all_final_err_y = [];
ii_results.all_final_err_z = [];

ii_results.all_primary_gain_x = [];
ii_results.all_primary_gain_y = [];
ii_results.all_primary_gain_z = [];

ii_results.all_final_gain_x = [];
ii_results.all_final_gain_y = [];
ii_results.all_final_gain_z = [];

ii_results.all_srt = [];

% Left trials
ii_results.all_left_primary_err_x = [];
ii_results.all_left_primary_err_y = [];
ii_results.all_left_primary_err_z = [];

ii_results.all_left_final_err_x = [];
ii_results.all_left_final_err_y = [];
ii_results.all_left_final_err_z = [];

ii_results.all_left_primary_gain_x = [];
ii_results.all_left_primary_gain_y = [];
ii_results.all_left_primary_gain_z = [];

ii_results.all_left_final_gain_x = [];
ii_results.all_left_final_gain_y = [];
ii_results.all_left_final_gain_z = [];

ii_results.all_left_srt = [];

% Right trials
ii_results.all_right_primary_err_x = [];
ii_results.all_right_primary_err_y = [];
ii_results.all_right_primary_err_z = [];

ii_results.all_right_final_err_x = [];
ii_results.all_right_final_err_y = [];
ii_results.all_right_final_err_z = [];

ii_results.all_right_primary_gain_x = [];
ii_results.all_right_primary_gain_y = [];
ii_results.all_right_primary_gain_z = [];

ii_results.all_right_final_gain_x = [];
ii_results.all_right_final_gain_y = [];
ii_results.all_right_final_gain_z = [];

ii_results.all_right_srt = [];

% All trials
for j = 1:num_runs
    % Error
    ii_results.all_primary_err_x = [ii_results.all_primary_err_x; ii_stats(j).good_primary_err_x];
    ii_results.all_primary_err_y = [ii_results.all_primary_err_y; ii_stats(j).good_primary_err_y];
    ii_results.all_primary_err_z = [ii_results.all_primary_err_z; ii_stats(j).good_primary_err_z];

    ii_results.all_final_err_x = [ii_results.all_final_err_x; ii_stats(j).good_final_err_x];
    ii_results.all_final_err_y = [ii_results.all_final_err_y; ii_stats(j).good_final_err_y];
    ii_results.all_final_err_z = [ii_results.all_final_err_z; ii_stats(j).good_final_err_z];
    
    % Gain
    ii_results.all_primary_gain_x = [ii_results.all_primary_gain_x; ii_stats(j).good_primary_gain_x];
    ii_results.all_primary_gain_y = [ii_results.all_primary_gain_y; ii_stats(j).good_primary_gain_y];
    ii_results.all_primary_gain_z = [ii_results.all_primary_gain_z; ii_stats(j).good_primary_gain_z];
    
    ii_results.all_final_gain_x = [ii_results.all_final_gain_x; ii_stats(j).good_final_gain_x];
    ii_results.all_final_gain_y = [ii_results.all_final_gain_y; ii_stats(j).good_final_gain_y];
    ii_results.all_final_gain_z = [ii_results.all_final_gain_z; ii_stats(j).good_final_gain_z];
    
    % SRT
    
    ii_results.all_srt = [ii_results.all_srt; ii_stats(j).good_srt];
end

% Left trials
for j = 1:num_runs
    % Error
    ii_results.all_left_primary_err_x = [ii_results.all_left_primary_err_x; ii_stats(j).left_primary_err_x];
    ii_results.all_left_primary_err_y = [ii_results.all_left_primary_err_y; ii_stats(j).left_primary_err_y];
    ii_results.all_left_primary_err_z = [ii_results.all_left_primary_err_z; ii_stats(j).left_primary_err_z];

    ii_results.all_left_final_err_x = [ii_results.all_left_final_err_x; ii_stats(j).left_final_err_x];
    ii_results.all_left_final_err_y = [ii_results.all_left_final_err_y; ii_stats(j).left_final_err_y];
    ii_results.all_left_final_err_z = [ii_results.all_left_final_err_z; ii_stats(j).left_final_err_z];
    
    % Gain
    ii_results.all_left_primary_gain_x = [ii_results.all_left_primary_gain_x; ii_stats(j).left_primary_gain_x];
    ii_results.all_left_primary_gain_y = [ii_results.all_left_primary_gain_y; ii_stats(j).left_primary_gain_y];
    ii_results.all_left_primary_gain_z = [ii_results.all_left_primary_gain_z; ii_stats(j).left_primary_gain_z];
    
    ii_results.all_left_final_gain_x = [ii_results.all_left_final_gain_x; ii_stats(j).left_final_gain_x];
    ii_results.all_left_final_gain_y = [ii_results.all_left_final_gain_y; ii_stats(j).left_final_gain_y];
    ii_results.all_left_final_gain_z = [ii_results.all_left_final_gain_z; ii_stats(j).left_final_gain_z];
    
    % SRT
    
    ii_results.all_left_srt = [ii_results.all_left_srt; ii_stats(j).left_srt];
end

% Right trials
for j = 1:num_runs
    % Error
    ii_results.all_right_primary_err_x = [ii_results.all_right_primary_err_x; ii_stats(j).right_primary_err_x];
    ii_results.all_right_primary_err_y = [ii_results.all_right_primary_err_y; ii_stats(j).right_primary_err_y];
    ii_results.all_right_primary_err_z = [ii_results.all_right_primary_err_z; ii_stats(j).right_primary_err_z];

    ii_results.all_right_final_err_x = [ii_results.all_right_final_err_x; ii_stats(j).right_final_err_x];
    ii_results.all_right_final_err_y = [ii_results.all_right_final_err_y; ii_stats(j).right_final_err_y];
    ii_results.all_right_final_err_z = [ii_results.all_right_final_err_z; ii_stats(j).right_final_err_z];
    
    % Gain
    ii_results.all_right_primary_gain_x = [ii_results.all_right_primary_gain_x; ii_stats(j).right_primary_gain_x];
    ii_results.all_right_primary_gain_y = [ii_results.all_right_primary_gain_y; ii_stats(j).right_primary_gain_y];
    ii_results.all_right_primary_gain_z = [ii_results.all_right_primary_gain_z; ii_stats(j).right_primary_gain_z];
    
    ii_results.all_right_final_gain_x = [ii_results.all_right_final_gain_x; ii_stats(j).right_final_gain_x];
    ii_results.all_right_final_gain_y = [ii_results.all_right_final_gain_y; ii_stats(j).right_final_gain_y];
    ii_results.all_right_final_gain_z = [ii_results.all_right_final_gain_z; ii_stats(j).right_final_gain_z];
    
    % SRT
    
    ii_results.all_right_srt = [ii_results.all_right_srt; ii_stats(j).right_srt];
end

% All trials
ii_results.mean_all_srt = mean(ii_results.all_srt);
ii_results.mean_all_primary_err_z = mean(ii_results.all_primary_err_z);
ii_results.mean_all_final_err_z = mean(ii_results.all_final_err_z);
ii_results.mean_all_primary_gain_z = mean(ii_results.all_primary_gain_z);
ii_results.mean_all_final_gain_z = mean(ii_results.all_final_gain_z);

ii_results.median_all_srt = median(ii_results.all_srt);
ii_results.median_all_primary_err_z = median(ii_results.all_primary_err_z);
ii_results.median_all_final_err_z = median(ii_results.all_final_err_z);
ii_results.median_all_primary_gain_z = median(ii_results.all_primary_gain_z);
ii_results.median_all_final_gain_z = median(ii_results.all_final_gain_z);

ii_results.std_all_srt = std(ii_results.all_srt);
ii_results.std_all_primary_err_z = std(ii_results.all_primary_err_z);
ii_results.std_all_final_err_z = std(ii_results.all_final_err_z);
ii_results.std_all_primary_gain_z = std(ii_results.all_primary_gain_z);
ii_results.std_all_final_gain_z = std(ii_results.all_final_gain_z);

% Left trials
ii_results.mean_all_left_srt = mean(ii_results.all_left_srt);
ii_results.mean_all_left_primary_err_z = mean(ii_results.all_left_primary_err_z);
ii_results.mean_all_left_final_err_z = mean(ii_results.all_left_final_err_z);
ii_results.mean_all_left_primary_gain_z = mean(ii_results.all_left_primary_gain_z);
ii_results.mean_all_left_final_gain_z = mean(ii_results.all_left_final_gain_z);

ii_results.median_all_left_srt = median(ii_results.all_left_srt);
ii_results.median_all_left_primary_err_z = median(ii_results.all_left_primary_err_z);
ii_results.median_all_left_final_err_z = median(ii_results.all_left_final_err_z);
ii_results.median_all_left_primary_gain_z = median(ii_results.all_left_primary_gain_z);
ii_results.median_all_left_final_gain_z = median(ii_results.all_left_final_gain_z);

ii_results.std_all_left_srt = std(ii_results.all_left_srt);
ii_results.std_all_left_primary_err_z = std(ii_results.all_left_primary_err_z);
ii_results.std_all_left_final_err_z = std(ii_results.all_left_final_err_z);
ii_results.std_all_left_primary_gain_z = std(ii_results.all_left_primary_gain_z);
ii_results.std_all_left_final_gain_z = std(ii_results.all_left_final_gain_z);

% Right trials
ii_results.mean_all_right_srt = mean(ii_results.all_right_srt);
ii_results.mean_all_right_primary_err_z = mean(ii_results.all_right_primary_err_z);
ii_results.mean_all_right_final_err_z = mean(ii_results.all_right_final_err_z);
ii_results.mean_all_right_primary_gain_z = mean(ii_results.all_right_primary_gain_z);
ii_results.mean_all_right_final_gain_z = mean(ii_results.all_right_final_gain_z);

ii_results.median_all_right_srt = median(ii_results.all_right_srt);
ii_results.median_all_right_primary_err_z = median(ii_results.all_right_primary_err_z);
ii_results.median_all_right_final_err_z = median(ii_results.all_right_final_err_z);
ii_results.median_all_right_primary_gain_z = median(ii_results.all_right_primary_gain_z);
ii_results.median_all_right_final_gain_z = median(ii_results.all_right_final_gain_z);

ii_results.std_all_right_srt = std(ii_results.all_right_srt);
ii_results.std_all_right_primary_err_z = std(ii_results.all_right_primary_err_z);
ii_results.std_all_right_final_err_z = std(ii_results.all_right_final_err_z);
ii_results.std_all_right_primary_gain_z = std(ii_results.all_right_primary_gain_z);
ii_results.std_all_right_final_gain_z = std(ii_results.all_right_final_gain_z);


%%%%%%%%%%%%%%%%%%%%%%
% NO FIXATION BREAKS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%

% All trials
for i = 1:num_runs
    ii_stats(i).no_break_inds = find(ii_stats(i).no_break_mat==1); % Get good trials
    
    % Error
    ii_stats(i).no_break_primary_err_x = ii_stats(i).primary_err_x(ii_stats(i).no_break_inds);
    ii_stats(i).no_break_primary_err_y = ii_stats(i).primary_err_y(ii_stats(i).no_break_inds);
    ii_stats(i).no_break_primary_err_z = ii_stats(i).primary_err_z(ii_stats(i).no_break_inds);
    
    ii_stats(i).no_break_final_err_x = ii_stats(i).final_err_x(ii_stats(i).no_break_inds);
    ii_stats(i).no_break_final_err_y = ii_stats(i).final_err_y(ii_stats(i).no_break_inds);
    ii_stats(i).no_break_final_err_z = ii_stats(i).final_err_z(ii_stats(i).no_break_inds);
    
    % Gain
    ii_stats(i).no_break_primary_gain_x = ii_stats(i).primary_gain_x(ii_stats(i).no_break_inds);
    ii_stats(i).no_break_primary_gain_y = ii_stats(i).primary_gain_y(ii_stats(i).no_break_inds);
    ii_stats(i).no_break_primary_gain_z = ii_stats(i).primary_gain_z(ii_stats(i).no_break_inds);
    
    ii_stats(i).no_break_final_gain_x = ii_stats(i).final_gain_x(ii_stats(i).no_break_inds);
    ii_stats(i).no_break_final_gain_y = ii_stats(i).final_gain_y(ii_stats(i).no_break_inds);
    ii_stats(i).no_break_final_gain_z = ii_stats(i).final_gain_z(ii_stats(i).no_break_inds);
    
    % SRT
    ii_stats(i).no_break_srt = ii_stats(i).srt(ii_stats(i).no_break_inds);
end

% Left trials
for i = 1:num_runs
    ii_stats(i).no_break_left_inds = find(ii_stats(i).no_break_left_mat==1); % Get good trials
    
    % Error
    ii_stats(i).no_break_left_primary_err_x = ii_stats(i).primary_err_x(ii_stats(i).no_break_left_inds);
    ii_stats(i).no_break_left_primary_err_y = ii_stats(i).primary_err_y(ii_stats(i).no_break_left_inds);
    ii_stats(i).no_break_left_primary_err_z = ii_stats(i).primary_err_z(ii_stats(i).no_break_left_inds);
    
    ii_stats(i).no_break_left_final_err_x = ii_stats(i).final_err_x(ii_stats(i).no_break_left_inds);
    ii_stats(i).no_break_left_final_err_y = ii_stats(i).final_err_y(ii_stats(i).no_break_left_inds);
    ii_stats(i).no_break_left_final_err_z = ii_stats(i).final_err_z(ii_stats(i).no_break_left_inds);
    
    % Gain
    ii_stats(i).no_break_left_primary_gain_x = ii_stats(i).primary_gain_x(ii_stats(i).no_break_left_inds);
    ii_stats(i).no_break_left_primary_gain_y = ii_stats(i).primary_gain_y(ii_stats(i).no_break_left_inds);
    ii_stats(i).no_break_left_primary_gain_z = ii_stats(i).primary_gain_z(ii_stats(i).no_break_left_inds);
    
    ii_stats(i).no_break_left_final_gain_x = ii_stats(i).final_gain_x(ii_stats(i).no_break_left_inds);
    ii_stats(i).no_break_left_final_gain_y = ii_stats(i).final_gain_y(ii_stats(i).no_break_left_inds);
    ii_stats(i).no_break_left_final_gain_z = ii_stats(i).final_gain_z(ii_stats(i).no_break_left_inds);
    
    % SRT
    ii_stats(i).no_break_left_srt = ii_stats(i).srt(ii_stats(i).no_break_left_inds);
end

% Right trials
for i = 1:num_runs
    ii_stats(i).no_break_right_inds = find(ii_stats(i).no_break_right_mat==1); % Get good trials
    
    % Error
    ii_stats(i).no_break_right_primary_err_x = ii_stats(i).primary_err_x(ii_stats(i).no_break_right_inds);
    ii_stats(i).no_break_right_primary_err_y = ii_stats(i).primary_err_y(ii_stats(i).no_break_right_inds);
    ii_stats(i).no_break_right_primary_err_z = ii_stats(i).primary_err_z(ii_stats(i).no_break_right_inds);
    
    ii_stats(i).no_break_right_final_err_x = ii_stats(i).final_err_x(ii_stats(i).no_break_right_inds);
    ii_stats(i).no_break_right_final_err_y = ii_stats(i).final_err_y(ii_stats(i).no_break_right_inds);
    ii_stats(i).no_break_right_final_err_z = ii_stats(i).final_err_z(ii_stats(i).no_break_right_inds);
    
    % Gain
    ii_stats(i).no_break_right_primary_gain_x = ii_stats(i).primary_gain_x(ii_stats(i).no_break_right_inds);
    ii_stats(i).no_break_right_primary_gain_y = ii_stats(i).primary_gain_y(ii_stats(i).no_break_right_inds);
    ii_stats(i).no_break_right_primary_gain_z = ii_stats(i).primary_gain_z(ii_stats(i).no_break_right_inds);
    
    ii_stats(i).no_break_right_final_gain_x = ii_stats(i).final_gain_x(ii_stats(i).no_break_right_inds);
    ii_stats(i).no_break_right_final_gain_y = ii_stats(i).final_gain_y(ii_stats(i).no_break_right_inds);
    ii_stats(i).no_break_right_final_gain_z = ii_stats(i).final_gain_z(ii_stats(i).no_break_right_inds);
    
    % SRT
    ii_stats(i).no_break_right_srt = ii_stats(i).srt(ii_stats(i).no_break_right_inds);
end

% All trials
ii_results.no_break_primary_err_x = [];
ii_results.no_break_primary_err_y = [];
ii_results.no_break_primary_err_z = [];

ii_results.no_break_final_err_x = [];
ii_results.no_break_final_err_y = [];
ii_results.no_break_final_err_z = [];

ii_results.no_break_primary_gain_x = [];
ii_results.no_break_primary_gain_y = [];
ii_results.no_break_primary_gain_z = [];

ii_results.no_break_final_gain_x = [];
ii_results.no_break_final_gain_y = [];
ii_results.no_break_final_gain_z = [];

ii_results.no_break_srt = [];

% Left trials
ii_results.no_break_left_primary_err_x = [];
ii_results.no_break_left_primary_err_y = [];
ii_results.no_break_left_primary_err_z = [];

ii_results.no_break_left_final_err_x = [];
ii_results.no_break_left_final_err_y = [];
ii_results.no_break_left_final_err_z = [];

ii_results.no_break_left_primary_gain_x = [];
ii_results.no_break_left_primary_gain_y = [];
ii_results.no_break_left_primary_gain_z = [];

ii_results.no_break_left_final_gain_x = [];
ii_results.no_break_left_final_gain_y = [];
ii_results.no_break_left_final_gain_z = [];

ii_results.no_break_left_srt = [];

% Right trials
ii_results.no_break_right_primary_err_x = [];
ii_results.no_break_right_primary_err_y = [];
ii_results.no_break_right_primary_err_z = [];

ii_results.no_break_right_final_err_x = [];
ii_results.no_break_right_final_err_y = [];
ii_results.no_break_right_final_err_z = [];

ii_results.no_break_right_primary_gain_x = [];
ii_results.no_break_right_primary_gain_y = [];
ii_results.no_break_right_primary_gain_z = [];

ii_results.no_break_right_final_gain_x = [];
ii_results.no_break_right_final_gain_y = [];
ii_results.no_break_right_final_gain_z = [];

ii_results.no_break_right_srt = [];

% All trials
for j = 1:num_runs
    % Error
    ii_results.no_break_primary_err_x = [ii_results.no_break_primary_err_x; ii_stats(j).no_break_primary_err_x];
    ii_results.no_break_primary_err_y = [ii_results.no_break_primary_err_y; ii_stats(j).no_break_primary_err_y];
    ii_results.no_break_primary_err_z = [ii_results.no_break_primary_err_z; ii_stats(j).no_break_primary_err_z];

    ii_results.no_break_final_err_x = [ii_results.no_break_final_err_x; ii_stats(j).no_break_final_err_x];
    ii_results.no_break_final_err_y = [ii_results.no_break_final_err_y; ii_stats(j).no_break_final_err_y];
    ii_results.no_break_final_err_z = [ii_results.no_break_final_err_z; ii_stats(j).no_break_final_err_z];
    
    % Gain
    ii_results.no_break_primary_gain_x = [ii_results.no_break_primary_gain_x; ii_stats(j).no_break_primary_gain_x];
    ii_results.no_break_primary_gain_y = [ii_results.no_break_primary_gain_y; ii_stats(j).no_break_primary_gain_y];
    ii_results.no_break_primary_gain_z = [ii_results.no_break_primary_gain_z; ii_stats(j).no_break_primary_gain_z];
    
    ii_results.no_break_final_gain_x = [ii_results.no_break_final_gain_x; ii_stats(j).no_break_final_gain_x];
    ii_results.no_break_final_gain_y = [ii_results.no_break_final_gain_y; ii_stats(j).no_break_final_gain_y];
    ii_results.no_break_final_gain_z = [ii_results.no_break_final_gain_z; ii_stats(j).no_break_final_gain_z];
    
    % SRT    
    ii_results.no_break_srt = [ii_results.no_break_srt; ii_stats(j).no_break_srt];
end

% Left trials
for j = 1:num_runs
    % Error
    ii_results.no_break_left_primary_err_x = [ii_results.no_break_left_primary_err_x; ii_stats(j).no_break_left_primary_err_x];
    ii_results.no_break_left_primary_err_y = [ii_results.no_break_left_primary_err_y; ii_stats(j).no_break_left_primary_err_y];
    ii_results.no_break_left_primary_err_z = [ii_results.no_break_left_primary_err_z; ii_stats(j).no_break_left_primary_err_z];

    ii_results.no_break_left_final_err_x = [ii_results.no_break_left_final_err_x; ii_stats(j).no_break_left_final_err_x];
    ii_results.no_break_left_final_err_y = [ii_results.no_break_left_final_err_y; ii_stats(j).no_break_left_final_err_y];
    ii_results.no_break_left_final_err_z = [ii_results.no_break_left_final_err_z; ii_stats(j).no_break_left_final_err_z];
    
    % Gain
    ii_results.no_break_left_primary_gain_x = [ii_results.no_break_left_primary_gain_x; ii_stats(j).no_break_left_primary_gain_x];
    ii_results.no_break_left_primary_gain_y = [ii_results.no_break_left_primary_gain_y; ii_stats(j).no_break_left_primary_gain_y];
    ii_results.no_break_left_primary_gain_z = [ii_results.no_break_left_primary_gain_z; ii_stats(j).no_break_left_primary_gain_z];
    
    ii_results.no_break_left_final_gain_x = [ii_results.no_break_left_final_gain_x; ii_stats(j).no_break_left_final_gain_x];
    ii_results.no_break_left_final_gain_y = [ii_results.no_break_left_final_gain_y; ii_stats(j).no_break_left_final_gain_y];
    ii_results.no_break_left_final_gain_z = [ii_results.no_break_left_final_gain_z; ii_stats(j).no_break_left_final_gain_z];
    
    % SRT    
    ii_results.no_break_left_srt = [ii_results.no_break_left_srt; ii_stats(j).no_break_left_srt];
end

% Right trials
for j = 1:num_runs
    % Error
    ii_results.no_break_right_primary_err_x = [ii_results.no_break_right_primary_err_x; ii_stats(j).no_break_right_primary_err_x];
    ii_results.no_break_right_primary_err_y = [ii_results.no_break_right_primary_err_y; ii_stats(j).no_break_right_primary_err_y];
    ii_results.no_break_right_primary_err_z = [ii_results.no_break_right_primary_err_z; ii_stats(j).no_break_right_primary_err_z];

    ii_results.no_break_right_final_err_x = [ii_results.no_break_right_final_err_x; ii_stats(j).no_break_right_final_err_x];
    ii_results.no_break_right_final_err_y = [ii_results.no_break_right_final_err_y; ii_stats(j).no_break_right_final_err_y];
    ii_results.no_break_right_final_err_z = [ii_results.no_break_right_final_err_z; ii_stats(j).no_break_right_final_err_z];
    
    % Gain
    ii_results.no_break_right_primary_gain_x = [ii_results.no_break_right_primary_gain_x; ii_stats(j).no_break_right_primary_gain_x];
    ii_results.no_break_right_primary_gain_y = [ii_results.no_break_right_primary_gain_y; ii_stats(j).no_break_right_primary_gain_y];
    ii_results.no_break_right_primary_gain_z = [ii_results.no_break_right_primary_gain_z; ii_stats(j).no_break_right_primary_gain_z];
    
    ii_results.no_break_right_final_gain_x = [ii_results.no_break_right_final_gain_x; ii_stats(j).no_break_right_final_gain_x];
    ii_results.no_break_right_final_gain_y = [ii_results.no_break_right_final_gain_y; ii_stats(j).no_break_right_final_gain_y];
    ii_results.no_break_right_final_gain_z = [ii_results.no_break_right_final_gain_z; ii_stats(j).no_break_right_final_gain_z];
    
    % SRT    
    ii_results.no_break_right_srt = [ii_results.no_break_right_srt; ii_stats(j).no_break_right_srt];
end

% All trials
ii_results.mean_no_break_srt = mean(ii_results.no_break_srt);
ii_results.mean_no_break_primary_err_z = mean(ii_results.no_break_primary_err_z);
ii_results.mean_no_break_final_err_z = mean(ii_results.no_break_final_err_z);
ii_results.mean_no_break_primary_gain_z = mean(ii_results.no_break_primary_gain_z);
ii_results.mean_no_break_final_gain_z = mean(ii_results.no_break_final_gain_z);

ii_results.median_no_break_srt = median(ii_results.no_break_srt);
ii_results.median_no_break_primary_err_z = median(ii_results.no_break_primary_err_z);
ii_results.median_no_break_final_err_z = median(ii_results.no_break_final_err_z);
ii_results.median_no_break_primary_gain_z = median(ii_results.no_break_primary_gain_z);
ii_results.median_no_break_final_gain_z = median(ii_results.no_break_final_gain_z);

ii_results.std_no_break_srt = std(ii_results.no_break_srt);
ii_results.std_no_break_primary_err_z = std(ii_results.no_break_primary_err_z);
ii_results.std_no_break_final_err_z = std(ii_results.no_break_final_err_z);
ii_results.std_no_break_primary_gain_z = std(ii_results.no_break_primary_gain_z);
ii_results.std_no_break_final_gain_z = std(ii_results.no_break_final_gain_z);

% Left trials
ii_results.mean_no_break_left_srt = mean(ii_results.no_break_left_srt);
ii_results.mean_no_break_left_primary_err_z = mean(ii_results.no_break_left_primary_err_z);
ii_results.mean_no_break_left_final_err_z = mean(ii_results.no_break_left_final_err_z);
ii_results.mean_no_break_left_primary_gain_z = mean(ii_results.no_break_left_primary_gain_z);
ii_results.mean_no_break_left_final_gain_z = mean(ii_results.no_break_left_final_gain_z);

ii_results.median_no_break_left_srt = median(ii_results.no_break_left_srt);
ii_results.median_no_break_left_primary_err_z = median(ii_results.no_break_left_primary_err_z);
ii_results.median_no_break_left_final_err_z = median(ii_results.no_break_left_final_err_z);
ii_results.median_no_break_left_primary_gain_z = median(ii_results.no_break_left_primary_gain_z);
ii_results.median_no_break_left_final_gain_z = median(ii_results.no_break_left_final_gain_z);

ii_results.std_no_break_left_srt = std(ii_results.no_break_left_srt);
ii_results.std_no_break_left_primary_err_z = std(ii_results.no_break_left_primary_err_z);
ii_results.std_no_break_left_final_err_z = std(ii_results.no_break_left_final_err_z);
ii_results.std_no_break_left_primary_gain_z = std(ii_results.no_break_left_primary_gain_z);
ii_results.std_no_break_left_final_gain_z = std(ii_results.no_break_left_final_gain_z);

% Right trials
ii_results.mean_no_break_right_srt = mean(ii_results.no_break_right_srt);
ii_results.mean_no_break_right_primary_err_z = mean(ii_results.no_break_right_primary_err_z);
ii_results.mean_no_break_right_final_err_z = mean(ii_results.no_break_right_final_err_z);
ii_results.mean_no_break_right_primary_gain_z = mean(ii_results.no_break_right_primary_gain_z);
ii_results.mean_no_break_right_final_gain_z = mean(ii_results.no_break_right_final_gain_z);

ii_results.median_no_break_right_ssrt = median(ii_results.no_break_right_srt);
ii_results.median_no_break_right_primary_err_z = median(ii_results.no_break_right_primary_err_z);
ii_results.median_no_break_right_final_err_z = median(ii_results.no_break_right_final_err_z);
ii_results.median_no_break_right_primary_gain_z = median(ii_results.no_break_right_primary_gain_z);
ii_results.median_no_break_right_final_gain_z = median(ii_results.no_break_right_final_gain_z);

ii_results.std_no_break_right_srt = std(ii_results.no_break_right_srt);
ii_results.std_no_break_right_primary_err_z = std(ii_results.no_break_right_primary_err_z);
ii_results.std_no_break_right_final_err_z = std(ii_results.no_break_right_final_err_z);
ii_results.std_no_break_right_primary_gain_z = std(ii_results.no_break_right_primary_gain_z);
ii_results.std_no_break_right_final_gain_z = std(ii_results.no_break_right_final_gain_z);

%%%%%%%%%%%%%%%%%%%%%%%%
% FIXATION BREAKS ONLY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:num_runs
    ii_stats(i).only_break_inds = find(ii_stats(i).only_break_mat==1); % Get good trials
    
    % Error
    ii_stats(i).only_break_primary_err_x = ii_stats(i).primary_err_x(ii_stats(i).only_break_inds);
    ii_stats(i).only_break_primary_err_y = ii_stats(i).primary_err_y(ii_stats(i).only_break_inds);
    ii_stats(i).only_break_primary_err_z = ii_stats(i).primary_err_z(ii_stats(i).only_break_inds);
    
    ii_stats(i).only_break_final_err_x = ii_stats(i).final_err_x(ii_stats(i).only_break_inds);
    ii_stats(i).only_break_final_err_y = ii_stats(i).final_err_y(ii_stats(i).only_break_inds);
    ii_stats(i).only_break_final_err_z = ii_stats(i).final_err_z(ii_stats(i).only_break_inds);
    
    % Gain
    ii_stats(i).only_break_primary_gain_x = ii_stats(i).primary_gain_x(ii_stats(i).only_break_inds);
    ii_stats(i).only_break_primary_gain_y = ii_stats(i).primary_gain_y(ii_stats(i).only_break_inds);
    ii_stats(i).only_break_primary_gain_z = ii_stats(i).primary_gain_z(ii_stats(i).only_break_inds);
    
    ii_stats(i).only_break_final_gain_x = ii_stats(i).final_gain_x(ii_stats(i).only_break_inds);
    ii_stats(i).only_break_final_gain_y = ii_stats(i).final_gain_y(ii_stats(i).only_break_inds);
    ii_stats(i).only_break_final_gain_z = ii_stats(i).final_gain_z(ii_stats(i).only_break_inds);
    
    % SRT
    ii_stats(i).only_break_srt = ii_stats(i).srt(ii_stats(i).only_break_inds);
end

ii_results.only_break_primary_err_x = [];
ii_results.only_break_primary_err_y = [];
ii_results.only_break_primary_err_z = [];

ii_results.only_break_final_err_x = [];
ii_results.only_break_final_err_y = [];
ii_results.only_break_final_err_z = [];

ii_results.only_break_primary_gain_x = [];
ii_results.only_break_primary_gain_y = [];
ii_results.only_break_primary_gain_z = [];

ii_results.only_break_final_gain_x = [];
ii_results.only_break_final_gain_y = [];
ii_results.only_break_final_gain_z = [];

ii_results.only_break_srt = [];

for j = 1:num_runs
    % Error
    ii_results.only_break_primary_err_x = [ii_results.only_break_primary_err_x; ii_stats(j).only_break_primary_err_x];
    ii_results.only_break_primary_err_y = [ii_results.only_break_primary_err_y; ii_stats(j).only_break_primary_err_y];
    ii_results.only_break_primary_err_z = [ii_results.only_break_primary_err_z; ii_stats(j).only_break_primary_err_z];

    ii_results.only_break_final_err_x = [ii_results.only_break_final_err_x; ii_stats(j).only_break_final_err_x];
    ii_results.only_break_final_err_y = [ii_results.only_break_final_err_y; ii_stats(j).only_break_final_err_y];
    ii_results.only_break_final_err_z = [ii_results.only_break_final_err_z; ii_stats(j).only_break_final_err_z];
    
    % Gain
    ii_results.only_break_primary_gain_x = [ii_results.only_break_primary_gain_x; ii_stats(j).only_break_primary_gain_x];
    ii_results.only_break_primary_gain_y = [ii_results.only_break_primary_gain_y; ii_stats(j).only_break_primary_gain_y];
    ii_results.only_break_primary_gain_z = [ii_results.only_break_primary_gain_z; ii_stats(j).only_break_primary_gain_z];
    
    ii_results.only_break_final_gain_x = [ii_results.only_break_final_gain_x; ii_stats(j).only_break_final_gain_x];
    ii_results.only_break_final_gain_y = [ii_results.only_break_final_gain_y; ii_stats(j).only_break_final_gain_y];
    ii_results.only_break_final_gain_z = [ii_results.only_break_final_gain_z; ii_stats(j).only_break_final_gain_z];
    
    % SRT    
    ii_results.only_break_srt = [ii_results.only_break_srt; ii_stats(j).only_break_srt];
end

ii_results.mean_only_break_srt = mean(ii_results.only_break_srt);
ii_results.mean_only_break_primary_err_z = mean(ii_results.only_break_primary_err_z);
ii_results.mean_only_break_final_err_z = mean(ii_results.only_break_final_err_z);
ii_results.mean_only_break_primary_gain_z = mean(ii_results.only_break_primary_gain_z);
ii_results.mean_only_break_final_gain_z = mean(ii_results.only_break_final_gain_z);

ii_results.median_only_break_srt = median(ii_results.only_break_srt);
ii_results.median_only_break_primary_err_z = median(ii_results.only_break_primary_err_z);
ii_results.median_only_break_final_err_z = median(ii_results.only_break_final_err_z);
ii_results.median_only_break_primary_gain_z = median(ii_results.only_break_primary_gain_z);
ii_results.median_only_break_final_gain_z = median(ii_results.only_break_final_gain_z);

%%%%%%%%%%%%%%%%%%%%%%%%%
% SPLIT INTO HEMIFIELDS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%
% Create function to do this


%%%%%%%%%%%%%%%%%%%%%%%%
% SPLIT INTO QUADRANTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%
% Create function to do this


%%%%%%%%%%%%%%%%%%%%%%
% SHIT I WANT TO SEE %
%%%%%%%%%%%%%%%%%%%%%%

pie_nogo = 1+ii_results.num_trials - ii_results.num_nogo;
pie_bfix = 1+ii_results.num_bfix;
pie_else = 1+ii_results.num_trials - pie_bfix - pie_nogo;
pie_labels = {'nogo trials', 'fixation breaks', 'good trials'};

figure;
pie([pie_nogo, pie_bfix, pie_else]);
legend(pie_labels);

figure
subplot(3,2,1);
hist(ii_results.all_left_primary_err_z,50);
title(['Left error: ', num2str(ii_results.median_all_left_primary_err_z), ', STD: ', num2str(ii_results.std_all_left_primary_err_z)],'FontSize',14)

subplot(3,2,2);
hist(ii_results.all_right_primary_err_z,50);
title(['Right error: ', num2str(ii_results.median_all_right_primary_err_z), ', STD: ', num2str(ii_results.std_all_right_primary_err_z)],'FontSize',14)

subplot(3,2,3)
hist(ii_results.all_left_primary_gain_z,50);
title(['Left gain: ', num2str(ii_results.median_all_left_primary_gain_z), ', STD: ', num2str(ii_results.std_all_left_primary_gain_z)],'FontSize',14)

subplot(3,2,4)
hist(ii_results.all_right_primary_gain_z,50);
title(['Right gain: ', num2str(ii_results.median_all_right_primary_gain_z), ', STD: ', num2str(ii_results.std_all_right_primary_gain_z)],'FontSize',14)

subplot(3,2,5)
hist(ii_results.all_left_srt,50);
title(['Left SRT: ', num2str(ii_results.median_all_left_srt), ', STD: ', num2str(ii_results.std_all_left_srt)],'FontSize',14)

subplot(3,2,6)
hist(ii_results.all_right_srt,50);
title(['Right SRT: ', num2str(ii_results.median_all_right_srt), ', STD: ', num2str(ii_results.std_all_right_srt)],'FontSize',14)


% all_means = [ii_results.mean_all_primary_err_z ii_results.mean_all_primary_gain_z ii_results.mean_all_srt];
% no_break_means = [ii_results.mean_no_break_primary_err_z ii_results.mean_no_break_primary_gain_z ii_results.mean_no_break_srt];

% all_medians = [ii_results.median_all_primary_err_z ii_results.median_all_primary_gain_z ii_results.median_all_srt];
% no_break_medians = [ii_results.median_no_break_primary_err_z ii_results.median_no_break_primary_gain_z ii_results.median_no_break_srt];
% 
% putvar(all_medians,no_break_medians);

% controls.all_primary_err_z = [controls.all_primary_err_z; ii_results.all_primary_err_z];
% controls.all_primary_gain_z = [controls.all_primary_gain_z; ii_results.all_primary_gain_z];
% controls.all_srt = [controls.all_srt; ii_results.all_srt];
% 
% controls.no_break_primary_err_z = [controls.no_break_primary_err_z; ii_results.no_break_primary_err_z];
% controls.no_break_primary_gain_z = [controls.no_break_primary_gain_z; ii_results.no_break_primary_gain_z];
% controls.no_break_srt = [controls.no_break_srt; ii_results.no_break_srt];

% controls.all_primary_err_z = [];
% controls.all_primary_gain_z = [];
% controls.all_srt = [];
% 
% controls.no_break_primary_err_z = [];
% controls.no_break_primary_gain_z = [];
% controls.no_break_srt = [];
% 
% controls = evalin('base','controls');
% 
% [all_sigErr,all_pvalErr] = ttest2(controls.all_primary_err_z,ii_results.all_primary_err_z);
% [all_sigGain,all_pvalGain] = ttest2(controls.all_primary_gain_z,ii_results.all_primary_gain_z);
% [all_sigSRT,all_pvalSRT] = ttest2(controls.all_srt,ii_results.all_srt);
% 
% [no_break_sigErr,no_break_pvalErr] = ttest2(controls.no_break_primary_err_z,ii_results.no_break_primary_err_z);
% [no_break_sigGain,no_break_pvalGain] = ttest2(controls.no_break_primary_gain_z,ii_results.no_break_primary_gain_z);
% [no_break_sigSRT,no_break_pvalSRT] = ttest2(controls.no_break_srt,ii_results.no_break_srt);

% vgs_acc = [ii_stats_vgs(1).final_err_z; ii_stats_vgs(2).final_err_z; ii_stats_vgs(3).final_err_z];
% vgs_gain = [ii_stats_vgs(1).final_gain_z; ii_stats_vgs(2).final_gain_z; ii_stats_vgs(3).final_gain_z];

%%%%%%%%%%%%
% COHENS D %
%%%%%%%%%%%%
% % Calc SD
% mgs_num = (299)*(2.469^2);
% vgs_num = (299)*(0.523^2);
% snum = mgs_num+vgs_num;
% sdem = (299)+(299);
% efx = sqrt(snum/sdem);
% 
% % Calc FX SIZE
% x1 = 0.723;
% x2 = 0.951;
% s = 0.199;
% d = (x1-x2)/s;

% for i = 1:num_runs
%     raw_x = ii_stats(i).raw_x;
%     raw_y = ii_stats(i).raw_y;
%     [pX,fX,cX,pY,fY,cY] = ii_splitacc(raw_x,raw_y);
%     
%     [p_eX(:,i),p_eY(:,i),p_eZ(:,i),p_gX(:,i),p_gY(:,i),p_gZ(:,i)] = ii_calcerror_noabs(pX,cX,pY,cY);
%     [f_eX(:,i),f_eY(:,i),f_eZ(:,i),f_gX(:,i),f_gY(:,i),f_gZ(:,i)] = ii_calcerror_noabs(fX,cX,fY,cY);
% end
% 
% for i = 1:num_runs
%     l_mat(:,i) = ii_stats(i).left_mat .* ii_stats(i).nogo_mat;
%     r_mat(:,i) = ii_stats(i).right_mat .* ii_stats(i).nogo_mat;
% end
% 
% [l,r,l_all,r_all] = ii_splitbyhemi(p_eX,num_runs,l_mat,r_mat)

%%%%%%%%%%%%%%%
% STORE STUFF %
%%%%%%%%%%%%%%%

putvar(ii_stats,ii_results);
end
