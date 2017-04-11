function idx = find_index_having_field(fieldname,list_fields)

idx = [];
for i=1:length(list_fields),
    if strcmpi(fieldname,list_fields{i}),
        idx = [idx; i];
    end
end