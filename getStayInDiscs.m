function [polyG,polyG_int,bnd] = getStayInDiscs(the,Cw,Rw,Delta)

[numRows,numCols,lenW,numP] = size( Cw );

polyG(1,1,1,1) = polyshape();
polyG_int(1,1) = polyshape();
bnd = Inf*ones(numRows,numCols,lenW,1e5);
% gMin = zeros(numRows,lenW);
% temp(1,2) = polyshape();

for w_index=1:lenW
    for p_index=1:numP
        C = Cw(:,:,w_index,p_index);
        R = Delta(:,:,w_index).*Rw(:,:,w_index,p_index);        
        polyG(1:numRows,1:numCols,w_index,p_index) = getPolyDiscs(the,C,R);
    end
end

for w_index=1:lenW
    for row=1:numRows
        for col=1:numCols
            polyG_int(row,col,w_index) = intersect( squeeze(polyG(row,col,w_index,:)),'KeepCollinearPoints',false  );
            
            [x,y] = boundary( polyG_int(row,col,w_index) );
            bnd(row,col,w_index,1:length(x)) = x+1i*y;
        end
        
        
    end
    
    % for row=1:2
    %     [x,y] = boundary( polyG_int(row,w_index) );
    %     bnd(row,w_index,1:length(x)) = x+1i*y;
    %     [~,ind] = min( abs(bnd(row,w_index,:)) );
    %     gMin(row,w_index) = bnd(row,w_index,ind);
    % end
    
end
