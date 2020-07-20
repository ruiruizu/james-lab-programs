function h = newRegUI(h)
    %% Setup figure
    % Clear the figure
    delete(h.d.g);
    
    % Grid
    h.d.g = uigridlayout(h.d.f);
    h.d.g.RowHeight = {60,60,'1x'};
    h.d.g.ColumnWidth = {'1x'};
    
    % File name
    fileNameP = uipanel(h.d.g);
    fileNameG = uigridlayout(fileNameP);
    fileNameG.RowHeight = {'1x'};
    fileNameG.ColumnWidth = {150,'1x'};
    uibutton(fileNameG,'Text','Import Mapping Video','ButtonPushedFcn',@(~,~) setMapingVideo(h));
    h.d.fileNameLabel = uilabel(fileNameG,'Text','');
    
    % Controls
    controlP = uipanel(h.d.g);
    controlG = uigridlayout(controlP);
    controlG.RowHeight = {'1x'};
    controlG.ColumnWidth = {80,80,80,80,80,80,40,'1x',40,'1x'};
    
    h.d.KeyAddBead = true;
    set(h.d.f,'KeyPressFcn',@(~,key) keypress(h,key));
    uibutton(controlG,'Text','Add Bead','ButtonPushedFcn',@(~,~) addBead(h),...
                    'Tooltip','Spacebar to quick add');
    uibutton(controlG,'Text','Clear All','ButtonPushedFcn',@(~,~) clearBeads(h));
    uibutton(controlG,'Text','Snap','ButtonPushedFcn',@(~,~) snapBeads(h));
    uibutton(controlG,'Text','Overlay','ButtonPushedFcn',@(~,~) overlayBeads(h));
    uibutton(controlG,'Text','Save Map','ButtonPushedFcn',@(~,~) saveMap(h));
    uibutton(controlG,'Text','Exit','ButtonPushedFcn',@(~,~) Minerva(h));
    uilabel(controlG,'Text','Fixed');
    h.d.LSlider = uislider(controlG,'ValueChangedFcn',@(~,~) setMinI(h),'Value',100);
    uilabel(controlG,'Text','Moving');
    h.d.RSlider = uislider(controlG,'ValueChangedFcn',@(~,~) setMinI(h),'Value',100);
    
    % Axes
    axesP = uipanel(h.d.g);
    axesG = uigridlayout(axesP);
    axesG.RowHeight = {20,'1x'};
    axesG.ColumnWidth = {'1x','1x','1x'};
    uilabel(axesG,'Text','Fixed','HorizontalAlignment','center');
    uilabel(axesG,'Text','Moving','HorizontalAlignment','center');
    uilabel(axesG,'Text','Overlay','HorizontalAlignment','center');
    AxLP = uipanel(axesG);
    h.d.AxL = axes(AxLP);
    %h.d.AxL.Toolbar.Visible = 'off';
    disableDefaultInteractivity(h.d.AxL);
    AxRP = uipanel(axesG);
    h.d.AxR = axes(AxRP);
    %h.d.AxR.Toolbar.Visible = 'off';
    disableDefaultInteractivity(h.d.AxR);
    AxFP = uipanel(axesG);
    h.d.AxF = axes(AxFP);
    %h.d.AxF.Toolbar.Visible = 'off';
    disableDefaultInteractivity(h.d.AxF);
end