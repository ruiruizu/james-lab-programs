function setCenter(h,eventData,idx)
    
    % Find idx from UI point selection
    if ~isempty(eventData)
        
        h.d.chosenCenter = eventData.IntersectionPoint(1:2);
    
    
        delete(h.d.traceGraph);
        rM = repmat(h.d.chosenCenter,size(h.d.Centers,1),1);
    
        cA = h.d.Centers - rM;
    
        cA(abs(cA) > 0.0001 ) = 0;
        [centerNum,~] = find(cA,1);
        
        h.d.centerNum = centerNum;
        h.d.centerTextbox.Value = {num2str(centerNum)};
    else
        if idx<1
            h.d.centerTextbox.Value = {num2str(1)};
            h.d.centerNum = 1;
        elseif idx > size(h.d.Centers,1)
            h.d.centerTextbox.Value = {num2str(size(h.d.Centers,1))};
            h.d.centerNum = size(h.d.Centers,1);
        else

            h.d.centerNum = idx;
        end
        
    end
    
    nFrames = size(h.d.Video.channelStack,4);
    h.d.traceGraph = plot(h.d.gAx,(1:nFrames),squeeze(h.d.Trace.traceMat(h.d.centerNum,:,:)));
    
end