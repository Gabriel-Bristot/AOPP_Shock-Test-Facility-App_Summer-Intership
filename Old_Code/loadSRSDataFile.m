function [CH_f,CH_X_avg,CH_Y_avg,CH_Z_avg] = loadSRSDataFile(filename)

    load(filename,"CH_fn","CH_pos","CH_neg");
    
    CH_f = CH_fn(:,1);
    CH_X_avg = (CH_pos(:,1)+CH_pos(:,4)-CH_neg(:,1)-CH_neg(:,4))/4;
    CH_Y_avg = (CH_pos(:,2)+CH_pos(:,5)-CH_neg(:,2)-CH_neg(:,5))/4;
    CH_Z_avg = (CH_pos(:,3)+CH_pos(:,6)-CH_neg(:,3)-CH_neg(:,6))/4;
end