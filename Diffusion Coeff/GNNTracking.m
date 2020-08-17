function tracks = GNNTracking(f, positions, maxLRMovment, maxUDMovment, maxBlink )
    
    maxDist = maxLRMovment^2 + maxUDMovment^2;
    numFrames = size(positions,1);
    maxNum = max(arrayfun( @(i) size(positions{i},1), 1:numFrames));

    %% Particles -> Segments
    segments = zeros(maxNum*numFrames,numFrames); % pre-alloc
    
    s = size(positions{1},1);
    segments(1:s,1) = 1:s;

    hWB = uiprogressdlg(f,'Title','Please Wait',...
                        'Message','Tracking particles: Particles -> Segments');
                            
    for f = 1:numFrames-1
        posF  = positions{f};
        posF1 = positions{f+1};

        numF  = size(posF,1);
        numF1 = size(posF1,1);

        if numF1 == 0
            continue;
        elseif numF ==0
            segments(s+1:s+numF1, f+1) = 1:numF1;
            s = s+numF1;
            continue;
        end

        distXY = abs(repmat(posF,1,1,numF1) - permute(repmat(posF1,1,1,numF),[3 2 1]));
        distXY([distXY(:,1,:) > maxLRMovment, distXY(:,2,:) > maxUDMovment]) = inf;
        cost = permute(sum(distXY .^ 2,2),[1 3 2]);
        
        [assignments,~,unassignedcolumns] = assignauction(cost, maxDist);
        
        % assignments
        for i = 1:size(assignments,1)
            idF  = assignments(i,1);
            idF1 = assignments(i,2);
            
            segments(segments(:,f)==idF, f+1) = idF1;
        end
        
        % unassigned
        segments(s+1:s+size(unassignedcolumns,1),f+1) = unassignedcolumns;
        s = s+size(unassignedcolumns,1);
        
        hWB.Value = f/(numFrames-1);
    end
    
    
    segments = segments(1:s,:);
    numSegs = size(segments,1);
    
    if maxBlink > 0
        %% Segments -> Gap Costs
        costs = Inf * ones(numSegs);
        
        hWB.Message = 'Tracking particles: Segments -> Gap Costs';
        for s = 1:numSegs
            endF   = find(segments(s,:),1,'last');
            endID  = segments(s,endF);
            endPos = positions{endF}(endID,:);
            
            for c = 1:numSegs
                startF = find(segments(c,:),1);
                if startF > endF && startF <= endF+maxBlink
                    startID  = segments(c,startF);
                    startPos = positions{startF}(startID,:);
                
                    distXY = abs(endPos - startPos);
                    if distXY(1) <= maxLRMovment && distXY(2) <= maxUDMovment
                        costs(s,c) = sum(distXY.^2);
                    end
                end
            end
            
            hWB.Value = s/numSegs;
        end

        %% Gap Costs -> Joined Segments
        [assignments,~,~] = assignauction(costs, maxDist);
        for i = size(assignments,1):-1:1
            startSeg = assignments(i,2);
            endSeg   = assignments(i,1);

            segments(startSeg,:) = sum( [segments(startSeg,:); segments(endSeg,:)] );
        end
        segments(assignments(:,1),:) = [];
        numSegs = size(segments,1);
    end
    
    
    %% Joined Segments -> Tracks
    tracks = struct;
    
    hWB.Message = 'Tracking particles: Joined Segments -> Tracks';
    for s = 1:numSegs
        seg = segments(s,:)';
        segStart = find(seg,1);
        segEnd   = find(seg,1,'last');
        
        tracks(s).positions.frames = segStart:segEnd;

        f = segStart;
        while f <= segEnd
            if seg(f) == 0 % fill any gaps
                nextDetection = find(seg(f+1:end),1) + f;
                gapWidth = nextDetection - f;
                                
                estPos = [linspace(positions{f-1}(seg(f-1),1), positions{f+gapWidth}(seg(f+gapWidth),1), gapWidth)',...
                          linspace(positions{f-1}(seg(f-1),2), positions{f+gapWidth}(seg(f+gapWidth),2), gapWidth)'];
                
                tracks(s).positions.centers(f-segStart+1:f-segStart+gapWidth,1:2) = estPos; 
                f = f + gapWidth;
            else
                tracks(s).positions.centers(f-segStart+1,1:2) = positions{f}(seg(f),:);
                f = f + 1;
            end
        end
        
        hWB.Value = s/numSegs;
    end
    
    close(hWB);

end

