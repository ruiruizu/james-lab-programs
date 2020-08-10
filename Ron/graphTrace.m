function graphTrace(h)
    SIGMA = 1;
    centers = [30.2,205.3;
               50,23;
               90,43;
               10,22;];
    h.d.Trace.traceMat = createTrace(h.d.Video.stack, centers, SIGMA);
    
    channel = 1;
    
    plot(h.d.gAx,squeeze(h.d.Trace.traceMat(1,channel,:)));
    
    
end