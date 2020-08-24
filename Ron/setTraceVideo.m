function setTraceVideo(h)
    h.d.f.Visible = 'off';
    [file,path] = uigetfile('*.TIF; *.TIFF; *.tif; *.tiff;',...
                            'Select the mapping video',...
                            'MultiSelect','on');
    filepath = [path,file];
    h.d.f.Visible = 'on';
    
    if isa(file,'double') && file == 0
        % user canceled
        return;
    end
    
    h.d.fileNameLabel.Text = filepath;
    
    importStream = ImportTiff(filepath);
    waitBar = uiprogressdlg(h.d.f,...
                    'Message',['Importing images from:' newline filepath],...
                    'Title','Importing');
    updateWait = @(~,evn) waitBar.set('Value',evn.AffectedObject.progress);
    addlistener(importStream,'progress','PostSet',updateWait);
    
    h.d.Video.channelStack = importStream.getStack;
    h.d.Video.stack = squeeze(h.d.Video.channelStack(:,:,str2double(h.d.Channel.Value),:));
    h.d.Video.info.duration = size(h.d.Video.stack,3);
    
    importStream.close;
    waitBar.Message = 'Displaying';
    
    
    h.d.Video.videoPanel.frame = 1;
    h.d.Video.videoPanel.setVideo('Video');
    setFilterParam(h)
    
    channelItems = {};
    for i = 1:size(h.d.Video.channelStack,3)
        channelItems{1,i} = num2str(i);
    end
    h.d.Channel.Items = channelItems;
    waitBar.close;
end