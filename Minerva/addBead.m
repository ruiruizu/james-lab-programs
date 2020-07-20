function addBead(h)
    c = rand(1,3);
    LP = drawpoint(h.d.AxL,'Color',c);
    RP = drawpoint(h.d.AxR,'Color',c,'Position',LP.Position);
    
    id = size(h.d.BeadSet,1) + 1;
    
    LP.UserData = id;
    RP.UserData = id;

    % create new right-click menu   
    %delete(LP.UIContextMenu.Children);
    %delete(RP.UIContextMenu.Children);
    %cmL = LP.UIContextMenu;
    %uimenu(cmL, 'Label', 'Remove', 'Callback', @(~,~) removeBead(obj, LP));    
    %cmR = RP.UIContextMenu;
    %uimenu(cmR, 'Label', 'Remove', 'Callback', @(~,~) removeBead(obj, RP));    
    
    addlistener(LP,'ROIMoved',@(hObject,~) moveLBead(h,hObject));
    addlistener(LP,'MovingROI',@(hObject,~) moveLBead(h,hObject));
    
    h.d.BeadSet{id,1} = LP;
    h.d.BeadSet{id,2} = RP;
end

