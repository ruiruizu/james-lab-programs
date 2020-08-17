classdef videoPanel < handle
    properties
        h
        
        % interface objects
        mainGrid
        controls % play, frame slider, brightnessControls button, ect.
        brightnessControls % brightness and invert
        axes
        imageHolder
        
        % player values
        playPause = false;
        fps = 0;
        
        % video objects
        videoH
        tempGraphic = cell(1,0);
       
        
        % processeor
        processFun = [];
        
        % video info
        duration
        
        % loading
        loading = false
    end
    
    properties (SetObservable) 
        % video info
        frame
    end
    
    methods
        %% Constructor
        function obj = videoPanel( varargin )
            %% Parse inputs
            p = inputParser;
            p.addOptional('Parent',[]);
            p.addOptional('Handles',[]);
            p.addOptional('VideoHandle',[]);

            p.parse(varargin{:});
            v = p.Results;
            
            obj.h = v.Handles;
            
            %% User Interface
            % Main
            obj.mainGrid = uigridlayout(v.Parent);
            obj.mainGrid.RowHeight = {40,'1x'};
            obj.mainGrid.ColumnWidth = {'1x'};

            %% Controls
            obj.controls.grid = uigridlayout(obj.mainGrid);
            obj.controls.grid.RowHeight = {'1x'};
            obj.controls.grid.ColumnWidth = {40,25,35,'1x'};
                                         
            
            % play button
            obj.controls.playButton = uibutton(obj.controls.grid,...
                                                'Text','Play',...
                                                'ButtonPushedFcn',@(~,~) play(obj));
             %fps counter               
            obj.controls.fps = uilabel(...
                                       obj.controls.grid,...
                                       'Text',num2str(obj.fps));
                                            

                                            
            % frame textbox
            obj.controls.frameTextbox = uitextarea(obj.controls.grid,...
                                                    'Value','1',...
                                                    'ValueChangedFcn',@(hObject,~) displayFrameSafe(obj,str2double(obj.controls.frameTextbox.Value)));
            % frame slider                        
            obj.controls.frameSlider = uislider(obj.controls.grid,'ValueChangedFcn', @(~,~) displayFrame(obj,round(obj.controls.frameSlider.Value)),...
                                                'Value',1,'Limits',[1 2],...
                                                'MajorTickLabels',{},'MajorTicks',[],'MinorTicks',[]);
            
                                
            % brightness controls button
%             obj.controls.brightnessControlsButton = uicontrol(obj.controls.grid,...
%                                             'Style','pushbutton',...
%                                             'String', 'Brightness',...,...
%                                             'Callback',@(~,~) openBrightnessControls(obj));
%                                         
%             obj.controls.grid.Widths = [    40,... % play
%                                             40,... % fps
%                                             40,... % frame num
%                                             -1,... % frame slider
%                                             60]; % brightnessControls
%                                         
%             createBrightnessControlPanel(obj);
                                            
            %% Axes
            obj.axes.panel = uipanel(obj.mainGrid,'BorderType','none');
            obj.axes.axes = axes(obj.axes.panel);
            %set(obj.imageHolder,'hitTest','off'); 
            %hold(obj.axes.axes,'on');
            %axis(obj.axes.axes,'vis3d');
            %obj.axes.axes.XTickLabel = [];
            %obj.axes.axes.YTickLabel = [];
            %colormap(obj.axes.axes,gray(265));
           
%             obj.axes.scrollPanel = imscrollpanel(obj.axes.panel, obj.imageHolder);
%             obj.axes.API = iptgetapi(obj.axes.scrollPanel);
%             mag = obj.axes.API.findFitMag();
%             obj.axes.API.setMagnification(mag);
%             obj.axes.magBox = immagbox(obj.axes.scrollPanel, obj.imageHolder);
%             magBoxPos = get(obj.axes.magBox,'Position');
%             set(obj.axes.magBox,'Position',[0 0 magBoxPos(3:4)]);
% %             
%             axtoolbar(obj.axes.axes,{'datacursor'});
%             
%             obj.mainGrid.Heights = [35 -1];
            
            %% Video Setup
            if ~isempty(v.VideoHandle)
                setVideo(obj,v.VideoHandle);
            else
                obj.mainGrid.Visible = 'off';
            end
        end
        
        %% Keypress
        function hit = keyPress(obj,keyEvent)
            hit = true;
            
            switch keyEvent.Character
                case ' ' % pause/play
                    if obj.playPause
                        pause(obj);
                    else
                        play(obj);
                    end
                case '-' % zoom out
                    zoomOut(obj);
                case '_' % zoom out
                    zoomOut(obj);
                case '+' % zoom in
                    zoomIn(obj);
                case '=' % fit window
                    zoomToFit(obj);
                case 'i' % invert
                    setInvert(obj,~obj.brightnessControls.invert.Value);
                case 'o' % invert
                    autoBrightness(obj);
                otherwise
                    hit = false;
            end
        end
        
        %% Zoom
        function zoomIn(obj)
            mag = obj.axes.API.getMagnification() * 1.5;
            obj.axes.API.setMagnification(mag);
        end
        
        function zoomOut(obj)
            mag = obj.axes.API.getMagnification() / 1.5;
            obj.axes.API.setMagnification(mag);
        end
        
        function zoomToFit(obj)
            mag = obj.axes.API.findFitMag();
            obj.axes.API.setMagnification(mag);
        end
        
        %% Video
        function setVideo(obj,videoH_)
            % A video handle must be a struct of stack and info containing 
                        
            obj.videoH = videoH_;
            
            obj.duration = obj.h.d.(obj.videoH).info.duration;
            set(obj.controls.frameSlider,'Limits',[1 obj.duration]);
            
            if obj.duration == 1
                obj.controls.playButton.Visible = 'off';
                obj.controls.frameSlider.Visible = 'off';
                obj.controls.frameTextbox.Visible = 'off';
            else
                obj.controls.playButton.Visible = 'on';
                obj.controls.frameSlider.Visible = 'on';
                obj.controls.frameTextbox.Visible = 'on';
            end
            
            % Brightness Controls      
             obj.displayFrameSafe(obj.frame);
%             mag = obj.axes.API.findFitMag();
%             obj.axes.API.setMagnification(mag);
                        
            obj.mainGrid.Visible = 'on';
        end
        
        %% Play Back
        function play(obj)
            obj.playPause = true;
            set(obj.controls.playButton,'Text','Pause');
            set(obj.controls.playButton,'ButtonPushedFcn', @(~,~) pause(obj));
            
            tic;
            fpsFrames = 0; 
            while obj.playPause
                drawnow;
                
                if obj.frame+1 > obj.duration
                    obj.frame = 0;
                end
                
                displayFrame(obj,obj.frame+1);
                
                fpsTime = toc;
                if fpsTime >= 1 % after 1 second
                    obj.fps = fpsFrames/fpsTime;
                    set(obj.controls.fps,'Text',num2str(round(obj.fps,2)));
                    
                    tic;
                    fpsFrames = 0;
                else
                    fpsFrames = fpsFrames+1;
                end
            end
        end

        function pause(obj)
            obj.playPause = false;
            set(obj.controls.playButton,'Text','Play');
            set(obj.controls.playButton,'ButtonPushedFcn', @(~,~) play(obj));
        end
        
        %% Display and Image
        function displayFrameSafe(obj,frame)             
            % loop back if past last frame
            if frame > obj.duration
                frame = 1;
            elseif frame < 1
                frame = 1;
            elseif isempty(frame)
                frame = 1;
            end
            
            displayFrame(obj,frame);
        end
        
        function displayFrame(obj,frame)             
            % loop back if past last frame
            limits = obj.controls.frameSlider.get('Limits');
            if frame > limits(:,2)
                frame = 1;
            elseif frame < 1
                frame = 1;
            end
            
            % get and display frame
            obj.clearGraphics;
            J = getFrame(obj,frame);
%             obj.axes.API.replaceImage(J,'PreserveView',true);
            imshow(J,'parent',obj.axes.axes);
           
            % update frame value
            obj.frame = frame;
            set(obj.controls.frameSlider,'Value',frame);
            set(obj.controls.frameTextbox,'Value',num2str(frame));
        end
        
        function reloadFrame(obj)
            if obj.playPause
                pause(obj);
            end
                        
            displayFrame(obj,obj.frame);
            
            drawnow limitrate;
        end
        
        function I = getRawFrame(obj,frame)
            I = im2double(obj.h.d.(obj.videoH).stack(:,:,frame));
        end
        
        function I = getFrame(obj,frame)
            % Process image
            if isempty(obj.processFun)
                I = im2double(obj.h.d.(obj.videoH).stack(:,:,frame));
            else
                obj.clearGraphics;
                [I, obj.tempGraphic] = obj.processFun(obj, frame);
            end
            
            %Invert
%             if obj.brightnessControls.invert.Value
%                 I = imcomplement(I);
%             end
            
            % Brightness
%             if obj.h.d.(obj.videoH).info.color
%                 I = imadjust(I,...
%                         [obj.brightnessControls.lowRedBrightnessSlider.Value,...
%                          obj.brightnessControls.lowGreenBrightnessSlider.Value,...
%                          obj.brightnessControls.lowBlueBrightnessSlider.Value;...
%                          obj.brightnessControls.highRedBrightnessSlider.Value,...
%                          obj.brightnessControls.highGreenBrightnessSlider.Value,...
%                          obj.brightnessControls.highBlueBrightnessSlider.Value]);
%             else
%                 I = imadjust(I,...
%                         [obj.brightnessControls.lowRedBrightnessSlider.Value,...
%                          obj.brightnessControls.highRedBrightnessSlider.Value]);
%             end
         end
        
        function clearGraphics(obj)
            numGraphics = size(obj.tempGraphic,2);
            for i = 1:numGraphics
                delete(obj.tempGraphic{1});
                obj.tempGraphic(1) = [];
            end
        end
                        
        %% Brightness Controls
        function createBrightnessControlPanel(obj)
            % Create a seperate figure
            obj.brightnessControls.f = uifigure('Name', 'Brightness','Visible','off');
            obj.brightnessControls.f.Position = [obj.brightnessControls.f.Position(1:2) 400 320];
            obj.brightnessControls.f.Resize = 'off';
            
            obj.brightnessControls.f.CloseRequestFcn = @(~,~) closeBrightnessControls(obj);
            
            % Create a grid
            obj.brightnessControls.grid = uigridlayout(obj.brightnessControls.f);
            obj.brightnessControls.grid.RowHeight = {'1x',40};
            obj.brightnessControls.grid.ColumnWidth = {'1x'};
            
            %% Brightness
            % panel
            obj.brightnessControls.brightnessPanel = uipanel(obj.brightnessControls.grid);
            obj.brightnessControls.brightnessOuterGrid = uigridlayout(obj.brightnessControls.brightnessPanel);
            obj.brightnessControls.brightnessOuterGrid.RowHeight = {15,'1x',20};
            obj.brightnessControls.brightnessOuterGrid.ColumnWidth = {'1x'};
            
            % panel label
            obj.brightnessControls.brightnessLabel = uilabel(obj.brightnessControls.brightnessOuterGrid,...
                                                    'Text','Brightness',...
                                                    'HorizontalAlignment','center');
                                                
            % grid
            obj.brightnessControls.brightnessControlGrid = uigridlayout(obj.brightnessControls.brightnessOuterGrid);
            obj.brightnessControls.brightnessControlGrid.RowHeight = {'1x','1x','1x'};
            obj.brightnessControls.brightnessControlGrid.ColumnWidth = {80,'1x',45};
            obj.brightnessControls.brightnessControlGrid.Padding = 0;

            %% Red
            % low label
            obj.brightnessControls.lowRedBrightnessLabel = uilabel(obj.brightnessControls.brightnessControlGrid,...
                                                        'Text','Gray/Red Low');
                                                    
            % low slider
            obj.brightnessControls.lowRedBrightnessSlider = uislider(obj.brightnessControls.brightnessControlGrid,...
                                                        'Limits', [0,1],...
                                                        'Value', 0,...
                                                        'MajorTicks',[],...
                                                        'MinorTicks',[],...
                                                        'ValueChangingFcn',@(~,event) setLowBrightness(obj,event.Value,1),...
                                                        'ValueChangedFcn',@(~,event) setLowBrightness(obj,event.Value,1));
                                                    
            % low textbox
            obj.brightnessControls.lowRedBrightnessTextbox = uieditfield(obj.brightnessControls.brightnessControlGrid,...
                                                        'numeric',...
                                                        'Limits',[0,1],...
                                                        'Value',0,...
                                                        'ValueChangedFcn',@(hObject,~) setLowBrightness(obj,hObject.Value,1));
            
            % high label
            obj.brightnessControls.highRedBrightnessLabel = uilabel(obj.brightnessControls.brightnessControlGrid,...
                                                        'Text','Gray/Red High');
                                                    
            % high slider
            obj.brightnessControls.highRedBrightnessSlider = uislider(obj.brightnessControls.brightnessControlGrid,...
                                                        'Limits', [0,1],...
                                                        'Value', 1,...
                                                        'MajorTicks',[],...
                                                        'MinorTicks',[],...
                                                        'ValueChangingFcn',@(~,event) setHighBrightness(obj,event.Value,1),...
                                                        'ValueChangedFcn',@(~,event) setHighBrightness(obj,event.Value,1));
                                                    
            % high textbox
            obj.brightnessControls.highRedBrightnessTextbox = uieditfield(obj.brightnessControls.brightnessControlGrid,...
                                                        'numeric',...
                                                        'Limits',[0,1],...
                                                        'Value',1,...
                                                        'ValueChangedFcn',@(hObject,~) setHighBrightness(obj,hObject.Value,1));
                                                    
                                                    
            %% Green
            % low label
            obj.brightnessControls.lowRedBrightnessLabel = uilabel(obj.brightnessControls.brightnessControlGrid,...
                                                        'Text','Green Low');
                                                    
            % low slider
            obj.brightnessControls.lowGreenBrightnessSlider = uislider(obj.brightnessControls.brightnessControlGrid,...
                                                        'Limits', [0,1],...
                                                        'Value', 0,...
                                                        'MajorTicks',[],...
                                                        'MinorTicks',[],...
                                                        'ValueChangingFcn',@(~,event) setLowBrightness(obj,event.Value,2),...
                                                        'ValueChangedFcn',@(~,event) setLowBrightness(obj,event.Value,2));
                                                    
            % low textbox
            obj.brightnessControls.lowGreenBrightnessTextbox = uieditfield(obj.brightnessControls.brightnessControlGrid,...
                                                        'numeric',...
                                                        'Limits',[0,1],...
                                                        'Value',0,...
                                                        'ValueChangedFcn',@(hObject,~) setLowBrightness(obj,hObject.Value,2));
            
            % high label
            obj.brightnessControls.highGreenBrightnessLabel = uilabel(obj.brightnessControls.brightnessControlGrid,...
                                                        'Text','Green High');
                                                    
            % high slider
            obj.brightnessControls.highGreenBrightnessSlider = uislider(obj.brightnessControls.brightnessControlGrid,...
                                                        'Limits', [0,1],...
                                                        'Value', 1,...
                                                        'MajorTicks',[],...
                                                        'MinorTicks',[],...
                                                        'ValueChangingFcn',@(~,event) setHighBrightness(obj,event.Value,2),...
                                                        'ValueChangedFcn',@(~,event) setHighBrightness(obj,event.Value,2));
                                                    
            % high textbox
            obj.brightnessControls.highGreenBrightnessTextbox = uieditfield(obj.brightnessControls.brightnessControlGrid,...
                                                        'numeric',...
                                                        'Limits',[0,1],...
                                                        'Value',1,...
                                                        'ValueChangedFcn',@(hObject,~) setHighBrightness(obj,hObject.Value,2));
                                                    
            % auto brightness
            obj.brightnessControls.autoBrightnessButton = uibutton(obj.brightnessControls.brightnessOuterGrid,...
                                                            'push',...
                                                            'Text', 'Auto (o)',...
                                                            'ButtonPushedFcn',@(~,~) autoBrightness(obj));
                                                        
            %% Blue
            % low label
            obj.brightnessControls.lowBlueBrightnessLabel = uilabel(obj.brightnessControls.brightnessControlGrid,...
                                                        'Text','Blue Low');
                                                    
            % low slider
            obj.brightnessControls.lowBlueBrightnessSlider = uislider(obj.brightnessControls.brightnessControlGrid,...
                                                        'Limits', [0,1],...
                                                        'Value', 0,...
                                                        'MajorTicks',[],...
                                                        'MinorTicks',[],...
                                                        'ValueChangingFcn',@(~,event) setLowBrightness(obj,event.Value,3),...
                                                        'ValueChangedFcn',@(~,event) setLowBrightness(obj,event.Value,3));
                                                    
            % low textbox
            obj.brightnessControls.lowBlueBrightnessTextbox = uieditfield(obj.brightnessControls.brightnessControlGrid,...
                                                        'numeric',...
                                                        'Limits',[0,1],...
                                                        'Value',0,...
                                                        'ValueChangedFcn',@(hObject,~) setLowBrightness(obj,hObject.Value,3));
            
            % high label
            obj.brightnessControls.highBlueBrightnessLabel = uilabel(obj.brightnessControls.brightnessControlGrid,...
                                                        'Text','Red High');
                                                    
            % high slider
            obj.brightnessControls.highBlueBrightnessSlider = uislider(obj.brightnessControls.brightnessControlGrid,...
                                                        'Limits', [0,1],...
                                                        'Value', 1,...
                                                        'MajorTicks',[],...
                                                        'MinorTicks',[],...
                                                        'ValueChangingFcn',@(~,event) setHighBrightness(obj,event.Value,3),...
                                                        'ValueChangedFcn',@(~,event) setHighBrightness(obj,event.Value,3));
                                                    
            % high textbox
            obj.brightnessControls.highBlueBrightnessTextbox = uieditfield(obj.brightnessControls.brightnessControlGrid,...
                                                        'numeric',...
                                                        'Limits',[0,1],...
                                                        'Value',1,...
                                                        'ValueChangedFcn',@(hObject,~) setHighBrightness(obj,hObject.Value,3));
                                                    
            %% Invert
            obj.brightnessControls.invertPanel = uipanel(obj.brightnessControls.grid);
            
            obj.brightnessControls.invertGrid = uigridlayout(obj.brightnessControls.invertPanel);
            obj.brightnessControls.invertGrid.RowHeight = {'1x'};
            obj.brightnessControls.invertGrid.ColumnWidth = {'1x'};
            
            obj.brightnessControls.invert = uicheckbox(obj.brightnessControls.invertGrid,...
                                                    'Text','Invert (i)',...
                                                    'Value', true,...
                                                    'ValueChangedFcn', @(hObject,~) setInvert(obj,hObject.Value));
                                                
        end
        
        function openBrightnessControls(obj)
            if strcmp(obj.brightnessControls.f.Visible, 'off')
                obj.brightnessControls.f.Visible = 'on';
            else
                obj.brightnessControls.f.Visible = 'off';
                obj.brightnessControls.f.Visible = 'on';
            end
        end
        
        function closeBrightnessControls(obj)
            obj.brightnessControls.f.Visible = 'off';
        end
        
        %% Settings Callbacks        
        function setLowBrightness(obj,low, color)
            switch color
                case 1
                    high = obj.brightnessControls.highRedBrightnessSlider.Value;
                case 2
                    high = obj.brightnessControls.highBlueBrightnessSlider.Value;
                case 3
                    high = obj.brightnessControls.highGreenBrightnessSlider.Value;
            end
            
            if low >= high
                low = high - .0001;
            end
            
            switch color
                case 1
                    obj.brightnessControls.lowRedBrightnessSlider.Value = low;
                    obj.brightnessControls.lowRedBrightnessTextbox.Value = low;
                case 2
                    obj.brightnessControls.lowGreenBrightnessSlider.Value = low;
                    obj.brightnessControls.lowGreenBrightnessTextbox.Value = low;
                case 3
                    obj.brightnessControls.lowBlueBrightnessSlider.Value = low;
                    obj.brightnessControls.lowBlueBrightnessTextbox.Value = low;
            end
            
            reloadFrame(obj);
        end
        
        function setHighBrightness(obj,high, color)
            switch color
                case 1
                    low = obj.brightnessControls.lowRedBrightnessSlider.Value;
                case 2
                    low = obj.brightnessControls.lowGreenBrightnessSlider.Value;
                case 3
                    low = obj.brightnessControls.lowBlueBrightnessSlider.Value;
            end
            
            if low >= high
                high = low + .0001;
            end
            
            
            
            switch color
                case 1
                    obj.brightnessControls.highRedBrightnessSlider.Value = high;
                    obj.brightnessControls.highRedBrightnessTextbox.Value = high;
                case 2
                    obj.brightnessControls.highGreenBrightnessSlider.Value = high;
                    obj.brightnessControls.highGreenBrightnessTextbox.Value = high;
                case 3
                    obj.brightnessControls.highBlueBrightnessSlider.Value = high;
                    obj.brightnessControls.highBlueBrightnessTextbox.Value = high;
            end
            
            reloadFrame(obj);
        end
        
        function setInvert(obj,value)
            obj.brightnessControls.invert.Value = value;
            autoBrightness(obj);
        end
        
        function autoBrightness(obj)
            % Process image
            if isempty(obj.processFun)
                I = im2double(obj.h.d.(obj.videoH).stack(:,:,obj.frame));
            else
                obj.clearGraphics;
                [I, obj.tempGraphic] = obj.processFun(obj, obj.frame);
            end
            
            % Invert
            if obj.brightnessControls.invert.Value
                I = imcomplement(I);
            end
            
            % Calculate brightness values
            lims = stretchlim(I);
            
            % Apply to brightnessControls
            if ~obj.h.d.(obj.videoH).info.color
                obj.brightnessControls.lowRedBrightnessSlider.Value = lims(1);
                obj.brightnessControls.lowRedBrightnessTextbox.Value = lims(1);
                obj.brightnessControls.highRedBrightnessTextbox.Value = lims(2);
                obj.brightnessControls.highRedBrightnessSlider.Value = lims(2);
            else
                red
                obj.brightnessControls.lowRedBrightnessSlider.Value = lims(1,1);
                obj.brightnessControls.lowRedBrightnessTextbox.Value = lims(1,1);
                obj.brightnessControls.highRedBrightnessTextbox.Value = lims(2,1);
                obj.brightnessControls.highRedBrightnessSlider.Value = lims(2,1);
                green
                obj.brightnessControls.lowGreenBrightnessSlider.Value = lims(1,2);
                obj.brightnessControls.lowGreenBrightnessTextbox.Value = lims(1,2);
                obj.brightnessControls.highGreenBrightnessTextbox.Value = lims(2,2);
                obj.brightnessControls.highGreenBrightnessSlider.Value = lims(2,2);
                blue
                obj.brightnessControls.lowBlueBrightnessSlider.Value = lims(1,3);
                obj.brightnessControls.lowBlueBrightnessTextbox.Value = lims(1,3);
                obj.brightnessControls.highBlueBrightnessTextbox.Value = lims(2,3);
                obj.brightnessControls.highBlueBrightnessSlider.Value = lims(2,3);
            end
            
            % Apply to image
            I = imadjust(I,lims);
                        
            % Display image
            obj.axes.API.replaceImage(I,'PreserveView',true);
        end
        
        %% Save and Load
        function s = save(obj)
            if obj.playPause
                pause(obj);
            end
            
            s = struct;
                        
            s.videoH          = obj.videoH;
            
            s.frame           = obj.frame;
            
            s.lowBrightness   = obj.brightnessControls.lowBrightnessSlider.Value;
            s.highBrightness  = obj.brightnessControls.highBrightnessSlider.Value;
            s.invert          = obj.brightnessControls.invert.Value;
        end
        
        function load(obj,s)
            if obj.playPause
                pause(obj);
            end
            
            obj.loading = true;
            
            setVideo(obj,s.videoH); % this will set durration
                                    
            obj.brightnessControls.lowBrightnessSlider.Value      = s.lowBrightness;
            obj.brightnessControls.highBrightnessSlider.Value     = s.highBrightness;
            obj.brightnessControls.lowBrightnessTextbox.Value     = s.lowBrightness;
            obj.brightnessControls.highBrightnessTextbox.Value    = s.highBrightness;
            obj.brightnessControls.invert.Value                   = s.invert;
            
            displayFrame(obj,s.frame);
            obj.axes.API.findFitMag();
            
            obj.loading = false;
        end
    end
end