function setFilterParam(h,eventData)
    d = uiprogressdlg(h.d.f,'Title','Please Wait',...
        'Message','Loading',...
        'Indeterminate','on',...
        'Cancelable','on');
    
    if isfield(h.d,'Particles')
        delete(h.d.Particles);
    end
    if isfield(h.d,'traceGraph')
        delete(h.d.traceGraph);
    end
    
    stack = h.d.Video.stack;
    frame = h.d.Video.videoPanel.frame;
    
    if ~exist('eventData','var') && isfield(h.d,'Centers')
 
        
        h.d.Centers = particleDetector(im2double(stack(:,:,frame)), h.d.IntenSlider.Value,...
                                                                h.d.EccSlider.Value,...
                                                                h.d.EdgeSlider.Value,...
                                                                h.d.NearSlider.Value, d);
                                                            
        h.d.cRemoved.Text = strcat(num2str(h.d.prevCentersN - size(h.d.Centers,1)),' removed centers');
    
    else
        set(h.d.EccSlider,'Value',0);
        set(h.d.EdgeSlider,'Value',0);
        set(h.d.NearSlider,'Value',0);
        
        h.d.Centers = particleDetector(im2double(stack(:,:,frame)), h.d.IntenSlider.Value,...
                                                                h.d.EccSlider.Value,...
                                                                h.d.EdgeSlider.Value,...
                                                                h.d.NearSlider.Value, d);
        h.d.prevCentersN = size(h.d.Centers,1);
        h.d.cRemoved.Text = strcat(num2str(0),' removed centers');
    end

    if d.CancelRequested
        return;
    end
   
    if size(h.d.Centers,1) > 0
        hold(h.d.Video.videoPanel.axes.axes,'on');
        h.d.Particles = plot(h.d.Video.videoPanel.axes.axes, h.d.Centers(:,1), h.d.Centers(:,2), 'oc');
        h.d.Particles.PickableParts = 'none';
        hold(h.d.Video.videoPanel.axes.axes,'off');
    end
    
    close(d);
end