function exportTrace(h)
    
    trace = h.d.Trace.traceMat(h.d.centerNum,:,:);
%     x = strtrim(num2str(centers(centerNum,1)));
%     y = strtrim(num2str(centers(centerNum,2)));
%     filename = strcat(x,',',y);
    filename = strcat('trace_',num2str(centerNum),'.txt');
    writematrix(trace,filename);
end