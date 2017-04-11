function data = parsing_folder_name(dirname, data)


% Parsing folder name
terms = strsplit(dirname, '-');
for t=1:length(terms),
    terms{t} = strtrim(terms{t});
end

% Experimental number
data.folderNo = str2double(terms{1});

% Name
Name = strsplit(terms{2},',');
if length(Name)>1,
    Name = [Name{1} ' ' Name{2}];
else
    Name = Name{1};
end
data.Name      = strtrim(Name);

% Diagnosis 
try
    data.Diagnosis = terms{3};
catch
    data.Diagnosis = 'etc';
end
