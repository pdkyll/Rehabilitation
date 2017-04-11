function data = parsing_demographic(fn_excel, data)

% ID
ID = get_cell_value(fn_excel,'TempSpat','G7');
data.ID = str2double(ID);

% Experimental date
GA_date = get_cell_value(fn_excel,'TempSpat','K7');
try
    data.GA_date = [GA_date(1:4) '-' GA_date(5:6) '-' GA_date(7:8)];
catch
    data.GA_date = NaN;
end

% Age
data.age = get_cell_value(fn_excel,'TempSpat','K8');

