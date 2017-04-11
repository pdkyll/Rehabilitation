function data = parsing_temporospatial_domain(fn_excel, data)

[a,b,K] = xlsread(fn_excel,'TempSpat','K1:K31');
[a,b,D] = xlsread(fn_excel,'TempSpat','D1:D31');

% average of Rt and Lt
data.Cadence           = D{13}; % D13
data.Speed             = D{14}; % D14
data.StepWidth         = D{16}; % D16


% in measurement units
data.Cadence_L         = K{19}; % K19
data.Speed_L           = K{20}; % K20
data.StrideLength_cm_L = K{21}; % K21
data.StepLength_cm_L   = K{22}; % K22

data.Cadence_R         = D{19}; % D19
data.Speed_R           = D{20}; % D20
data.StrideLength_cm_R = D{21}; % D21
data.StepLength_cm_R   = D{22}; % D22


% in percent
data.SS_pct_L  = K{24};  % K24
data.IDS_pct_L = K{25};  % K25
data.TDS_pct_L = K{26};  % K26
data.ST_pct_L  = K{30};  % K30
data.SW_pct_L  = K{31};  % K31

data.SS_pct_R  = D{24};  % D24
data.IDS_pct_R = D{25};  % D25
data.TDS_pct_R = D{26};  % D26
data.ST_pct_R  = D{30};  % D30
data.SW_pct_R  = D{31};  % D31


% in time
data.StrideTime_L = K{23}*100/K{31}; % K23*100/K31
data.StepTime_L   = K{23};  % K23
data.SS_sec_L     = (K{23}*100/K{31})*K{24}/100;  %(K23*100/K31)*K24/100
data.IDS_sec_L    = (K{23}*100/K{31})*K{25}/100;  %(K23*100/K31)*K25/100
data.TDS_sec_L    = (K{23}*100/K{31})*K{26}/100;  %(K23*100/K31)*K26/100
data.ST_sec_L     = (K{23}*100/K{31})*K{30}/100; %(K23*100/K31)*K30/100
data.SW_sec_L     = K{23};  % K23

data.StrideTime_R = D{23}*100/D{31}; % D23*100/D31
data.StepTime_R   = D{23};  % D23
data.SS_sec_R     = (D{23}*100/D{31})*D{24}/100;  %(D23*100/D31)*D24/100
data.IDS_sec_R    = (D{23}*100/D{31})*D{25}/100;  %(D23*100/D31)*D25/100
data.TDS_sec_R    = (D{23}*100/D{31})*D{26}/100;  %(D23*100/D31)*D26/100
data.ST_sec_R     = (D{23}*100/D{31})*D{30}/100; %(D23*100/D31)*D30/100
data.SW_sec_R     = D{23};  % D23

