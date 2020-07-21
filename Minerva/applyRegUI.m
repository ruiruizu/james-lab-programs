function applyRegUI(h)
    %% Setup figure
    % Clear the figure
    delete(h.d.g);
    
    % Grid
    h.d.g = uigridlayout(h.d.f);
    h.d.g.RowHeight = {50,50,'1x'};
    h.d.g.ColumnWidth = {'1x'};
    
    % Map file name
    mapFileNameP = uipanel(h.d.g);
    mapFileNameG = uigridlayout(mapFileNameP);
    mapFileNameG.RowHeight = {'1x'};
    mapFileNameG.ColumnWidth = {90,'1x'};
    
    uibutton(mapFileNameG,'Text','Import Map','ButtonPushedFcn',@(~,~) setMap(h));
    h.d.mapFileNameLabel = uilabel(mapFileNameG,'Text','');
    
    % Video files folder name
    videoFolderNameP = uipanel(h.d.g);
    videoFolderNameG = uigridlayout(videoFolderNameP);
    videoFolderNameG.RowHeight = {'1x'};
    videoFolderNameG.ColumnWidth = {90,'1x',90,90,40};
    
    uibutton(videoFolderNameG,'Text','Import Videos','ButtonPushedFcn',@(~,~) setVideosToMap(h));
    h.d.videoFolderNameLabel = uilabel(videoFolderNameG,'Text','');
    uibutton(videoFolderNameG,'Text','Clear Videos','ButtonPushedFcn',@(~,~) clearVideosToMap(h));
    uibutton(videoFolderNameG,'Text','Overlay Videos','ButtonPushedFcn',@(~,~) overlayVideos(h));
    uibutton(videoFolderNameG,'Text','Exit','ButtonPushedFcn',@(~,~) Minerva(h));

    % Video files list
    h.d.videoList = uilistbox(h.d.g,'Multiselect','on','Items',{});    
end
