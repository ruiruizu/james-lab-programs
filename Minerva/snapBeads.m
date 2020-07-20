function snapBeads(h)
    h.d.snapingBeads = true;

    d = uiprogressdlg(h.d.f,'Title','Please Wait',...
        'Message','Moving Beads',...
        'Indeterminate','on');
        
    if size(h.d.LPos,1) < size(h.d.BeadSet,1)
        close(d);
        uialert(h.d.f,'Not enough beads detected for the points you have selected in the Fixed channel','Snapping Failed');
        return;
    end
    
    if size(h.d.RPos,1) < size(h.d.BeadSet,1)
        close(d);
        uialert(h.d.f,'Not enough beads detected for the points you have selected in the Moving channel','Snapping Failed');
        return;
    end
    
	for i = 1:size(h.d.BeadSet,1)
        BL = h.d.BeadSet{i,1}.Position;
        BR = h.d.BeadSet{i,2}.Position;
        
        % find nearest left
        disL = h.d.LPos - BL;
        [~, minL] = min(sum(disL(:,1).^2 + disL(:,2).^2,2));
        h.d.BeadSet{i,1}.Position = h.d.LPos(minL,:);
        
        % find nearest right
        disR = h.d.RPos - BR;
        [~, minR] = min(sum(disR(:,1).^2 + disR(:,2).^2,2));
        h.d.BeadSet{i,2}.Position = h.d.RPos(minR,:);
    end
    
    h.d.snapingBeads = false;
    close(d);
end