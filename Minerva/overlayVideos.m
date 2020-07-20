function overlayVideos(h)
    if ~isfield(h.d,'border')
        uialert(h.d.f,...
            'No map selected',...
            'Error',...
            'Icon','warning');
        return;
    end
    
    hWB = uiprogressdlg(h.d.f,'Title','Please Wait');
    
    warning('off','MATLAB:imagesci:tiffmexutils:libtiffWarning');
    warning('off','imageio:tiffmexutils:libtiffWarning');

    %% Setup settings
    applyMean = h.d.movingMean.checkbox.Value;
    meanWidth = h.d.movingMean.editfield.Value;
    outputview = imref2d(size(h.d.border));
    
    if ~applyMean
        meanWidth = 1;
    end
        
    for i = 1:size(h.d.videoList.Value,2)
                
        path = h.d.videoList.Value{i};
        
        %% Import
        if isfolder(path)
            hWB.Message = ['Locating files for video ', num2str(i) ' of ' num2str(size(h.d.videoList.Value,2))]; 
            
            files = dir(path);
            newfiles = cell(0);
            for f = 1:size(files,1)
                if contains(files(f).name,'.tif') && files(f).name(1)~='.'
                    newfiles{end+1} = files(f).name;
                end
                hWB.Value = f/size(files,1);
            end
            
            savePath = extractBefore(path,'Pos0');
            if applyMean
                saveName = ['overlay_mean-' num2str(meanWidth) '.tif'];
            else
                saveName = 'overlay.tif';
            end
        else
            hWB.Message = ['Importing images for video ', num2str(i) ' of ' num2str(size(h.d.videoList.Value,2))]; 
            S = importVideo(h.d.f, path, '', hWB);
            
            lastSlash = find(path=='/',1,'last');
            savePath = extractBefore(path,lastSlash+1);
            saveName = extractAfter(path,lastSlash);
            nameParts = split(saveName,'.');
            if applyMean
                saveName = [nameParts{1} '_overlay_mean-' num2str(meanWidth) '.' nameParts{2}];
            else
                saveName = [nameParts{1} '_overlay.' nameParts{2}];
            end
        end        
        
        %% Registration
        hWB.Message = ['Writing images for video ', num2str(i) ' of ' num2str(size(h.d.videoList.Value,2))]; 
        hWB.Value = 0;


        % Get general file info
        if ~isfolder(path)
            filePath = path;
        else
            filePath = [path '/' newfiles{1}];
        end
        fileInfo = imfinfo(filePath);
        
        if ~isfolder(path)
            dur = length(fileInfo);
        else
            dur = size(newfiles,2);
        end
        
        meanWidth = min(dur,meanWidth);
        
        % Write first frame
        S = zeros(fileInfo(1).Height,fileInfo(1).Width,meanWidth,'uint16');
        if ~isfolder(path)
            tiffLink = Tiff(filePath, 'r');
            for j = 1:meanWidth
                tiffLink.setDirectory(j);
                S(:,:,j) = tiffLink.read();
            end
        else
            for j = 1:meanWidth
                tiffLink = Tiff([path '/' newfiles{j}], 'r');
                tiffLink.setDirectory(1);
                S(:,:,j) = tiffLink.read();
            end
        end
        
        A = cast(mean(S,3),'uint16');
        O = getOverlay(A(:,1:256),A(:,257:512),h,outputview);
        imwrite(O,[savePath,saveName],'tif','Compression','none');
        
        
        % Later frames
        for f = 2:dur-meanWidth+1
            % Shift up a frame
            if meanWidth > 1
                S(:,:,1:end-1) = S(:,:,2:end);
            end
            % Get new frame
            if ~isfolder(path)
                tiffLink.setDirectory(f+meanWidth-1);
            else
                try
                    tiffLink = Tiff([path '/' newfiles{f+meanWidth-1}], 'r');
                catch ME
                    if strcmp(ME.identifier, 'MATLAB:imagesci:Tiff:unableToOpenFile')
                        continue;
                    end
                end
                tiffLink.setDirectory(1);
            end
            S(:,:,end) = tiffLink.read();
        
            A = cast(mean(S,3),'uint16');
            O = getOverlay(A(:,1:256),A(:,257:512),h,outputview);
            
            hWB.Value = f/dur;
            
            % For big files
            if f==5001 || f==10001 || f==15001 || f==20001
                oldSaveName = saveName;
                if applyMean
                    newSaveName = ['overlay_mean-' num2str(meanWidth) '_' num2str(f-5000) '-' num2str(f-1) '.tif'];
                    saveName = ['overlay_mean-' num2str(meanWidth) '_' num2str(f) '-.tif'];
                else
                    newSaveName = ['overlay_' num2str(f-5000) '-' num2str(f-1) '.tif'];
                    saveName = ['overlay_' num2str(f) '- .tif'];
                end
                movefile([savePath,oldSaveName],[savePath,newSaveName]);
                
                imwrite(O,[savePath,saveName],'tif','Compression','none');
            else
                imwrite(O,[savePath,saveName],'tif','Compression','none','WriteMode','append');
            end
        end
                
    end
    
    warning('on','MATLAB:imagesci:tiffmexutils:libtiffWarning');
    warning('on','imageio:tiffmexutils:libtiffWarning');
    
    close(hWB);
    
    uialert(h.d.f,...
            'All selected videos were registered.',...
            'Registation Complete',...
            'Icon','success');
end

function O = getOverlay(SL,SR,h,outputview)
    % Warp
    SR = imwarp(SR,h.d.tform,'cubic','OutputView',outputview);

    % Clip
    SR(~h.d.border) = 0;

    % Overlay
    O = cat(3, SR, SL, SR*0);
end