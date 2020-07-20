function [stack, info] = importVideo( f, filename, filedir, hWB )

    waitbarFlag = exist('hWB','var'); 
    
    %%
    info = struct;
    info.filename = filename;
    if exist('filedir','var')
        info.filedir = filedir; 
    end
    
    %% Gather stack information
    info.singleFile = isa(info.filename,'char');

    if info.singleFile
        filePath = [info.filedir info.filename];
    else
        filePath = [info.filedir info.filename{1}];
    end

    fileInfo = imfinfo(filePath);

    % Sizes
    info.height = fileInfo(1).Height;
    info.width = fileInfo(1).Width;

    % Durration
    if info.singleFile
        info.duration = length(fileInfo);
    else
        info.duration = size(info.filename,2);
    end

    % Bit Depth
    info.bitDepth = fileInfo(1).BitDepth;

    %% Settings for video display

    % Int Type
    switch info.bitDepth
        case 8
            info.intType = 'uint8';
        case 16
            info.intType = 'uint16';
        case 32
            info.intType = 'uint32';
        case 64
            info.intType = 'uint64';
        otherwise
            error(['Unable to read BitDepth of ' filePath]);
    end

    % Import TIFF
    stack = zeros(info.height, info.width, info.duration, info.intType); % pre-aloc
    warning('off','MATLAB:imagesci:tiffmexutils:libtiffWarning');
    warning('off','imageio:tiffmexutils:libtiffWarning');



    % read in video frame by frame
    if info.singleFile            
        if ~waitbarFlag
            hWB = uiprogressdlg(f,'Title','Please Wait',...
                            'Message','Importing');

            tiffLink = Tiff(filePath, 'r');
            for i = 1:info.duration
               tiffLink.setDirectory(i);
               stack(:,:,i) = tiffLink.read();

               hWB.Value = i/info.duration;
            end

            delete(hWB);
        else
            tiffLink = Tiff(filePath, 'r');
            for i = 1:info.duration
               tiffLink.setDirectory(i);
               stack(:,:,i) = tiffLink.read();
            end
        end


    else

        if ~waitbarFlag
            hWB = uiprogressdlg(f,'Title','Please Wait',...
                                'Message','Importing');

            for i = 1:info.duration
               filePath = [info.filedir info.filename{i}];
               try
                    tiffLink = Tiff(filePath, 'r');
               catch ME
                   if strcmp(ME.identifier, 'MATLAB:imagesci:Tiff:unableToOpenFile')
                       continue;
                   end
               end
               tiffLink.setDirectory(1);
               stack(:,:,i) = tiffLink.read();

               hWB.Value = i/info.duration;
            end

            close(hWB);
        else
            for i = 1:info.duration
               filePath = [info.filedir info.filename{i}];
               try
                    tiffLink = Tiff(filePath, 'r');
               catch ME
                   if strcmp(ME.identifier, 'MATLAB:imagesci:Tiff:unableToOpenFile')
                       continue;
                   end
               end
               tiffLink.setDirectory(1);
               stack(:,:,i) = tiffLink.read();

               hWB.Value = i/info.duration;
            end
        end

    end

    tiffLink.close();
    warning('on','MATLAB:imagesci:tiffmexutils:libtiffWarning');
    warning('on','imageio:tiffmexutils:libtiffWarning');
        

end

