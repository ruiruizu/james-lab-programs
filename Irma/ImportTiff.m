classdef ImportTiff
    properties (Access = private)
        lastFrame = 0 % accounts for channels
        lastImage = 0 % does not account for channels
        tiffStream
    end
    
    properties (Access = public)
        width
        height
        channels
        frames % accounts for channels
        images % does not account for channels
    end
    
    methods(Static)
        function obj = start(filepath)
            obj = ImportTiff(filepath);
        end
    end
    
    methods
        function obj = ImportTiff(filepath)
            obj.images = size(imfinfo(filepath),1);
            obj.tiffStream = Tiff(filepath,'r');
            
            obj.height = obj.tiffStream.getTag('ImageLength');
            obj.width = obj.tiffStream.getTag('ImageLength');
            
            % Set Channel
            obj.channels = 1; % first set to default value
            description = obj.tiffStream.getTag('ImageDescription');
            if strcmp(description(1:6),'ImageJ')
                c = extractBetween(description,'channels=',newline);
                if ~isempty(c)
                    obj.channels = str2double(c{1});
                end
            end
            
            obj.frames = obj.images/obj.channels;
        end
        
        function I = nextFrame(obj)
            I = getFrame(obj,obj.lastFrame+1);
        end
        
        function S = getFrame(obj,f)
            obj.lastFrame = f;
            obj.lastImage = f+obj.channels-1;
            
            S = zeros(obj.height, obj.width, obj.channels, 'uint16');
            for c = 1:obj.channels
                obj.tiffStream.setDirectory(f+c-1);
                S(:,:,c) = obj.tiffStream.read();
            end
        end
        
        function S = getStack(obj)
            S = zeros(obj.height, obj.width, obj.channels, obj.frames, 'uint16');
            for f = 1:obj.frames
                S(:,:,:,f) = getFrame(obj,f);
            end
        end
        
        function delete(obj)
            close(obj.tiffStream);
        end
        
        function close(obj)
            delete(obj);
        end
        
    end
end

