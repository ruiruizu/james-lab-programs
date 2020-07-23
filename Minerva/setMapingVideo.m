function setMapingVideo(h)
    %% Select mapping video
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
    S = timeAvgStack(importStream.getStack);
    importStream.close;
    
    %% Seperate channels
    h.d.SL = S(:,1:256);
    h.d.SR = S(:,257:512);
    
    %% Remove old beads if there are any
    clearBeads(h);
    
    %% Display images
    ASL = imadjust(h.d.SL);
    ASR = imadjust(h.d.SR);
    overlap = cat(3,ASL, ASR, ASR);
    
    imshow(imcomplement(ASL),'parent',h.d.AxL);
    imshow(imcomplement(ASR),'parent',h.d.AxR);
    imshow(overlap,'parent',h.d.AxF);
    
    %% Set MinI Slider Limits and Values
    h.d.LSlider.Limits(1) = 50;
    h.d.LSlider.Limits(2) = 100;
    h.d.LSlider.Value     = 100;
    h.d.RSlider.Limits(1) = 50;
    h.d.RSlider.Limits(2) = 100;
    h.d.RSlider.Value     = 100;
    setMinI(h);
end