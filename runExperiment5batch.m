% Run experiment 5 for all query passes

setup;

CORRIDORS = 2;
PASSES    = 1:10;

thresh = 10;

for c = CORRIDORS
    for p = PASSES
        
        paramsQuery.queryCorridor = c;
        paramsQuery.queryPass     = p;
        
        multipleCellsWithNormalization(paramsDataset, paramsQuery, paramsCells, thresh);
        
    end
    
    pause;
    
end
