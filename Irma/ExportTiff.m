classdef ExportTiff < handle
%%% ExportTiff
%%%
%%% There are two modes: single and streaming
%%%
%%% Single is for a single export event. It takes a stack or image. It then
%%% starts a stream, export all the images in the stack/image, and then
%%% closes the stream. 
%%%
%%% ExportTiff(Stack, Filepath, (Overwrite=false))
%%% Stack - uint16 matrix (x, y, channels, frames)
%%% Filepath - char-array
%%% Overwrite - (optional) T/F flag on whether to overwrite or throw an
%%%             error if the filepath alread exists. Default: false;
%%%
%%%
%%%
%%% Streaming is for serveral export events to one file. This is
%%% particularly useful for when you want to use a progress bar or images
%%% are being processed one at a time/in batches. There are three functions
%%% 'start', 'add', and 'close'.
%%%
%%% exportStream = ExportTiff.start(Filepath, Height, Width, Channels, Frames, (Overwrite=false) )
%%% Filepath - char-array
%%% Height,Width,Channels,Frames - integer dimensions of the the final stack.
%%% Overwrite - (optional) T/F flag on whether to overwrite or throw an
%%%             error if the filepath alread exists. Default: false;
%%%
%%% exportStream.add(Stack)
%%% Stack - uint16 matrix (x, y, channels, frames)
%%%
%%% Example:
%%% exportStream = ExportTiff.start(Filepath, Height, Width, Channels, Frames, (Overwrite=false) );
%%% exportStream.add(I1);
%%% exportStream.add(I2);
%%% exportStream.close;
%%%
%%% Listeners for progress bars can be used in streaming mode on the 'progress' property.
%%% Example:
%%% exportStream = ExportTiff.start(Filepath, Height, Width, Channels, Frames, (Overwrite=false) );
%%% waitBar = uiprogressdlg(f);
%%% updateWait = @(~,evn) waitBar.set('Value',evn.AffectedObject.progress);
%%% addlistener(exportStream,'progress','PostSet',updateWait);
%%% exportStream.add(S);
%%% exportStream.close;
%%%

    properties (SetObservable) 
        progress = 0 % value between 0-1, percentage of frames written
    end

    properties (Access = private)
        lastFrame = 0
        frames
        tiffStream
        tags = struct
    end
    
    methods(Static)
        function obj = start(filepath,height,width,channels,frames,overwrite)
            % ExportTiff.start(Filepath, Height, Width, Channels, Frames, (overwrite=false) )
            if exist('overwrite','var')
                obj = ExportTiff(filepath,height,width,channels,frames,overwrite);
            else
                obj = ExportTiff(filepath,height,width,channels,frames);
            end
        end
    end
    
    methods(Access = private)
        function startTiffStream(obj,filepath,overwrite,height,width,channels,frames)
            if isfile(filepath)
                if overwrite
                    delete(filepath);
                else
                    error('File Already Exists');
                end
            end
                        
            obj.tiffStream = Tiff(filepath,'a');
            obj.frames = frames;
            
            obj.tags.ImageLength = height; % image height
            obj.tags.ImageWidth = width; % image width
            obj.tags.BitsPerSample = 16; % uint16
            obj.tags.SamplesPerPixel = 1;
            obj.tags.Compression = Tiff.Compression.None;  
            obj.tags.RowsPerStrip = obj.tags.ImageLength;
            obj.tags.SampleFormat = Tiff.SampleFormat.UInt;
            obj.tags.SubFileType = Tiff.SubFileType.Default;
            obj.tags.Photometric = Tiff.Photometric.MinIsBlack;
            obj.tags.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky; 
            obj.tags.Orientation = Tiff.Orientation.TopLeft;
            obj.tags.Software = 'MATLAB'; 
            obj.tags.ImageDescription = ...
                ['ImageJ=1.52p' newline...
                'images=' num2str(channels*frames) newline...
                'channels=' num2str(channels) newline...
                'frames=' num2str(frames) newline...
                'hyperstack=true' newline...
                'mode=composite'];
        end
    end
    
    methods
        function obj = ExportTiff(varargin)
            % Single Mode:    ExportTiff( Stack, Filepath, (Overwrite=false) )
            % Streaming Mode: ExportTiff( Filepath, Height, Width, Channels, Frames, (Overwrite=false) )
            
            %% Single Export Mode
            if nargin == 2 || nargin == 3            
                stack = varargin{1};
                filepath = varargin{2};
                if nargin==3, overwrite = varargin{3}; else, overwrite = false; end
                
                height = size(stack,1);
                width = size(stack,2);
                channels = size(stack,3);
                frames = size(stack,4);
                
                startTiffStream(obj,filepath,overwrite,...
                                height,width,channels,frames)
                add(obj,stack);
                delete(obj);
                
            %% Streaming Export Mode
            elseif nargin == 5 || nargin == 6
                filepath    = varargin{1};
                height      = varargin{2};
                width       = varargin{3};
                channels    = varargin{4};
                frames      = varargin{5};
                if nargin==6, overwrite = varargin{6}; else, overwrite = false; end
                
                startTiffStream(obj,filepath,overwrite,...
                                height,width,channels,frames)
            end
        end

        function add(obj,S)
            
            n_channels  = size(S,3);
            n_frames    = size(S,4);
            
            for f = 1:n_frames
                for c = 1:n_channels
                    if obj.lastFrame > 0 
                        writeDirectory(obj.tiffStream);
                    end
                    setTag(obj.tiffStream, obj.tags);
                    write(obj.tiffStream, S(:,:,c,f));
                    obj.lastFrame = obj.lastFrame + 1;
                    obj.progress = obj.lastFrame/obj.frames;
                end
            end
        end
        
        function close(obj)
            delete(obj);
        end
        
        function delete(obj)
            obj.tiffStream.close;
        end
    end
end

