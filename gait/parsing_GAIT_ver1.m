function parsing_GAIT_ver1

testmode=0;
p = fileparts(which('parsing_GAIT_ver1'));
addpath(fullfile(p,'ver1'));
warning('off','all');

% Specify datapath
DATApath = '/Volumes/JetDrive/data/RM_kdh/TDA_data/excels/version1';


ID = [];
subj = struct();
cnt = 1;
failed_to_load = ''; fail_no=1;

% Running for YEAR of experiment
for y=2000:2012,
    
    % For test mode
    %     if testmode==1 && y~=2008, continue; end;
    
    if testmode==1 && y~=2000, continue; end;
    
    % Full directory of data
    folders = dir(fullfile(DATApath,num2str(y,'%d')));
    
    % Parsing excel files
    fprintf('Loading year-%d data...\n',y);
    
    % Running for sub-directory (i.e., diagnosis-directory)
    for i = 1:length(folders)
        Dx = folders(i).name;
        if strcmp(Dx(1),'.'), continue; end
        subdirs = dir(fullfile(DATApath,num2str(y,'%d'),Dx));
        
        % Running for each excel file
        for j=1:length(subdirs),
            excels = subdirs(j).name;
            if strcmp(excels(1),'.'), continue; end
            fn_xls = fullfile(DATApath,num2str(y,'%d'),Dx,excels);
            
            try
                [a,b,raw] = xlsread(fn_xls);
            catch
                failed_to_load{fail_no} = fn_xls;
                fail_no = fail_no + 1;
            end
            
            data = struct();
            
            % Get participant name (remove comma within a name)
            tmp = excels(1:end-4);
            tmp = strsplit(tmp,',');
            if length(tmp)>1,
                Name = sprintf('%s %s', char(tmp(1)), char(tmp(2)));
            else
                Name = char(tmp);
            end
            
            %if testmode==1 && ~strcmp(Name,'Choi kwangju62'), continue; end;
            if testmode==1 && ~strcmp(Name,'kim duckou-2'), continue; end;
            data.Name = Name;
            
            
            % Get diagnosis and year of GAIT experiment
            data.Diagnosis = lower(Dx);
            data.year      = y;
            
            
            % Get demographic information
            data = parsing_demographic(raw,data);
            ID   = [ID; data.ID];
            
            % Get temporal-domain values
            data = parsing_temporospatial_domain(raw,data);
            
            
            % Get Hip flexion/extension
            data = parsing_kinematic_for_hip(raw,data);
            
            
            % Get Knee flexion/extension
            data = parsing_kinematic_for_knee(raw,data);
            
            
            % Get Ankle flexion/extension
            data = parsing_kinematic_for_ankle(raw,data);
            
            
            % Get Hip flexion moment
            data = parsing_kinetic_for_hip(raw,data);
            
            
            % Get Knee flexion moment
            data = parsing_kinetic_for_knee(raw,data);
            
            
            % Get Ankle flexion moment
            data = parsing_kinetic_for_ankle(raw,data);
            
            
            subj(cnt).data = data;
            
            %if cnt > 20, break; end
            cnt = cnt+1;
        end  % for xls-file
    end % for subdirectory
end % for year

fprintf('\n');

% Print summary
uid = unique(ID);
fprintf('Total number of subjects: %d\n',length(ID));
fprintf('Total number of unique subjects: %d\n',length(uid));


% Specify output file name
[FileName,PathName] = uiputfile('*.csv','Pick an csv file');
fout = fullfile(PathName, FileName);


% Write results
fprintf('Writing results...\n');
[a,b,varname] = xlsread(fullfile(DATApath,'variable_names.xlsx'));
write_to_csvfile(fout,subj,varname);


fprintf('Done...\n');

