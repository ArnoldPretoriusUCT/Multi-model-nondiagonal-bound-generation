function plotLogPolarBounds(bnd,Po,Go,W)

[numRows,numCols,lenW,lenBnd] = size(bnd);

figure

colourArray = ['r','g','b','m','c','k'];

for w_index=1:lenW

    Po_w = freqresp(Po,W(w_index));
    for row=1:numRows
        for col=1:numCols

            mag_array = squeeze( 20*log10( abs(bnd(row,col,w_index,:)*Po_w(row,col)) ) );
            phase_array = squeeze( angle(bnd(row,col,w_index,:)*Po_w(row,col))*180/pi );
            for i=1:length(phase_array)
                if phase_array(i)>0
                    phase_array(i)=phase_array(i)-360;
                end
            end
            
            ind = 2*(row-1)+col;
            subplot(numRows,numCols,ind),hold on
            plot(phase_array,mag_array,'.',Color=colourArray(w_index))

            gw = squeeze( freqresp(Go(row,col),W(w_index)) );
            lw = gw*Po_w(row,col);
            Lmag = 20*log10( abs(lw) );
            Lphi = angle( lw )*180/pi;

            plot(Lphi,Lmag,'o',Color=colourArray(w_index),MarkerFaceColor=colourArray(w_index))
        end
    end
end