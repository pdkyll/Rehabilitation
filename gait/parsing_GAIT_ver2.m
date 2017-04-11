function parsing_GAIT_ver2

p = fileparts(which('parsing_GAIT_ver2'));
addpath(fullfile(p,'ver2'));
warning('off','all');

% Specify datapath
DATApath = '/Volumes/JetDrive/data/RM_kdh/TDA_data/excels/version2';


ID = [];
subj = struct();
cnt = 1;
failed_to_load = ''; fail_no=1;

% Running for YEAR of experiment
for y=2016:2016,
    folders = dir(fullfile(DATApath,num2str(y,'%d')));
    
    % Parsing excel files
    fprintf('Loading year-%d data...\n',y);
    
    % Running for sub-directory (i.e., diagnosis-directory)
    for i = 1:length(folders)
        dirname = folders(i).name;
        if strcmp(dirname(1),'.'), continue; end
        
        % Parsing directory name
        data = struct();
        data.year = y;
        data = parsing_folder_name(dirname,data);
        
        % Load excel file
        fn_excel = dir(fullfile(DATApath,num2str(y),dirname,'*.xlsx'));
        fn_excel = fullfile(DATApath,num2str(y),dirname,fn_excel.name);
        
        
        % Get demographic information
        data = parsing_demographic(fn_excel,data);
        ID   = [ID; data.ID];
        
        
        % Get temporal-domain values
        data = parsing_temporospatial_domain(fn_excel,data);
        
        
        % Load Dataset From Excel file
        [a,b,list_fields] = xlsread(fn_excel,'Sheet1','A1:A5000');
        [a,b,E]           = xlsread(fn_excel,'Sheet1','E1:E5000');
        
        
        
        % Get Hip data
        data = parsing_kinematic_for_hip(data,list_fields,E);
        
        
        % Get Knee data
        data = parsing_kinematic_for_knee(data,list_fields,E);
        
        
        % Get Ankle data
        data = parsing_kinematic_for_ankle(data,list_fields,E);
        
        
        % Get Hip flexion moment
        data = parsing_kinetic_for_hip(data,list_fields,E);
        
        
        % Get Knee flexion moment
        data = parsing_kinetic_for_knee(data, list_fields, E);
        
        
        % Get Ankle flexion moment
        data = parsing_kinetic_for_ankle(data, list_fields, E);
        
        
        subj(cnt).data = data;
        
        cnt = cnt+1;
        %if cnt>10, break; end
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

