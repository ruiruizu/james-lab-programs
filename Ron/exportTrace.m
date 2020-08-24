function exportTrace(h)
    
    trace = h.d.Trace.traceMat(h.d.centerNum,:,:);
%     x = strtrim(num2str(centers(centerNum,1)));
%     y = strtrim(num2str(centers(centerNum,2)));
%     filename = strcat(x,',',y);

    h.d.f.Visible = 'off';
    folder = uigetdir;
    h.d.f.Visible = 'on';

    filename = strcat(folder,'/trace_',num2str(h.d.centerNum),'.txt');
    writematrix(squeeze(trace)',filename);
end