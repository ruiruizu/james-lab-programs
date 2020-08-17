function particles = WLSGMMFit(Z,X,Y,clusterSize,B,pA,pU,pL)
    particles = struct( 'x',[],...
                        'y',[],...
                        's', [],...
                        'A', [],...
                        'B', [],...
                        'sse', []);
                    
    p = cell(clusterSize,2);
    for j = 1:clusterSize
        GMMFun = getGMMFun(j);
                
        p0 = pA(1:(j*4));
        p0 = [B, p0(:)'];
        
        pU0 = pU(1:(j*4));
        pU0 = [B*2, pU0(:)'];
        
        pL0 = pL(1:(j*4));
        pL0 = [0, pL0(:)'];
        
        op = optimoptions(  'lsqnonlin',...
            'Algorithm',    'trust-region-reflective',...
            'MaxIter',      100,...
            'MaxFunEvals',  200,...
            'TolFun',       0.00001*numel(Z),...
            'TolX',         0.00001,...
            'DiffMinChange',0,...
            'DiffMaxChange',Inf,...
            'Display',      'off');
        [p{j,1}, p{j,2}] = lsqnonlin(GMMFun(X,Y,Z),p0,pL0,pU0,op);
    end

    [bestSSE, bestCluster] = min([p{:,2}]);
    if p{bestCluster,2} == Inf
        return;
    end

    for j = 1:bestCluster
        particles(j).x = p{bestCluster,1}(j*4-1);
        particles(j).y = p{bestCluster,1}(j*4);
        particles(j).s = p{bestCluster,1}(j*4+1);
        particles(j).A = p{bestCluster,1}(j*4-2);
        particles(j).B = p{bestCluster,1}(1);
        particles(j).sse = bestSSE;
    end

end

function GMMFun = getGMMFun(GMMSize)    
    GMMFun = '@(X,Y,Z) @(x) x(1)';
    for i = 1:GMMSize
        GMMFun = [GMMFun, ' + ', sprintf('x(%i) * exp(((X(:)-x(%i)).^2 + (Y(:)-x(%i)).^2) / (-2*x(%i))) / (2*pi*x(%i))', [i*4-2,i*4-1, i*4, i*4+1, i*4+1])];
    end
    GMMFun = [GMMFun, ' - Z(:)'];
    
    GMMFun = str2func(GMMFun);
end
