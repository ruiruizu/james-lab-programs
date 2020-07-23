classdef ExportTiff < handle

    properties (Access = private)
        lastFrame = 0
        tiffStream
        tags = struct
    end
    
    methods(Static)
        function obj = start(filepath,height,width,channels,frames,override)
            % Filepath, Height, Width, Channels, Frames, (Override=false)
            if exist('override','var')
                obj = ExportTiff(filepath,height,width,channels,frames,override);
            else
                obj = ExportTiff(filepath,height,width,channels,frames);
            end
        end
    end
    
    methods(Access = private)
        function startTiffStream(obj,filepath,override,height,width,channels,frames)
            if isfile(filepath)
                if override
                    delete(filepath);
                else
                    error('File Already Exists');
                end
            end
            
            obj.tiffStream = Tiff(filepath,'a');
            
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
            % Stack, Filepath, (Override=false)
            % Filepath, Height, Width, Channels, Frames, (Override=false)
            
            %% Single Export Mode
            if nargin == 2 || nargin == 3                
                stack = varargin{1};
                filepath = varargin{2};
                if nargin==3, override = varargin{3}; else, override = false; end
                
                height = size(stack,1);
                width = size(stack,2);
                channels = size(stack,3);
                frames = size(stack,4);
                
                startTiffStream(obj,filepath,override,...
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
                if nargin==6, override = varargin{6}; else, override = false; end
                
                startTiffStream(obj,filepath,override,...
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

