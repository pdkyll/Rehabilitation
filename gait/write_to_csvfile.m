function write_to_csvfile(fout,subjlist, varNames)

% File handle
fid = fopen(fout,'w+');

% Get header information and write to file
header = '';
for i=1:length(varNames)
    header = [header, varNames{i}, ','];
end
header(end) = [];
fprintf(fid,'%s\n',header);


% Write data
nsubj = length(subjlist);
for c=1:nsubj,
    data = subjlist(c).data;
    values = '';
    for i=1:length(varNames)
        ahdr = varNames{i};
        try
            if strcmpi(ahdr,'name'), values = sprintf('%s, %s',values,data.(ahdr));
            elseif strcmpi(ahdr,'year'), values = sprintf('%s, %d',values,data.(ahdr));
            elseif strcmpi(ahdr,'diagnosis'), values = sprintf('%s, %s',values,data.(ahdr));
            elseif strcmpi(ahdr,'ID'), values = sprintf('%s, %d',values,data.(ahdr));
            elseif strcmpi(ahdr,'GA_date'), values = sprintf('%s, %s',values,data.(ahdr));
            else   values = sprintf('%s, %f',values,data.(ahdr));
            end
        catch
            values = sprintf('%s, ',values);
        end
    end
    values(1:2) = [];
    fprintf(fid,'%s\n',values);
end

fclose(fid);