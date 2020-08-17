function positionsByFrame = stackParticleDetector(f, stack, minPeakI, maxUDMovment)

    duration = size(stack,3);
    positionsByFrame = cell(duration,1); % Pre-aloc

    hWB = uiprogressdlg(f,'Title','Please Wait',...
                                'Message','Detecting frames');
    
    for f = 1:duration
        
        particles = particleDetector(im2double(stack(:,:,f)), minPeakI, maxUDMovment);
        
        positionsByFrame{f} = particles;
        
        hWB.Value = f/duration;
    end    
    
    close(hWB);
    
end