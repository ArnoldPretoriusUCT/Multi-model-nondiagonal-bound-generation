function polyMat = getPolyDiscs(the,C,R)
[numRows,numCols] = size(C);

polyMat(1,1) = polyshape();

rr = 1e3;

for row=1:numRows
    for col=1:numCols
        c = C(row,col);
        r = R(row,col);
        if(r<=0)
            r
            disp('r less than zero')
            polyMat(row,col) = polyshape();
            return
        elseif( r > rr )
            r = rr;
            c = 0;
        end
        
        circ = c+r*exp(1i*the);
        polyMat(row,col) = polyshape(real(circ),imag(circ),'Simplify',false, 'KeepCollinearPoints',true);        
    end
end
