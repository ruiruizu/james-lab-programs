function setMap(h)
    h.d.f.Visible = 'off';
    [file,path] = uigetfile('*.mat',...
                            'Select the map');
    h.d.f.Visible = 'on';
    
    if isa(file,'double') && file == 0
        % user canceled
        return;
    end

    sMat = load([path,file]);
    s = sMat.s;
    
    h.d.tform = s.tform;
    h.d.border = s.border;
    
    h.d.mapFileNameLabel.Text = [path,file];
end
