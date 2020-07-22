function overlayVideos(h)
    if ~isfield(h.d,'border')
        uialert(h.d.f,...
            'No map selected',...
            'Error',...
            'Icon','warning');
        return;
    end
    
    hWB = uiprogressdlg(h.d.f,'Title','Please Wait');
    
    warning('off','imageio:tiffmexutils:libtiffWarning');

    videoList = h.d.videoList;
    border = h.d.border;
    tform = h.d.tform;
    outputview = imref2d(size(h.d.border));
    n_videos = size(h.d.videoList.Value,2);
    
    % Iterate through videos
    for i = 1:n_videos
                
        % Get current video file pathway
        importPath = videoList.Value{i};
        
        % Update the waitbar
        hWB.Message = ['Regestering images for video ', num2str(i) ' of ' num2str(n_videos) '.' newline importPath];         
                        
        % Set the overlayed-video file pathway
        lastSlash = find(importPath=='/',1,'last');
        importDir = extractBefore(importPath,lastSlash+1);
        importFilename = split(extractAfter(importPath,lastSlash),'.');
        exportPath = [importDir importFilename{1} '_overlay.' importFilename{2}];

        % Get number of frames in current video
        n_frames = size(imfinfo(importPath),1);
        
        % Setup import and export Tiff streams
        importStream = Tiff(importPath, 'r');
        exportStream = SaveTiff.start(exportPath,512,256,2,n_frames,true);
        
        for f = 1:n_frames
            % Import
            importStream.setDirectory(f);
            I = importStream.read();
        
            % Register
            SL = I(:,1:256);
            SR = I(:,257:512);
            SR = imwarp(SR,tform,'cubic','OutputView',outputview); % warp
            SR(~border) = 0; % clip border          
            J = cat(3, SR, SL); % merge channels
            
            % Export
            exportStream.add(J);
            
            hWB.Value = f/n_frames;
        end
        
        importStream.close;
        exportStream.close;
                
    end
    
    warning('on','imageio:tiffmexutils:libtiffWarning');
    close(hWB);
    
    uialert(h.d.f,...
            'All selected videos were registered.',...
            'Registation Complete',...
            'Icon','success');
