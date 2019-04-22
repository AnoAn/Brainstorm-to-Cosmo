cd 'C:\Users\tizia\Documents\MATLAB\S3_epochs'
cd 'C:\Users\tizia\Documents\MATLAB'

files=dir('*.mat');
files.name
files = files([1:(length(files)-1)])
files.name
%xx = in_bst_data(sFiles(1))
%xyz = load(files(2).name)

%[zxzx.grad] = zxzx.elec;
%zxzx = rmfield(zxzx,'elec');
%disp(zxzx)

real = load(files(1).name)
%file1 = cosmo_meeg_dataset(files(1).name)
%file1.samples = real.avg
datasets{1} = real.avg
for iFile=2:length(files)
    %datasets{iFile}=file1;
    temp = load(files(iFile).name);
    %datasets = {datasets,temp.F};
    datasets{iFile} = temp.F;
end
ds0 = cat(3,datasets{:});
ds0 = permute(ds0, [3 1 2]);
%ds0=cosmo_stack(datasets,1,'drop_nonunique')

save out.mat ds0



% Example script showing importing BrainStorm M/EEG time-locked data into
% CoSMoMVPA.
%
% The result is a CoSMoMVPA dataset structure 'ds'
%
% NNO Sep 2017
%
% Input data:
%   '195_trial001.mat' : contains data in FieldTrip timelock struct format,
%                        with data from a single trial, for 701 time points
%                        and 319 channels
%
%                             template_trial =
%
%                                 dimord: 'chan_time'
%                                    avg: [319x701 double]
%                                   time: [1x701 double]
%                                  label: {319x1 cell}
%                                   grad: [1x1 struct]
%
%   'out.mat'          : 3D array of size 180 x 319 x 701
%                           180 trials, 90 of condition A followed by
%                                       90 of condition B
%                           319 channels
%                           701 time points
%
% Indices of the trial conditions
% - the first 90 trials are condition A
% - the nextt 90 trials are condition B
trials_condA=1:18;
trials_condB=19:36;

% load all data
all_data=importdata('out.mat');

% get template trial
template_trial=load(files(1).name);

% set trial condition in a vector
targets=NaN(numel(trials_condA)+numel(trials_condA),1);
targets(trials_condA)=1;
targets(trials_condB)=2;

% count number of trials
n_trials=numel(targets);

% just verify that trial count matches
assert(numel(targets)==size(all_data,1),'trial count mismatch');

% allocate space for output
ds_cell=cell(n_trials,1);

% convert each trial
for k=1:n_trials
    % make a copy from the template
    trial=template_trial;

    % take data from trial
    trial.avg(:,:)=squeeze(all_data(k,:,:));

    % convert to CoSMo struct
    ds_trial=cosmo_meeg_dataset(trial);

    % all trials are assumed to be independent
    ds_trial.sa.chunks=k;

    % set condition
    ds_trial.sa.targets=targets(k);

    % since we are merging trials, this is not an average anymore
    % (this is a bit of a hack since we're not really importing from
    % FieldTrip, but BrainStorm sets (arguablye misleading) the single
    % trial data as if it is an average)
    ds_trial.a.meeg=rmfield(ds_trial.a.meeg,'samples_field');

    % store dataset
    ds_cell{k}=ds_trial;
end

% merge all trials into a big dataset
ds_tl=cosmo_stack(ds_cell);