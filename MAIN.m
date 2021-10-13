%% automatic population spike detection from .atf files
clear all
%loading file to be analysed into work_matrix
[FileName, PathName] = uigetfile('*.atf', 'Select atf-File for averaging');
loadFile = strcat(PathName, FileName);

current_file = importdata(loadFile,'\t',10);
work_matrix = current_file.data;

%% properties of analysis assigned to an_prop
prompt = {'N of traces to average','Spike ABC (mV):','Spike AB (mV):','Search starts at (ms):','Search ends at (ms):'};
dlg_title = 'Analysis properties';
num_lines = 1;
def = {'12','0.5','0.3','0.052','0.06'};
an_prop = inputdlg(prompt,dlg_title,num_lines,def,'on');
an_prop = str2double(an_prop);

%% average traces
work_matrix = average (work_matrix, an_prop(1,1));
%% save for pClamp
clampex_save(work_matrix,PathName,FileName);
%% analyse traces
work_matrix = analyse_graph(work_matrix, an_prop(2,1), an_prop(3,1), an_prop(4,1), an_prop(5,1));

%% save values to Excel
xls_name = FileName(1,1:end-4);
xls_name = strcat(xls_name,'-analyzed.xlsx');
xls_name = strcat(PathName,xls_name);
sheet_name = strcat('average of_',num2str(an_prop(1)),'_sweeps');

header = {'Peak B','Peak A','Peak C','Spike Latency','Spike AB','Spike ABC'};
xlswrite(xls_name , header, sheet_name,'A1');

xlswrite(xls_name , work_matrix(:,1:6), sheet_name,'A2');