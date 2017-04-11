function value = get_cell_value(fn_excel,sheetName,cellNumber)

[a,b,raw] = xlsread(fn_excel,sheetName,cellNumber);
value = raw{1};