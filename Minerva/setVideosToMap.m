function setVideosToMap(h)

    d = uiprogressdlg(h.d.f,'Title','Please Wait',...
        'Message','Searching Folder',...
        'Indeterminate','on');

    %% Select Top Level Folder
    h.d.f.Visible = 'off';
    toppath = uigetdir;
    h.d.f.Visible = 'on';
    
    if isa(toppath,'double') && toppath == 0
        % user canceled
        return;
    end
    
    h.d.videoFolderNameLabel.Text = toppath;
    
    %% Add Folder Contents
    checkDir(h, toppath)
    
    close(d);
end

function checkDir(h, path)
    list = dir(path);
    
    for i = 3:size(list,1)
        if strcmp(list(i).name,'.') || strcmp(list(i).name,'..') || strcmp(list(i).name,'.Trashes')
            continue;
        end
        
    	if list(i).isdir
            if strcmp(list(i).name,'Pos0')
                h.d.videoList.Items{end+1} = [list(i).folder '/' list(i).name];
                drawnow;
            else
                checkDir(h, [list(i).folder '/' list(i).name]);
            end
        else
            if ~isempty(strfind(list(i).name,'.'))
                ext = split(list(i).name,'.');
                if strcmp(ext(2),'tif') || strcmp(ext(2),'tiff') || strcmp(ext(2),'TIF') || strcmp(ext(2),'TIFF')
                    if ~contains(ext(1),'overlay')
                        h.d.videoList.Items{end+1} = [list(i).folder '/' list(i).name];
                        drawnow;
                    end
                end
            end
        end
    end
end