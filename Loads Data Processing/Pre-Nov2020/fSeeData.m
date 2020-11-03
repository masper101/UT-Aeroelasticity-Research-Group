function [] = fSeeData(rotor, MeanData, SortedData, RevData)
% INTERACTIVELY PLOTS DATA 
%   Detailed explanation goes here

%% LIST OPERATING POINTS

fprintf('\n%s\n', 'Loaded data points are ');
uRPMs = unique(MeanData.RPMs');

fprintf('\n%s\t%s\n', 'Rotor speeds, RPM : ', num2str(uRPMs));
switch rotor
    case 'Uber'
        uzcs = unique(MeanData.zcs');
        uphis = unique(MeanData.phis');
        umcols = unique(MeanData.meancols');
        udcols = unique(MeanData.diffcols');
        fprintf('%s\t%s\n', 'Axial spacing, z/c : ', num2str(uzcs));
        fprintf('%s\t%s\n', 'Index angle, deg : ', num2str(uphis));
        fprintf('%s\t%s\n', 'Mean collective, deg : ', num2str(umcols));
        fprintf('%s\t%s\n\n', 'Diff collective, deg : ', num2str(udcols));
    case 'CCR'
        umcols_in = unique(MeanData.cols_in');
        umcols_out = unique(MeanData.cols_out');
        fprintf('%s\t%s\n', 'Inner collective, deg : ', num2str(umcols_in));
        fprintf('%s\t%s\n\n', 'Outer collective, deg : ', num2str(umcols_out));
    otherwise
end

%% PLOT DATA

plotting = true;

while plotting == true
    thirdvar = [];
    switch rotor
        case 'Uber'
            % select a set of operating conditions
            if length(uRPMs) > 1
                pRPMs = input('RPMs to plot : ');
                if (length(pRPMs)>1) && isempty(thirdvar)
                    thirdvar = pRPMs;
                else
                    pRPMs = pRPMs(1);
                end
            else
                pRPMs = uRPMs;
            end
            if length(uzcs) > 1
                pzcs = input('Axial spacings to plot : ');
                if (length(pzcs)>1) && isempty(thirdvar)
                    thirdvar = pzcs;
                else
                    pzcs = pzcs(1);
                end
            else
                pzcs = uzcs;
            end
            if length(uphis) > 1
                pphis = input('Index angles to plot : ');
                if (length(pphis)>1) && isempty(thirdvar)
                    thirdvar = pphis;
                else
                    pphis = pphis(1);
                end
            else
                pphis = uphis;
            end
            if length(umcols) > 1
                pmcols = input('Mean collectives to plot : ');
                if (length(pmcols)>1) && isempty(thirdvar)
                    thirdvar = pmcols;
                else
                    pmcols = pmcols(1);
                end
            else
                pmcols = umcols;
            end
            if length(udcols) > 1
                pdcols = input('Diff. collectives to plot : ');
                if (length(pdcols)>1) && isempty(thirdvar)
                    thirdvar = pdcols;
                else
                    pdcols = pdcols(1);
                end
            else
                pdcols = udcols;
            end
            % identify corresponding data files
            fnos_pRPMs = (MeanData.RPMs == pRPMs);
            fnos_pzcs = (MeanData.zcs == pzcs);
            fnos_pphis = (MeanData.phis == pphis);
            fnos_pmcols = (MeanData.meancols == pmcols);
            fnos_pdcols = (MeanData.diffcols == pdcols);

            fnos_p = (fnos_pRPMs & fnos_pzcs & fnos_pphis & fnos_pmcols & fnos_pdcols);
            
        case 'CCR'
            % select a set of operating conditions
            if length(uRPMs) > 1
                pRPMs = input('RPMs to plot : ');
                if (length(pRPMs)>1) && isempty(thirdvar)
                    thirdvar = pRPMs;
                else
                    pRPMs = pRPMs(1);
                end
            else
                pRPMs = uRPMs;
            end
            if length(umcols_in) > 1
                pmcols_in = input('Inner collectives to plot : ');
                if (length(pmcols_in)>1) && isempty(thirdvar)
                    thirdvar = pmcols_in;
                else
                    pmcols_in = pmcols_in(1);
                end
            else
                pmcols_in = umcols_in;
            end
            if length(umcols_out) > 1
                pmcols_out = input('Outer collectives to plot : ');
                if (length(pmcols_out)>1) && isempty(thirdvar)
                    thirdvar = pmcols_out;
                else
                    pmcols_out = pmcols_out(1);
                end
            else
                pmcols_out = umcols_out;
            end
            % identify corresponding data files
            fnos_pRPMs = (MeanData.RPMs == pRPMs);
            fnos_pmcols_out = (MeanData.cols_out == pmcols_out);
            fnos_pmcols_in = (MeanData.cols_in == pmcols_in);

            fnos_p = (fnos_pRPMs & fnos_pmcols_out & fnos_pmcols_in);
end
    
    % choose corresponding files
    [~,nvars] = size(fnos_p);   % nvars > 1 only if there is a thirdvar 
    for ii = 1:nvars
        yvar_Fxi = cell2mat(SortedData.Fx_inner(fnos_p(:,ii))');   % [ (Nrevs x nfiles) x Naz ]
        yvar_Fyi = cell2mat(SortedData.Fy_inner(fnos_p(:,ii))');
        yvar_Fzi = cell2mat(SortedData.Fz_inner(fnos_p(:,ii))');
        yvar_Mxi = cell2mat(SortedData.Mx_inner(fnos_p(:,ii))');
        yvar_Myi = cell2mat(SortedData.My_inner(fnos_p(:,ii))');
        yvar_Mzi = cell2mat(SortedData.Mz_inner(fnos_p(:,ii))');
        yvar_Fxo = cell2mat(SortedData.Fx_outer(fnos_p(:,ii))');
        yvar_Fyo = cell2mat(SortedData.Fy_outer(fnos_p(:,ii))');
        yvar_Fzo = cell2mat(SortedData.Fz_outer(fnos_p(:,ii))');
        yvar_Mxo = cell2mat(SortedData.Mx_outer(fnos_p(:,ii))');
        yvar_Myo = cell2mat(SortedData.My_outer(fnos_p(:,ii))');
        yvar_Mzo = cell2mat(SortedData.Mz_outer(fnos_p(:,ii))');
    end
    xvar = cell2mat(SortedData.azimuth(fnos_p(:,ii))');
    xvar = xvar(1,:);   % keep only the first row [ 1 x Naz ]
     
    close all
    clear gi1 gi2 go1 go2
    [nrevs,~] = size(yvar_Fxi);
    
    stat_type = 'std';
    rev_vec = 1:1:nrevs;

    gi1(1,1) = gramm('x', xvar, 'y', yvar_Fxi, 'color', rev_vec);
    gi1(1,1).set_names('x', 'Azimuth, deg', 'y', 'Fx_inner, N', 'color', 'Rev.');
    gi1(1,1).geom_line();
    gi1(1,1).stat_summary('type', stat_type, 'geom', 'area');

    gi1(1,2) = gramm('x', xvar, 'y', yvar_Fyi, 'color', rev_vec);
    gi1(1,2).set_names('x', 'Azimuth, deg', 'y', 'Fy_inner, N', 'color', 'Rev.');
    gi1(1,2).geom_line();
    gi1(1,2).stat_summary('type', stat_type, 'geom', 'area');

    gi1(1,3) = gramm('x', xvar, 'y', yvar_Fzi, 'color', rev_vec);
    gi1(1,3).set_names('x', 'Azimuth, deg', 'y', 'Fz_inner, N', 'color', 'Rev.');
    gi1(1,3).geom_line();
    gi1(1,3).stat_summary('type', stat_type, 'geom', 'area');

    gi1(2,1) = gramm('x', xvar, 'y', yvar_Mxi, 'color', rev_vec);
    gi1(2,1).set_names('x', 'Azimuth, deg', 'y', 'Mx_inner, N', 'color', 'Rev.');
    gi1(2,1).geom_line();
    gi1(2,1).stat_summary('type', stat_type, 'geom', 'area');

    gi1(2,2) = gramm('x', xvar, 'y', yvar_Myi, 'color', rev_vec);
    gi1(2,2).set_names('x', 'Azimuth, deg', 'y', 'My_inner, N', 'color', 'Rev.');
    gi1(2,2).geom_line();
    gi1(2,2).stat_summary('type', stat_type, 'geom', 'area');

    gi1(2,3) = gramm('x', xvar, 'y', yvar_Mzi, 'color', rev_vec);
    gi1(2,3).set_names('x', 'Azimuth, deg', 'y', 'Mz_inner, N', 'color', 'Rev.');
    gi1(2,3).geom_line();
    gi1(2,3).stat_summary('type', stat_type, 'geom', 'area');

    gi1.axe_property('XGrid', 'on', 'YGrid', 'on', 'XLim', [0 360], 'XTick', 0:60:360, 'Box', 'on');
    gi1.set_text_options('font','Times','base_size',14, 'label_scaling', 1.25);
    figure('Position',[100 200 1800 800]);
    gi1.draw();

    go1(1,1) = gramm('x', xvar, 'y', yvar_Fxo, 'color', rev_vec);
    go1(1,1).set_names('x', 'Azimuth, deg', 'y', 'Fx_outer, N', 'color', 'Rev.');
    go1(1,1).geom_line();
    go1(1,1).stat_summary('type', stat_type, 'geom', 'area');

    go1(1,2) = gramm('x', xvar, 'y', yvar_Fyo, 'color', rev_vec);
    go1(1,2).set_names('x', 'Azimuth, deg', 'y', 'Fy_outer, N', 'color', 'Rev.');
    go1(1,2).geom_line();
    go1(1,2).stat_summary('type', stat_type, 'geom', 'area');

    go1(1,3) = gramm('x', xvar, 'y', yvar_Fzo, 'color', rev_vec);
    go1(1,3).set_names('x', 'Azimuth, deg', 'y', 'Fz_outer, N', 'color', 'Rev.');
    go1(1,3).geom_line();
    go1(1,3).stat_summary('type', stat_type, 'geom', 'area');

    go1(2,1) = gramm('x', xvar, 'y', yvar_Mxo, 'color', rev_vec);
    go1(2,1).set_names('x', 'Azimuth, deg', 'y', 'Mx_outer, N', 'color', 'Rev.');
    go1(2,1).geom_line();
    go1(2,1).stat_summary('type', stat_type, 'geom', 'area');

    go1(2,2) = gramm('x', xvar, 'y', yvar_Myo, 'color', rev_vec);
    go1(2,2).set_names('x', 'Azimuth, deg', 'y', 'My_outer, N', 'color', 'Rev.');
    go1(2,2).geom_line();
    go1(2,2).stat_summary('type', stat_type, 'geom', 'area');

    go1(2,3) = gramm('x', xvar, 'y', yvar_Mzo, 'color', rev_vec);
    go1(2,3).set_names('x', 'Azimuth, deg', 'y', 'Mz_outer, N', 'color', 'Rev.');
    go1(2,3).geom_line();
    go1(2,3).stat_summary('type', stat_type, 'geom', 'area');

    go1.axe_property('XGrid', 'on', 'YGrid', 'on', 'XLim', [0 360], 'XTick', 0:60:360, 'Box', 'on');
    go1.set_text_options('font','Times','base_size',14, 'label_scaling', 1.25);
    figure('Position',[200 200 1800 800]);
    go1.draw();
    
    plotagain = input('Plot again [y n] ? : ','s');
    plotting = strcmp(plotagain, 'y');
end

end

