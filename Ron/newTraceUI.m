function h = newTraceUI(h)
    
    
    
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
 
    h.d.Channel = uidropdown(controlG,'Items',{'1','2','3'},'Value','1','ValueChangedFcn',@(~,~) setChannel(h));
    
    uilabel(controlG,'Text','Intensity Percentile');
    h.d.IntenSlider = uislider(controlG,'ValueChangedFcn',@(~,~) setFilterParam(h),'Value',80,'Limits',[80 100]);
    
    uilabel(controlG,'Text','Eccentricity');
    h.d.EccSlider = uislider(controlG,'ValueChangedFcn',@(~,~) setFilterParam(h),'Value',0,'Limits',[0 1]);
    
    uilabel(controlG,'Text','Edge Distance');
    h.d.EdgeSlider = uislider(controlG,'ValueChangedFcn',@(~,~) setFilterParam(h),'Value',0,'Limits',[0 10]);
    
    uilabel(controlG,'Text','Nearest Point');
    h.d.NearSlider = uislider(controlG,'ValueChangedFcn',@(~,~) setFilterParam(h),'Value',0,'Limits',[0 10]);
    
    uibutton(controlG,'Text','Generate Trace','ButtonPushedFcn',@(~,~) graphTrace(h));
    
    %Video 
    

    
    videoP = uipanel(videoSec);
    videoG = uigridlayout(videoP);
    videoG.RowHeight = {'1x'};
    videoG.ColumnWidth = {'1x'};
    
    h.d.Video.videoPanel = videoPanel('Parent', videoG,'Handles', h);
    
   
    
    %% Graph and Export
 
    %Graph Axes
    
    graphP = uipanel(h.d.g);
    graphG = uigridlayout(graphP);
    graphG.RowHeight = {'1x'};
    graphG.ColumnWidth = {'1x'};
    h.d.gAx = axes(graphP);
    axtoolbar(h.d.gAx,{'zoomin','zoomout','restoreview'});
    
    %Export
    exportP = uipanel(h.d.g);
    exportG = uigridlayout(exportP);
    exportG.RowHeight = {'1x'};
    exportG.ColumnWidth = {'1x','1x'};
    uibutton(exportG,'Text','Export Current','ButtonPushedFcn',@(~,~) exportTrace(h));
    uibutton(exportG,'Text','Export All','ButtonPushedFcn',@(~,~) exportTraceFolder(h));
    
    
end