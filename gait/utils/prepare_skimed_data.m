function T_skim = prepare_skimed_data(analVars, CL, flipMode)

%--------------------------------------------------------------------------
% Load Gait Data
%--------------------------------------------------------------------------
fprintf('    : Load and skim dataset\n');
XLSpath  = '/Users/skyeong/Google Drive/Manuscripts/Subgroup - Gait pattern/data';
fn_xls   = fullfile(XLSpath,'gait_final_dataset.xlsx');
T        = readtable(fn_xls);
T_skim   = skim_data(T, analVars, CL,  flipMode); % skimmed data
% skimData = table2array(T_skim);

