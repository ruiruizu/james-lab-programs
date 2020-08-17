function graphTrace(h)
 
    if isfield(h.d,'traceGraph')
        delete(h.d.traceGraph);
    end
    SIGMA = 1;
    centers = h.d.Centers;
    nFrames = size(h.d.Video.channelStack,4);
           
    h.d.Trace.traceMat = createTrace(h.d.Video.channelStack, centers, SIGMA);
    
    setCenter(h,[],1)
    
    h.d.Particles.PickableParts = 'Visible';

    set(h.d.Particles,'ButtonDownFcn',@(~,eventData) setCenter(h,eventData));
    
end