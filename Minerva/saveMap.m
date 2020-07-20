function saveMap(h)
    if ~isfield(h.d,'tform')
        uialert(h.d.f,'Overlay the channels first','Save Failed');
    end

    s = struct;
    s.tform = h.d.tform;
    s.border = h.d.border;
    h.d.f.Visible = 'off';
    uisave('s','map');
    h.d.f.Visible = 'on';
end