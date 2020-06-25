function testdata = fCheckCorrelation_Ac(testdata)

for micnum = 9
    
    [~,loc] = max(testdata(micnum).dbdata);
    twoper = testdata(micnum).fvec(loc);
    oneper = twoper / 2; % assuming 2 per rev is dominant 
    trev = 1/oneper;
    Nsamprev = round(trev*testdata(micnum).fs);
    Nrev = round(length(testdata(micnum).tvec)/Nsamprev); 
    
    t = zeros(Nsamprev, Nrev);
    P = zeros(Nsamprev, Nrev);   
    for i = 1:Nrev
        t(:,i) = testdata(micnum).tvec(1+(i-1)*Nsamprev:i*Nsamprev);
        P(:,i) = testdata(micnum).Pdata_t(1+(i-1)*Nsamprev:i*Nsamprev);
    end
    oaspl = fOverallSPL_time(P,t);

    threshholdmin = mean(oaspl) - 1.96*std(oaspl);
    threshholdmax = mean(oaspl) + 1.96*std(oaspl);
    testdata(micnum).badrevs = (threshholdmin > oaspl)|(oaspl > threshholdmax);

    
    revs = 1:1:150;
    goodrevs = revs;
    goodrevs(115:132) = 0;
    testdata(micnum).badrevs = revs ~=goodrevs;
    
    P_corr = P(:,~testdata(micnum).badrevs);
    
    rvs = 1:1:150;
    plot(rvs,oaspl)
    hold on
    plot(rvs(testdata(micnum).badrevs),oaspl(testdata(micnum).badrevs),'o')
    
    testdata(micnum).Pdata_t_corr = P_corr(:);
    testdata(micnum).tvec_corr = 0: 1/testdata(micnum).fs: (length(P_corr(:))-1)/testdata(micnum).fs;
    [testdata(micnum).fvec_corr, testdata(micnum).Pdata_corr, ~, ~] = ffind_dft(testdata(micnum).tvec_corr, testdata(micnum).Pdata_t_corr, 0);
 
    if micnum == 9
    az = linspace(0,360,Nsamprev);
    stat_type = 'std';
    figure()
    gi1(1,1) = gramm('x', az, 'y', P', 'color', [1:1:150]);
    gi1(1,1).set_names('x', 'Azimuth, deg', 'y', 'Pressure [Pa]', 'color', 'Rev.');
    gi1(1,1).geom_line();
    gi1(1,1).stat_summary('type', stat_type, 'geom', 'area')
    gi1.draw();
    end

end

    