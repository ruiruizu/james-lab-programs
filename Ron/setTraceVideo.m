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
    
    h.d.Video.stack = importStream.getStack;
    
    importStream.close;
    waitBar.Message = 'Displaying';
    
    
    
    waitBar.close;
end