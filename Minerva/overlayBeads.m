function overlayBeads(h)
    
    if size(h.d.BeadSet,1) < 4
        uialert(h.d.f,'Not enough points selected. Please select at least 4.','Overlay Failed');
    end

    d = uiprogressdlg(h.d.f,'Title','Please Wait',...
        'Message','Aligning points',...
        'Indeterminate','on');
    
    %% Get points postions
    % Pre-aloc
    PL = zeros(size(h.d.BeadSet,1),2);
    PR = PL;
    
    for i = 1:size(h.d.BeadSet,1)
        BL = h.d.BeadSet{i,1}.Position;
        BR = h.d.BeadSet{i,2}.Position;
        
        % find nearest left
        disL = h.d.LPos - BL;
        [~, minL] = min(sum(disL(:,1).^2 + disL(:,2).^2,2));
        PL(i,:) = h.d.LPos(minL,:);
        
        % find nearest right
        disR = h.d.RPos - BR;
        [~, minR] = min(sum(disR(:,1).^2 + disR(:,2).^2,2));
        PR(i,:) = h.d.RPos(minR,:);
    end
    
    %% Affine alighn
    h.d.tform = fitgeotrans(PR,PL,'projective');
    
    ASL = imadjust(h.d.SL);
    ASR = imadjust(h.d.SR);
    
    outputview = imref2d(size(ASL));
    ASR2 = imwarp(ASR,h.d.tform,'cubic','OutputView',outputview);
    
    %% Remove borders
    border1 = ones(size(ASL));
    border2 = imwarp(border1,h.d.tform,'cubic','OutputView',outputview);
    h.d.border = logical(border1 .* border2);
    
    ASL(~h.d.border) = 0;
    ASR2(~h.d.border) = 0;
    
    %% Display
    overlap = cat(3,ASL, ASR2, ASR2);
    imshow(overlap,'parent',h.d.AxF);
    
    close(d);
end