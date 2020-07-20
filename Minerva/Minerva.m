function h = Minerva(h)
    % New registration map or Apply registration map
    
        % New
            % import mapping video
            % seperate mapping video
            % select spots
            % generate map
            % evaluate map
            % save map
            
        % Apply 
            % import map
            % select video folder
            % for each video
                % seperate video
                % apply transformation
                % save video
    
    if ~exist('h','var')
        h = session;
        h.d.f = uifigure;
        h.d.g = uigridlayout(h.d.f);
        h.d.BeadSet = cell(0,2);
    end
        
    newApplyAns = uiconfirm(h.d.f,...
        'Would you like to create a new registation map or apply an existing map?',...
        'New or Apply',...
        'Options', {'New','Apply','Close'},...
        'DefaultOption',1,...
        'CancelOption',3);

    switch newApplyAns
        case 'New'
            newRegUI(h);
        case 'Apply'
            h.d.KeyAddBead = false;
            applyRegUI(h);
        case 'Close'
            delete(h.d.f);
    end
end