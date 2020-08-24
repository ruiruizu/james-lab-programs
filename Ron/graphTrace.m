function graphTrace(h)
    d = uiprogressdlg(h.d.f,'Title','Please Wait',...
        'Message','Loading',...
        'Indeterminate','on',...
        'Cancelable','on'); 

    if isfield(h.d,'traceGraph')
        delete(h.d.traceGraph);
    end
    SIGMA = 1;
    centers = h.d.Centers;
           
    h.d.Trace.traceMat = createTrace(h.d.Video.channelStack, centers, SIGMA);
    
    h.d.centerTextbox.Value = {num2str(1)};
    setCenter(h,[],1)
    
    h.d.Particles.PickableParts = 'Visible';

    set(h.d.Particles,'ButtonDownFcn',@(~,eventData) setCenter(h,eventData));
    close(d);
end