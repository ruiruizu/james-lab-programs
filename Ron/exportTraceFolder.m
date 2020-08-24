function exportTraceFolder(h)
    traces = h.d.Trace.traceMat(:,:,:);
    
    h.d.f.Visible = 'off';
    folder = uigetdir;
    
    
    mkdir (folder, 'Traces');
    
    path = strcat(folder,'/','Traces');
    
    for i = 1:size(traces,1)
        filename = strcat(path,'/trace_',num2str(i),'.txt');

        writematrix(traces(i,:,:),filename);

        writematrix(squeeze(traces(i,:,:))',filename);

    end
    
    h.d.f.Visible = 'on';

end