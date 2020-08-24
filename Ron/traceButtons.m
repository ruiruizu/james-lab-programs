function traceButtons(h,eventData)

    currentCenter = h.d.centerNum;
    if strcmp(eventData.Source.Text,'Previous')
        currentCenter = currentCenter-1;
    elseif strcmp(eventData.Source.Text,'Next')
        currentCenter = currentCenter+1;
    end
    
    h.d.centerTextbox.Value = {num2str(currentCenter)};
    setCenter(h,[],currentCenter)

    
end