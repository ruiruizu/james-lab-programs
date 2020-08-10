function h = newTraceUI(h)
    delete(h.d.g);
    
    
    
    h.d.g = uigridlayout(h.d.f);
    h.d.g.RowHeight = {40,'2x','1x',50};
    h.d.g.ColumnWidth = {'1x'};
    
    %Import
    importP = uipanel(h.d.g);
    importG = uigridlayout(importP);
    importG.RowHeight = {'1x'};
    importG.ColumnWidth = {100,'1x'};
    
    uibutton(importG,'Text','Import Video','ButtonPushedFcn',@(~,~) setTraceVideo(h));
    h.d.fileNameLabel = uilabel(importG,'Text','');
    
    %% Video Controls
    
    videoSec = uigridlayout(h.d.g);
    videoSec.RowHeight = {'1x'};
    videoSec.ColumnWidth = {300,'1x'};
    
    %Controls
    controlP = uipanel(videoSec);
    controlG = uigridlayout(controlP);
    controlG.RowHeight = {20,15,40,15,40,15,40,15,40,20};
    controlG.ColumnWidth = {250};
 
    uidropdown(controlG,'Items',{'Red','Blue','Green'},'Value','Red');
    uilabel(controlG,'Text','Minimum Intensity');
    h.d.ISlider = uislider(controlG,'ValueChangedFcn',@(~,~) setMinI(h),'Value',0);
    
    uilabel(controlG,'Text','Eccentricity');
    h.d.ESlider = uislider(controlG,'ValueChangedFcn',@(~,~) setMinI(h),'Value',0);
    
    uilabel(controlG,'Text','?????');
    h.d.USlider = uislider(controlG,'ValueChangedFcn',@(~,~) setMinI(h),'Value',0);
    
    uilabel(controlG,'Text','?????');
    h.d.USlider = uislider(controlG,'ValueChangedFcn',@(~,~) setMinI(h),'Value',0);
    
    uibutton(controlG,'Text','Generate Trace','ButtonPushedFcn',@(~,~) graphTrace(h));
    
    %Video Axes
    
    axesP = uipanel(videoSec);
    axesG = uigridlayout(axesP);
    
    
   
    
    %% Graph and Export
 
    %Graph Axes
    
    graphP = uipanel(h.d.g);
    graphG = uigridlayout(axesP);
    graphG.RowHeight = {'1x'};
    graphG.ColumnWidth = {'1x'};
    h.d.gAx = axes(graphP);
    
    %Export
    exportP = uipanel(h.d.g);
    exportG = uigridlayout(exportP);
    exportG.RowHeight = {'1x'};
    exportG.ColumnWidth = {'1x','1x'};
    uibutton(exportG,'Text','Export Current','ButtonPushedFcn',@(~,~) exportTrace(h,1));
    uibutton(exportG,'Text','Export All','ButtonPushedFcn',@(~,~) exportTraceFolder(h));
    
    
end