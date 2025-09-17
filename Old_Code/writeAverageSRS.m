function writeAverageSRS(filename)
    [CH_f,CH_X_avg,CH_Y_avg,CH_Z_avg] = loadSRSDataFile(filename)

    T = table(CH_f,CH_X_avg,CH_Y_avg,CH_Z_avg)

    writetable(T,strcat(filename,'_SRS_data.xlsx'),'Sheet',1,'WriteVariableNames',true)

end