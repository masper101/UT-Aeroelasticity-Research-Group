function CompileData(MeanData, AvgData,filename,dir)
%COMPILES AvgData AND MeanData INTO XLSX FILE
%
% INPUTS
%     MeanData
%     AvgData
%     filename  -> name of file 'XXX.xlsx'
%     dir       -> location of where file will be saved to
% OUTPUTS
%     XLSX FILE -> each file contains a sheet for each mean data file in the
%                  leaded directory, usually corresponding to a sheet per
%                  index angle per RPM 


for j = 1:length(MeanData.names)
             
    M = {};
    M(:,1) = {'Axial Spacing',nan,'UPPER',nan,nan,nan,nan,nan,nan,'LOWER',nan,nan,nan,nan,nan,nan,'TOTAL',nan,nan,nan,nan,nan,nan};
    M(:,2) = {'','RPM','THETA_0','Ctsigma','UNCERTAINTY','Cpsigma','UNCERTAINTY','FM','UNCERTAINTY','THETA_0','Ctsigma','UNCERTAINTY','Cpsigma','UNCERTAINTY','FM','UNCERTAINTY','THETA_0','Ctsigma','UNCERTAINTY','Cpsigma','UNCERTAINTY','FM','UNCERTAINTY'};
    
    data = MeanData.data{j};
    M(1,2) = {join([string(data.Var5(2)),'chord'])};
    
    A = [];
    count = 1;
    
    for k = 1:length(AvgData.names)
        if contains(AvgData.names{k}, MeanData.names{j}(1:13)) == 1
            loc = contains(data.Var25,AvgData.names{k});
%             loc = contains(data.Var23,AvgData.names{k}); %SPRING 2019 
           
            if class(data.Var2(loc)) == 'double'
                Ucol = (data.Var22(loc));
                Lcol = (data.Var23(loc));
%                 Ucol = (data.Var2(loc)); %SPRING 2019 
%                 Lcol = (data.Var2(loc)); %SPRING 2019 
                Tcol = (data.Var2(loc));
                RPM = round(data.Var1(loc),-2);
                indangle = (data.Var4(2));
            else
                Ucol = str2double(string(data.Var22(loc)));
                Lcol = str2double(string(data.Var23(loc)));
%                 Ucol = str2double(string(data.Var2(loc))); %SPRING 2019 
%                 Lcol = str2double(string(data.Var2(loc))); %SPRING 2019 
                Tcol = str2double(string(data.Var2(loc)));
                RPM =round(str2double(data.Var1(loc)),-2);
                indangle = str2double(data.Var4(2));
            end
            
            if Ucol == Lcol
                cts_U = AvgData.avg_cts_outer{k};
                cts_L = AvgData.avg_cts_inner{k};
                cts_T = AvgData.avg_cts_total{k};
                cps_U = AvgData.avg_cps_outer{k};
                cps_L = AvgData.avg_cps_inner{k};
                cps_T = AvgData.avg_cps_total{k};
                FM_U = AvgData.avg_FM_outer{k};
                FM_L = AvgData.avg_FM_inner{k};
                FM_T = AvgData.avg_FM_tot{k};
                
                e_cts_U = AvgData.err_cts_outer{k};
                e_cts_L = AvgData.err_cts_inner{k};
                e_cts_T = AvgData.err_cts_total{k};
                e_cps_U = AvgData.err_cps_outer{k};
                e_cps_L = AvgData.err_cps_inner{k};
                e_cps_T = AvgData.err_cps_total{k};
                e_FM_U = AvgData.err_FM_outer{k};
                e_FM_L = AvgData.err_FM_inner{k};
                e_FM_T = AvgData.err_FM_tot{k};
                
                A(:,count) = [nan,RPM,Ucol, cts_U, e_cts_U, cps_U, e_cps_U, FM_U, e_FM_U, Lcol, cts_L, e_cts_L, cps_L, e_cps_L, FM_L, e_FM_L, Tcol, cts_T, e_cts_T, cps_T, e_cps_T, FM_T, e_FM_T];
                
                count = count+1;
            end
            
        end
    end

    [A_sort, A_order] = sort(A(17,:));
    A = A(:,A_order);
    A = array2table(A);
    
    sheetname = join(['Ind Ang = ',num2str(indangle), ', RPM = ',num2str(RPM)]);
    M = cell2table(M);
    M = [M,A];
    cd(dir)
    writetable(M,filename,'sheet',sheetname,'WriteVariableNames',false);
end



