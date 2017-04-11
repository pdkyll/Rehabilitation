function data = parsing_temporospatial_domain(raw, data)

hdr = raw(1,:);
dat = raw(2:end,:);

% average of Rt and Lt
data.Cadence           = (cell2mat(dat(46,3))+cell2mat(dat(46,4)))/2;
data.Speed             = 100*(cell2mat(dat(47,3))+cell2mat(dat(47,4)))/2;
data.StepWidth         = NaN;

% left
data.Cadence_L         = cell2mat(dat(46,3));      %C47;
data.Speed_L           = cell2mat(dat(47,3))*100;  %C48 in cm/s;
data.StrideLength_cm_L = cell2mat(dat(52,3))*100;  %C53 in cm;
data.StepLength_cm_L   = cell2mat(dat(53,3))*100;  %C54 in cm;

% right
data.Cadence_R         = cell2mat(dat(46,4));      %D47;
data.Speed_R           = cell2mat(dat(47,4))*100;  %D48 in cm/s;
data.StrideLength_cm_R = cell2mat(dat(52,4))*100;  %D53 in cm;
data.StepLength_cm_R   = cell2mat(dat(53,4))*100;  %D54 in cm;


ka  = find_column_number(hdr,'Params A');
AK7 = cell2mat(dat(6,ka)); 
AK8 = cell2mat(dat(7,ka)); 
AK9 = cell2mat(dat(8,ka)); 

kb  = find_column_number(hdr,'Params B');
BS7 = cell2mat(dat(6,kb));
BS8 = cell2mat(dat(7,kb));
BS9 = cell2mat(dat(8,kb));


C49 = cell2mat(dat(48,3)); D49 = cell2mat(dat(48,4));
C50 = cell2mat(dat(49,3)); D50 = cell2mat(dat(49,4));
C51 = cell2mat(dat(50,3)); D51 = cell2mat(dat(50,4));


% in percent
data.SS_pct_L  = 100*C51/C49;  % in pct
data.IDS_pct_L = AK7;
data.TDS_pct_L = AK9-AK8;
data.ST_pct_L  = AK9;
data.SW_pct_L  = 100-AK9;

data.SS_pct_R  = 100*D51/D49;  % in pct
data.IDS_pct_R = BS7;
data.TDS_pct_R = BS9-BS8;
data.ST_pct_R  = BS9;
data.SW_pct_R  = 100-BS9;


% in time
data.StrideTime_L = C49;
data.StepTime_L   = C50;
data.SS_sec_L     = C51;
data.IDS_sec_L    = AK7*C49/100;
data.TDS_sec_L    = C49*(AK9-AK8)/100;
data.ST_sec_L     = C49-C50;
data.SW_sec_L     = C49*(100-AK9)/100;

data.StrideTime_R = D49;
data.StepTime_R   = D50;
data.SS_sec_R     = D51;
data.IDS_sec_R    = BS7*D49/100;
data.TDS_sec_R    = D49*(BS9-BS8)/100;
data.ST_sec_R     = D49-D50;
data.SW_sec_R     = D49*(100-BS9)/100;

