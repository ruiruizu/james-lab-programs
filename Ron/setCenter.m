function setCenter(h,eventData)
    h.d.chosenCenter = eventData.IntersectionPoint(1:2);
    
    if isfield(h.d,'traceGraph')
        delete(h.d.traceGraph);
        rM = repmat(h.d.chosenCenter,size(h.d.Centers,1),1);
    
        cA = h.d.Centers - rM;
    
        cA(abs(cA) > 0.0001 ) = 0;
        [centerNum,~] = find(cA,1);
        
        h.d.centerNum = centerNum;
        h.d.traceGraph = plot(h.d.gAx,squeeze(h.d.Trace.traceMat(centerNum,:,:)));
    end
    
   
    
end