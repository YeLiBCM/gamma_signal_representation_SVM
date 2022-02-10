% This code extracts task epochs
% sbj_name : subject code of each patient
% block_name : the code of task block
% project_name: task name
% ref_type: re-referencing method used

% the code should be modified based on how the data is saved and the method
% you used to preprocess the data

function extract_epoch(sbj_name, block_name, project_name, ref_type)

% load master variables
load(sprintf('~/Documents/MATLAB/ECoG/neuralData/originalData/%s/master_%s_%s_%s.mat'...
    ,sbj_name, project_name, sbj_name, block_name));

% load events file
load(sprintf('%s/task_events_%s_%s_%s.mat',...
    master_vars.result_dir, project_name, sbj_name, block_name));


%% Define epoch windows
% sample rate - tf amplitude data is downsampledn in decomposition.
tf_srate         = round(master_vars.ecog_srate/master_vars.compress);
% wide for epoching
epoch_prestim    = floor(1.0*tf_srate);
epoch_poststim   = ceil(1.0*tf_srate);
epoch_norm = floor(epoch_prestim/2);
% window for average
epoch_mean_start = floor(0.25*tf_srate);
epoch_mean_end   = ceil(0.5*tf_srate);
%downsample/correct onset/offset times.
trial_onsets     = round(events_info.trial_onset./master_vars.compress);
trial_offsets    = round(events_info.trial_offset./master_vars.compress);


epoch_trigger    = trial_onsets;

%% get trials info
trials_orientation_0  = events_info.trial_orientation == 0;
trials_orientation_90 = events_info.trial_orientation == 90;
odd_trials            = events_info.trial_orientation == 45;

% remove odd trials
trials_orientation_0(odd_trials)  = [];
trials_orientation_90(odd_trials) = [];

label_vect = trials_orientation_0.*1 + trials_orientation_90.*2;

%% all VEP response electrods
load(sprintf('%s/%s%s_analysis_params.mat',master_vars.result_dir, sbj_name, block_name));
elecs = setxor([1:master_vars.nchan],[master_vars.badchan,master_vars.refchan,master_vars.epichan]);

%% epoch data
for ci = elecs
    load(sprintf('%s/TF_decomp_%s_%s_%s_%.d',...
        master_vars.Spec_dir, ref_type, master_vars.sbj_name, block_name, ci));
    tf_epochs = [];
    
    for epoch_i = 1:length(epoch_trigger)
        
        % ~~~extract epoch
        tf_tmp_epoch = [];
        tf_tmp_epoch = band.tf_data.amplitude(:,epoch_trigger(epoch_i)-epoch_prestim:epoch_trigger(epoch_i)+epoch_poststim);
        
        % ~~~norm epoch (based on the time window 500 ms before the
        % stimulus onset)
        norm_vect    = mean(tf_tmp_epoch(:,epoch_prestim-epoch_norm:epoch_prestim),2);
        tf_tmp_epoch = bsxfun(@rdivide, tf_tmp_epoch, norm_vect);
        tf_tmp_epoch = (tf_tmp_epoch.*100)-100;
        
        % add normalized epoch to matrix
        tf_epochs(:,:,epoch_i) = tf_tmp_epoch;
    end
    % remove odd trials
    tf_epochs(:,:,odd_trials) = [];
    tf_epochs = tf_epochs(:,epoch_prestim+epoch_mean_start:epoch_prestim+epoch_mean_end,:);
    save(['tf_epochs_' sbj_name '_' block_name '_' num2str(ci)],'tf_epochs')
end
end