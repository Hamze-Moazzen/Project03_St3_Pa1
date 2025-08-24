%% data preparation (to plot psychometric function)

clc
clear
close all

%% parameters

smax = 34; % number of subjects (participants)
axmax= 2;  % number of axis orientations (1: orthogonal, 2: oblique)
romax= 2;  % number of rotation conditions (1: no rotation, 2: 90-deg rotation)
rpmax= 4;  % number of repetitions per condition

inputdata = xlsread('RawData_Study3 (input).xlsx','TransitionData');

%% extract basic data

stimuli = [1:13];

% orthogonal axis ---------------------------------------------------------
ax = 1;

for s=1:smax % index for subjects
    for seq=1:2 % index for order sequence (1: ascending, 2: descending)
        Response_Horizontal{s,seq}=[];
        Response_Vertical{s,seq}=[];
        
        for ro=1:romax % index for rotation conditions (no rotation, 90-deg rotation)
            idx = find(inputdata(:,1)==s & inputdata(:,2)==ax & inputdata(:,3)==ro & inputdata(:,5)==seq);
            for i=1:length(idx) % index for idx counter
                row = idx(i);   % index for row number
                TP = inputdata(row,10); % transition point
                response = zeros(1,13);
                
                if ro==1 % without rotation (H-to-V)
                    response(stimuli>TP) = 1;
                    Response_Vertical{s,seq} = [Response_Vertical{s,seq}; response];
                elseif ro==2 % with 90-deg rotation (V-to-H)
                    response(stimuli>TP) = 1;
                    Response_Horizontal{s,seq} = [Response_Horizontal{s,seq}; response];
                end
            end
        end
    end
end

% oblique axis ------------------------------------------------------------
ax = 2;

for s=1:smax % index for subjects
    for seq=1:2 % index for order sequence (1: ascending, 2: descending)
        Response_45{s,seq}=[];
        Response_135{s,seq}=[];
        
        for ro=1:romax % index for rotation conditions (no rotation, 90-deg rotation)
            idx = find(inputdata(:,1)==s & inputdata(:,2)==ax & inputdata(:,3)==ro & inputdata(:,5)==seq);
            for i=1:length(idx) % index for idx counter
                row = idx(i);   % index for row number
                TP = inputdata(row,10); % transition point
                response = zeros(1,13);
                
                if ro==1 % without rotation (45-to-135)
                    response(stimuli>TP) = 1;
                    Response_135{s,seq} = [Response_135{s,seq}; response];
                elseif ro==2 % with 90-deg rotation (135-to-45)
                    response(stimuli>TP) = 1;
                    Response_45{s,seq} = [Response_45{s,seq}; response];
                end
            end
        end
    end
end

%% prepare output: orthogonal axis

% -------------------------------------------------------------------------
% without rotation: H-to-V transition -------------------------------------               
% for merged condition (ascending & descending):
Result_Vertical_all = [];
for s=1:smax % index for subjects
    for seq=1:2 % index for order sequence (1: ascending, 2: descending)
        Result_Vertical_all = [Result_Vertical_all; Response_Vertical{s,seq}];
    end
end

% for ascending condition:
Result_Vertical_asc = [];
for s=1:smax % index for subjects
    seq=1; % index for order sequence (1: ascending, 2: descending)
    Result_Vertical_asc = [Result_Vertical_asc; Response_Vertical{s,seq}];
end

% for descending condition:
Result_Vertical_desc = [];
for s=1:smax % index for subjects
    seq=2; % index for order sequence (1: ascending, 2: descending)
    Result_Vertical_desc = [Result_Vertical_desc; Response_Vertical{s,seq}];
end

% -------------------------------------------------------------------------
% with 90-deg rotation: V-to-H transition ---------------------------------
% for merged condition (ascending & descending):
Result_Horizontal_all = [];
for s=1:smax % index for subjects
    for seq=1:2 % index for order sequence (1: ascending, 2: descending)
        Result_Horizontal_all = [Result_Horizontal_all; Response_Horizontal{s,seq}];
    end
end

% for ascending condition:
Result_Horizontal_asc = [];
for s=1:smax % index for subjects
    seq=1; % index for order sequence (1: ascending, 2: descending)
    Result_Horizontal_asc = [Result_Horizontal_asc; Response_Horizontal{s,seq}];
end

% for descending condition:
Result_Horizontal_desc = [];
for s=1:smax % index for subjects
    seq=2; % index for order sequence (1: ascending, 2: descending)
    Result_Horizontal_desc = [Result_Horizontal_desc; Response_Horizontal{s,seq}];
end

%% prepare output: oblique axis

% -------------------------------------------------------------------------
% without rotation: 45-to-135 transition ----------------------------------
% for merged condition (ascending & descending):
Result_135_all = [];
for s=1:smax % index for subjects
    for seq=1:2 % index for order sequence (1: ascending, 2: descending)
        Result_135_all = [Result_135_all; Response_135{s,seq}];
    end
end

% for ascending condition:
Result_135_asc = [];
for s=1:smax % index for subjects
    seq=1; % index for order sequence (1: ascending, 2: descending)
    Result_135_asc = [Result_135_asc; Response_135{s,seq}];
end

% for descending condition:
Result_135_desc = [];
for s=1:smax % index for subjects
    seq=2; % index for order sequence (1: ascending, 2: descending)
    Result_135_desc = [Result_135_desc; Response_135{s,seq}];
end

% -------------------------------------------------------------------------
% without rotation: 135-to-45 transition ----------------------------------
% for merged condition (ascending & descending):
Result_45_all = [];
for s=1:smax % index for subjects
    for seq=1:2 % index for order sequence (1: ascending, 2: descending)
        Result_45_all = [Result_45_all; Response_45{s,seq}];
    end
end

% for ascending condition:
Result_45_asc = [];
for s=1:smax % index for subjects
    seq=1; % index for order sequence (1: ascending, 2: descending)
    Result_45_asc = [Result_45_asc; Response_45{s,seq}];
end

% for descending condition:
Result_45_desc = [];
for s=1:smax % index for subjects
    seq=2; % index for order sequence (1: ascending, 2: descending)
    Result_45_desc = [Result_45_desc; Response_45{s,seq}];
end

