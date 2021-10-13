function result = analyse(in_matrix, spikeABC_mV, spikeAB_mV, spike_begin, spike_end)
%%
%preallocate a matrix for the following values: peak B, peak A,
%peak C, spikeABC, spike AB, TIME of peak B

result = -100*ones((size(in_matrix,2)-1),7);


%%
%ohranicenie intervalu, v ktorom sa nachadza spike
%the interval which is to the right of the spike

ROWspBEG = 1;
while in_matrix(ROWspBEG,1) < spike_begin
    ROWspBEG = ROWspBEG+1;
end

ROWspEND = ROWspBEG;
while in_matrix(ROWspEND,1 )< spike_end
    ROWspEND = ROWspEND+1;
end

%%
%analyse the spike

for sweep = 2:size(in_matrix,2)
   
%hlada peak B
%find peak B
    %peak B porovnava s s tromi hodnotami vlavo a styroma vpravo, dve vedlajsie hodnoty mozu byt>= peakB
    for rowB = ROWspBEG+3:(ROWspEND-4)    
        if ((in_matrix(rowB,sweep) <= in_matrix(rowB-1,sweep)) && (in_matrix(rowB,sweep) <= in_matrix(rowB-2,sweep)) && (in_matrix(rowB,sweep) < in_matrix(rowB-3,sweep))) && ((in_matrix(rowB,sweep)<= in_matrix(rowB+1,sweep)) && (in_matrix(rowB,sweep) <= in_matrix(rowB+2,sweep)) && (in_matrix(rowB,sweep) < in_matrix(rowB+3,sweep)) && (in_matrix(rowB,sweep)<in_matrix(rowB+4,sweep)))
            peakB = in_matrix(rowB,sweep);
            timeB = in_matrix(rowB,1);
    %ak najde cosi, co mu pripomina peakB, tak hlada peakA a peakC
    %after finding peak B, search for peak A and peak C
            peakA = in_matrix(ROWspBEG,sweep);
            for rowA = ROWspBEG:(rowB-1)                
                if in_matrix(rowA,sweep) > peakA
                    peakA = in_matrix(rowA,sweep);
                    timeA = in_matrix(rowA,1);
                end                                
            end
            peakC = in_matrix(rowB+1,sweep);
            for rowC = (rowB + 1):ROWspEND                
                if in_matrix(rowC,sweep)>peakC
                    peakC = in_matrix(rowC,sweep);
                    timeC = in_matrix(rowC,1);
                end
            end
%Vypocita velkost spikeABC a spike AB a ak je vacsia ako dana hodnota spikeABC_mV a spike AB, tak ho
%povazuje za spike a hladanie ukoncuje, ak najdeny spike podmienky nesplna, hlada dalej.
            spikeABC = (peakA/2 + peakC/2) - peakB;
            spikeAB = peakA - peakB;
            if (spikeABC >= spikeABC_mV) && (spikeAB >= spikeAB_mV)
                result(sweep - 1,1:6) = [peakB, peakA, peakC, 1000*timeB, spikeAB, spikeABC];
                
                figure %show the graph of each trace on keypress, one at a time
                hold on
                title(sweep - 1);
                plot(1000*in_matrix(ROWspBEG:ROWspEND,1),in_matrix(ROWspBEG:ROWspEND,sweep));
                plot([1000*timeB 1000*timeA 1000*timeC],[peakB peakA peakC],'rs','LineWidth',1,'MarkerEdgeColor','k','MarkerFaceColor','g','MarkerSize',8);
                waitforbuttonpress;
                close;
                break
            end
        end

    end
end
%base = mean(result(1:5,6));
%result(:,7) = 100*result(:,6)/base;