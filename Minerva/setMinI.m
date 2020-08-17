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

    SL_d = im2double(h.d.SL);
    SL_m = imregionalmax(imgaussfilt(SL_d,1));
    SL_p = prctile(SL_d(SL_m), h.d.LSlider.Value);
    h.d.LPos = ParticleDetector.MaxLikleyhood(SL_d, SL_p, d);
    if d.CancelRequested
        return;
    end
    
    SR_d = im2double(h.d.SR);
    SR_m = imregionalmax(imgaussfilt(SR_d,1));
    SR_p = prctile(SR_d(SR_m), h.d.RSlider.Value);
    h.d.RPos = ParticleDetector.MaxLikleyhood(SR_d, SR_p, d);
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