function setMapingVideo(h)
    %% Select mapping video
    h.d.f.Visible = 'off';
    [file,path] = uigetfile('*.TIF; *.TIFF; *.tif; *.tiff;',...
                            'Select the mapping video',...
                            'MultiSelect','on');
    h.d.f.Visible = 'on';
    
    if isa(file,'double') && file == 0
        % user canceled
        return;
    end
    
    S = timeAvgStack(importVideo(h.d.f, file, path));
    h.d.fileNameLabel.Text = [path,file];
    
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
%     h.d.LSlider.Limits(1) = log(im2double(min(h.d.SL(:))))*100;
%     h.d.LSlider.Limits(2) = log(im2double(max(h.d.SL(:))))*100;
%     h.d.LSlider.Value     = h.d.LSlider.Limits(2);
%     h.d.RSlider.Limits(1) = log(im2double(min(h.d.SR(:))))*100;
%     h.d.RSlider.Limits(2) = log(im2double(max(h.d.SR(:))))*100;
%     h.d.RSlider.Value     = h.d.RSlider.Limits(2);

    h.d.LSlider.Limits(1) = 50;
    h.d.LSlider.Limits(2) = 100;
    h.d.LSlider.Value     = 100;
    h.d.RSlider.Limits(1) = 50;
    h.d.RSlider.Limits(2) = 100;
    h.d.RSlider.Value     = 100;
    setMinI(h);
end