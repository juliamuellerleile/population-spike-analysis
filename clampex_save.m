function clampex_save(in_mat,path,name)
name = name(1:size(name,2)-4);
name = strcat(name,'-analyzed.atf');
path = strcat(path,name);

fid = fopen(path, 'wt');
fprintf(fid, '%s\t','ATF');
fprintf(fid, '%s\n','1.0');
fprintf(fid, '%d\t',7);
fprintf(fid, '%d\n',size(in_mat,2));
fprintf(fid, '%s\n', '"AcquisitionMode=High-Speed Oscilloscope"');
fprintf(fid, '%s\n', '"Comment="');
fprintf(fid, '%s\n', '"YTop=100"');
fprintf(fid, '%s\n', '"YBottom=-100"');
fprintf(fid, '%s\n', '"SweepStartTimesMS="');
fprintf(fid, '%s\n', '"SignalsExported=IN 1"');
fprintf(fid, '%s\t', '"Signals="');

for i=1:(size(in_mat,2)-1) 
    fprintf(fid, '%s\t', '"IN 1"');
end

fprintf(fid, '\n');
fprintf(fid, '%s\t', '"Time (s)"');

for i=1:(size(in_mat,2)-1)
    fprintf(fid, '%s', '"Trace #');
    fprintf(fid, '%u', i);
    fprintf(fid, '%s\t', ' (mV)"');
end
fprintf(fid, '\n');

for x=1:size(in_mat,1)    
    for y=1:(size(in_mat,2)-1)
        fprintf(fid, '%d\t', in_mat(x,y));
    end
    y=size(in_mat,2);
    fprintf(fid, '%d\n', in_mat(x,y));
end
fclose(fid);