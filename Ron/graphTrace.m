function graphTrace(h)
 
    if isfield(h.d,'traceGraph')
        delete(h.d.traceGraph);
    end
    SIGMA = 1;
    centers = h.d.Centers;
           
    h.d.Trace.traceMat = createTrace(h.d.Video.channelStack, centers, SIGMA);
    
    h.d.traceGraph = plot(h.d.gAx,squeeze(h.d.Trace.traceMat(1,:,:)));
    h.d.Particles.PickableParts = 'Visible';

    set(h.d.Particles,'ButtonDownFcn',@(~,eventData) setCenter(h,eventData));
    
end