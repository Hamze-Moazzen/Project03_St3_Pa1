%% data preparation (to create "Processed Data" to use in statistical analysis)

clc
clear
close all

%% parameters

smax = 34; % number of subjects (participants)
axmax= 2;  % number of axis orientations (1: orthogonal, 2: oblique)
romax= 2;  % number of rotation conditions (1: no rotation, 2: 90-deg rotation)
rpmax= 4;  % number of repetitions per condition

inputdata = xlsread('RawData_Study3 (input).xlsx','TransitionData');

%% ########################################################################
%% #########################  Extract Variables  ##########################
%% ########################################################################

%% basic variables

for s=1:smax % index for subjects
    for ax=1:axmax % index for axis orientations (orthogonal, oblique)
        for ro=1:romax % index for rotation conditions (no rotation, 90-deg rotation)
            
            alpha1_scaled_ro(ro) = 0;
            alpha2_scaled_ro(ro) = 0;
            
            % --------------------------------------------------------+@@@@@@@@@@@@@@@ for Excel input file @@@@@@@@@@@@@@@
            % transition points by stimulus numbers:
            idx1 = find((inputdata(:,1)==s) & (inputdata(:,2)==ax) & (inputdata(:,3)==ro) & (inputdata(:,5)==2));
            idx2 = find((inputdata(:,1)==s) & (inputdata(:,2)==ax) & (inputdata(:,3)==ro) & (inputdata(:,5)==1));
            
            alpha1_StimulusNo_rp = inputdata(idx1,10); % descending sequences (in units of index)
            alpha2_StimulusNo_rp = inputdata(idx2,10); % ascending  sequences (in units of index)
            
            alpha1_StimulusNo = mean(alpha1_StimulusNo_rp);
            alpha2_StimulusNo = mean(alpha2_StimulusNo_rp);
            
            % transition points by ARs:
            alpha1_AR_rp = inputdata(idx1,13); % descending sequences (in units of index)
            alpha2_AR_rp = inputdata(idx2,13); % ascending  sequences (in units of index)
            
            alpha1_AR = mean(alpha1_AR_rp);
            alpha2_AR = mean(alpha2_AR_rp);
            % ---------------------------------------------------------@@@@@@@@@@@@@@@ for Excel input file @@@@@@@@@@@@@@@
            
            % basic variables (in terms of Stimulus Number):
            Result.Original.ByStimulus.Alpha1_des{ax,ro}(s,1) = alpha1_StimulusNo; % transition point of descending sequence
            Result.Original.ByStimulus.Alpha2_asc{ax,ro}(s,1) = alpha2_StimulusNo; % transition point of ascending  sequence
            
            Result.Original.ByStimulus.PSE{ax,ro}(s,1) = (alpha2_StimulusNo+alpha1_StimulusNo)/2; % point of subjective equality (PSE)
            Result.Original.ByStimulus.Hys{ax,ro}(s,1) = (alpha2_StimulusNo-alpha1_StimulusNo);   % Hysteresis
            
            % basic variables (in terms of AR):
            Result.Original.ByAR.Alpha1_des{ax,ro}(s,1) = alpha1_AR; % transition point of descending sequence
            Result.Original.ByAR.Alpha2_asc{ax,ro}(s,1) = alpha2_AR; % transition point of ascending  sequence
            
            Result.Original.ByAR.PSE{ax,ro}(s,1) = (alpha2_AR+alpha1_AR)/2; % point of subjective equality (PSE)
            Result.Original.ByAR.Hys{ax,ro}(s,1) = (alpha2_AR-alpha1_AR);   % Hysteresis
            
            % scaled transition points:
            if ro==1
                alpha1_scaled_ro(ro) = 1-(alpha1_StimulusNo-1)/(13-1);
                alpha2_scaled_ro(ro) = 1-(alpha2_StimulusNo-1)/(13-1);
            elseif ro==2
                alpha1_scaled_ro(ro) = (alpha1_StimulusNo-1)/(13-1);
                alpha2_scaled_ro(ro) = (alpha2_StimulusNo-1)/(13-1);
            end
            hysteresis_ro(ro) = Result.Original.ByStimulus.Hys{ax,ro}(s,1);
        end
        
        % model parameters [Lotka–Volterra–Haken amplitude equation model]:
        alpha1_scaled = mean([alpha2_scaled_ro(1),alpha1_scaled_ro(2)]);
        alpha2_scaled = mean([alpha1_scaled_ro(1),alpha2_scaled_ro(2)]);

        Result.Original.ModelParams.Alpha1{ax,1}(s,1) = alpha1_scaled;  % average alpha1 (descending) [scaled]
        Result.Original.ModelParams.Alpha2{ax,1}(s,1) = alpha2_scaled;  % average alpha2 (ascending)  [scaled]
    end
end

% outlier treatment -------------------------------------------------------
% no need for outlier treatment:
Result.OutlierChecked.ByStimulus.Alpha1_des = Result.Original.ByStimulus.Alpha1_des;
Result.OutlierChecked.ByStimulus.Alpha2_asc = Result.Original.ByStimulus.Alpha2_asc;

Result.OutlierChecked.ByAR.Alpha1_des = Result.Original.ByAR.Alpha1_des;
Result.OutlierChecked.ByAR.Alpha2_asc = Result.Original.ByAR.Alpha2_asc;

% need for outlier treatment:
for ax=1:axmax % index for axis orientations (orthogonal, oblique)
    for ro=1:romax % index for rotation conditions (no rotation, 90-deg rotation)
        Result.OutlierChecked.ByStimulus.PSE{ax,ro}(:,1) = OutlierTreatment(Result.Original.ByStimulus.PSE{ax,ro}(:,1));
        Result.OutlierChecked.ByStimulus.Hys{ax,ro}(:,1) = OutlierTreatment(Result.Original.ByStimulus.Hys{ax,ro}(:,1));
        
        Result.OutlierChecked.ByAR.PSE{ax,ro}(:,1) = OutlierTreatment(Result.Original.ByAR.PSE{ax,ro}(:,1));
        Result.OutlierChecked.ByAR.Hys{ax,ro}(:,1) = OutlierTreatment(Result.Original.ByAR.Hys{ax,ro}(:,1));
    end
end

%% model parameters (Lotka–Volterra–Haken amplitude equation model)

for s=1:smax % index for subjects
    for ax=1:axmax % index for axis orientations (orthogonal, oblique)
        alpha1_scaled = Result.Original.ModelParams.Alpha1{ax,1}(s,1); % average alpha1 (descending) [scaled]
        alpha2_scaled = Result.Original.ModelParams.Alpha2{ax,1}(s,1); % average alpha2 (ascending)  [scaled]
        
        tmp_Gamma = (alpha1_scaled*alpha2_scaled)/((1-alpha1_scaled)*(1-alpha2_scaled));
        tmp_G     = (alpha1_scaled/alpha2_scaled)*((1-alpha1_scaled)/(1-alpha2_scaled));
        
        Result.Original.ModelParams.Gamma{ax,1}(s,1) = sqrt(tmp_Gamma);     % preference parameter
        Result.Original.ModelParams.G{ax,1}(s,1)     = sqrt(tmp_G);         % the degree of mutual inhibition
        
        tmp_Hys = zeros(1,romax);
        for ro=1:romax % index for rotation conditions (no rotation, 90-deg rotation)
            tmp_Hys(ro) = Result.OutlierChecked.ByStimulus.Hys{ax,ro}(s);
        end
        Result.Original.ModelParams.Hys{ax,1}(s,1) = mean(tmp_Hys); % average hysteresis (SN)
    end
end

% outlier treatment -------------------------------------------------------
% no need for outlier treatment:
Result.OutlierChecked.ModelParams.Alpha1 = Result.Original.ModelParams.Alpha1;
Result.OutlierChecked.ModelParams.Alpha2 = Result.Original.ModelParams.Alpha2;
Result.OutlierChecked.ModelParams.Hys    = Result.Original.ModelParams.Hys;

% need for outlier treatment:
for ax=1:axmax % index for axis orientations (orthogonal, oblique)
    Result.OutlierChecked.ModelParams.Gamma{ax,1}(:,1) = OutlierTreatment(Result.Original.ModelParams.Gamma{ax,1}(:,1));
    Result.OutlierChecked.ModelParams.G{ax,1}(:,1)     = OutlierTreatment(Result.Original.ModelParams.G{ax,1}(:,1));
end

%% ########################################################################
%% ######################  Reformat the Results  ##########################
%% ########################################################################

%% original values

% basic vars --------------------------------------------------------------
n = 0;

for s=1:smax % index for subjects
    for ax=1:axmax % index for axis orientations (orthogonal, oblique)
        for ro=1:romax % index for rotation conditions (no rotation, 90-deg rotation)
            n = n+1;
            Result_BasicVars.Original(n,1) = s;  % subject No.            
            Result_BasicVars.Original(n,2) = ax; % axis orientation (1:orthogonal, 2:oblique)
            Result_BasicVars.Original(n,3) = ro; % rotation conditions (1: no rotation, 2: 90-deg rotation)
            
            % in terms of stimulus number (SN):
            Result_BasicVars.Original(n,4) = Result.Original.ByStimulus.Alpha1_des{ax,ro}(s,1); % alpha1: descending transition point [SN]
            Result_BasicVars.Original(n,5) = Result.Original.ByStimulus.Alpha2_asc{ax,ro}(s,1); % alpha2: ascending transition point [SN]
            
            Result_BasicVars.Original(n,6) = Result.Original.ByStimulus.PSE{ax,ro}(s,1); % PSE: point of subjective equality [SN]
            Result_BasicVars.Original(n,7) = Result.Original.ByStimulus.Hys{ax,ro}(s,1); % Hysteresis [SN]
            
            % in terms of AR:
            Result_BasicVars.Original(n,8) = Result.Original.ByAR.Alpha1_des{ax,ro}(s,1); % alpha1: descending transition point [AR]
            Result_BasicVars.Original(n,9) = Result.Original.ByAR.Alpha2_asc{ax,ro}(s,1); % alpha2: ascending transition point [AR]
            
            Result_BasicVars.Original(n,10) = Result.Original.ByAR.PSE{ax,ro}(s,1); % PSE: point of subjective equality [AR]
            Result_BasicVars.Original(n,11) = Result.Original.ByAR.Hys{ax,ro}(s,1); % Hysteresis [AR]
        end
    end
end

% model params ------------------------------------------------------------
n = 0;

for s=1:smax % index for subjects
    for ax=1:axmax % index for axis orientations (orthogonal, oblique)
        n = n+1;
        Result_ModelParams.Original(n,1) = s;  % subject No.
        Result_ModelParams.Original(n,2) = ax; % axis orientation (1:orthogonal, 2:oblique)
        
        % model parameters:
        Result_ModelParams.Original(n,3) = Result.Original.ModelParams.Gamma{ax,1}(s,1);  % gamma: preference parameter
        Result_ModelParams.Original(n,4) = Result.Original.ModelParams.G{ax,1}(s,1);      % g: mutual inhibition parameter
        Result_ModelParams.Original(n,5) = Result.Original.ModelParams.Hys{ax,1}(s,1);    % average hysteresis [SN]
        Result_ModelParams.Original(n,6) = Result.Original.ModelParams.Alpha1{ax,1}(s,1); % average alpha1 (descending) [scaled]
        Result_ModelParams.Original(n,7) = Result.Original.ModelParams.Alpha2{ax,1}(s,1); % average alpha2 (ascending)  [scaled]
    end
end

%% after outlier treatment

% basic vars --------------------------------------------------------------
n = 0;

for s=1:smax % index for subjects
    for ax=1:axmax % index for axis orientations (orthogonal, oblique)
        for ro=1:romax % index for rotation conditions (no rotation, 90-deg rotation)
            n = n+1;
            Result_BasicVars.OutlierChecked(n,1) = s;  % subject No.            
            Result_BasicVars.OutlierChecked(n,2) = ax; % axis orientation (1:orthogonal, 2:oblique)
            Result_BasicVars.OutlierChecked(n,3) = ro; % rotation conditions (1: no rotation, 2: 90-deg rotation)
            
            % in terms of stimulus number (SN):
            Result_BasicVars.OutlierChecked(n,4) = Result.OutlierChecked.ByStimulus.Alpha1_des{ax,ro}(s,1); % alpha1: descending transition point [SN]
            Result_BasicVars.OutlierChecked(n,5) = Result.OutlierChecked.ByStimulus.Alpha2_asc{ax,ro}(s,1); % alpha2: ascending transition point [SN]
            
            Result_BasicVars.OutlierChecked(n,6) = Result.OutlierChecked.ByStimulus.PSE{ax,ro}(s,1); % PSE: point of subjective equality [SN]
            Result_BasicVars.OutlierChecked(n,7) = Result.OutlierChecked.ByStimulus.Hys{ax,ro}(s,1); % Hysteresis [SN]
            
            % in terms of AR:
            Result_BasicVars.OutlierChecked(n,8) = Result.OutlierChecked.ByAR.Alpha1_des{ax,ro}(s,1); % alpha1: descending transition point [AR]
            Result_BasicVars.OutlierChecked(n,9) = Result.OutlierChecked.ByAR.Alpha2_asc{ax,ro}(s,1); % alpha2: ascending transition point [AR]
            
            Result_BasicVars.OutlierChecked(n,10) = Result.OutlierChecked.ByAR.PSE{ax,ro}(s,1); % PSE: point of subjective equality [AR]
            Result_BasicVars.OutlierChecked(n,11) = Result.OutlierChecked.ByAR.Hys{ax,ro}(s,1); % Hysteresis [AR]
        end
    end
end

% model params ------------------------------------------------------------
n = 0;

for s=1:smax % index for subjects
    for ax=1:axmax % index for axis orientations (orthogonal, oblique)
        n = n+1;
        Result_ModelParams.OutlierChecked(n,1) = s;  % subject No.
        Result_ModelParams.OutlierChecked(n,2) = ax; % axis orientation (1:orthogonal, 2:oblique)
        
        % model parameters:
        Result_ModelParams.OutlierChecked(n,3) = Result.OutlierChecked.ModelParams.Gamma{ax,1}(s,1);  % gamma: preference parameter
        Result_ModelParams.OutlierChecked(n,4) = Result.OutlierChecked.ModelParams.G{ax,1}(s,1);      % g: mutual inhibition parameter        
        Result_ModelParams.OutlierChecked(n,5) = Result.OutlierChecked.ModelParams.Hys{ax,1}(s,1);    % average hysteresis [SN]
        Result_ModelParams.OutlierChecked(n,6) = Result.OutlierChecked.ModelParams.Alpha1{ax,1}(s,1); % average alpha1 (descending) [scaled]
        Result_ModelParams.OutlierChecked(n,7) = Result.OutlierChecked.ModelParams.Alpha2{ax,1}(s,1); % average alpha2 (ascending)  [scaled]
    end
end

%% ########################################################################
%% ###########################  Save Outputs  #############################
%% ########################################################################

%% matlab save

save('ProcessedData_Study3 new.mat','Result','Result_BasicVars','Result_ModelParams');

%% excel save (Original results)

col_header1 = {'subject No.', 'axis orientation (1:orthogonal, 2:oblique)', 'rotation condition (1: 0-deg, 2: 90-deg)', ... % 1-3
    'alpha1: descending transition point [SN]', 'alpha2: ascending transition point [SN]', 'PSE: point of subjective equality [SN]', ... % 4-6
    'Hysteresis [SN]', 'alpha1: descending transition point [AR]', 'alpha2: ascending transition point [AR]', ... % 7-9
    'PSE: point of subjective equality [AR]', 'Hysteresis [AR]'}; % 10-11

xlswrite('ProcessedData_Study3_OriginalValues new.xlsx', col_header1, 'BasicVars', 'A1')
xlswrite('ProcessedData_Study3_OriginalValues new.xlsx', Result_BasicVars.Original, 'BasicVars', 'A2')

%--------------------------------------------------------------------------
col_header2 = {'subject No.', 'axis orientation (1:orthogonal, 2:oblique)', 'gamma: preference parameter', ... % 1-3
    'g: mutual inhibition parameter', 'average hysteresis [SN]', 'scaled alpha1 (descending)', 'scaled alpha2 (ascending)'}; % 4-7

xlswrite('ProcessedData_Study3_OriginalValues new.xlsx', col_header2, 'ModelParams', 'A1')
xlswrite('ProcessedData_Study3_OriginalValues new.xlsx', Result_ModelParams.Original, 'ModelParams', 'A2')

%% excel save (OutlierChecked results)

xlswrite('ProcessedData_Study3_OutlierChecked new.xlsx', col_header1, 'BasicVars', 'A1')
xlswrite('ProcessedData_Study3_OutlierChecked new.xlsx', Result_BasicVars.OutlierChecked, 'BasicVars', 'A2')

%--------------------------------------------------------------------------
xlswrite('ProcessedData_Study3_OutlierChecked new.xlsx', col_header2, 'ModelParams', 'A1')
xlswrite('ProcessedData_Study3_OutlierChecked new.xlsx', Result_ModelParams.OutlierChecked, 'ModelParams', 'A2')

