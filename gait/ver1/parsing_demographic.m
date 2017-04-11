function data = parsing_demographic(raw, data)

hdr = raw(1,:);
dat = raw(2:end,:);

colnum = find_column_number(hdr,'Params A');


% Experimental date
s = dat(3,colnum);
try
    IDcell = strsplit(char(s), '-');
    ID = str2double(IDcell{1});
catch
    ID = s{1};
end
data.ID = ID;

% Experimental date
GA_date = dat(4,colnum);
try
    data.GA_date = [num2str(data.year) '-' datestr(GA_date{1}-1,'mm-dd')];
catch
    data.GA_date = num2str(data.year);
end





