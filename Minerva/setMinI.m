function setMinI(h)
    d = uiprogressdlg(h.d.f,'Title','Please Wait',...
        'Message','Loading',...
        'Indeterminate','on',...
        'Cancelable','on');
    
    if isfield(h.d,'LParticles')
        delete(h.d.LParticles);
    end
    
    if isfield(h.d,'RParticles')
        delete(h.d.RParticles);
    end

    h.d.LPos = particleDetector(im2double(h.d.SL), h.d.LSlider.Value, d);
    if d.CancelRequested
        return;
    end
    h.d.RPos = particleDetector(im2double(h.d.SR), h.d.RSlider.Value, d);
    if d.CancelRequested
        return;
    end    
    
    if size(h.d.LPos,1) > 0
        hold(h.d.AxL,'on');
        h.d.LParticles = plot(h.d.AxL, h.d.LPos(:,1), h.d.LPos(:,2), '+c', 'LineWidth', 2);
        h.d.LParticles.PickableParts = 'none';
        hold(h.d.AxL,'off');
    end
    
    if size(h.d.RPos,1) > 0
        hold(h.d.AxR,'on');
        h.d.RParticles = plot(h.d.AxR, h.d.RPos(:,1), h.d.RPos(:,2), '+r', 'LineWidth', 2);
        h.d.RParticles.PickableParts = 'none';
        hold(h.d.AxR,'off');
    end
    
    close(d);
end