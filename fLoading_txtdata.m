%function [Data,filenames] = fLoading_txtdata(Settings)

if Settings.IDvortex.region == false
    
    cd('Z:\pm29293\Isolated_rotor_dynamic_pitch_PIV\TXT_data\BL0.08\steadyCol')
    files = dir('Z:\pm29293\Isolated_rotor_dynamic_pitch_PIV\TXT_data\BL0.08\steadyCol\BL0.08_142201_steadyCol');

    for i = 1:length(files)
    
        filenames{i} = files(i).name;
    
    end

    cd('Z:\pm29293\Isolated_rotor_dynamic_pitch_PIV\TXT_data\BL0.08\steadyCol\BL0.08_142201_steadyCol')
    for n = 3:length(filenames)
    
        disp(['Loading File:  ' num2str(n)])
    
        data = importdata(filenames{n});

        [x,~] = unique(data.data(:,1), 'rows');
%         x = flip(x);
        [y,~] = unique(data.data(:,2), 'rows');
        y = flip(y);
        vx = reshape(data.data(:,3),[length(x),length(y)])';
        vy = reshape(data.data(:,4),[length(x),length(y)])';
                                                                
        Data(n).x = x;
        Data(n).y = y;
        Data(n).vx = vx;                                                
        Data(n).vy = -1*vy;                                                % NEED TO MULTIPLY BY -1 IF THE IMAGE HAS NOT BEEN MIRRORED FOR CAMERA 2
    
      clc
    
    end 

end

if Settings.IDvortex.region == true

    cd('Z:\pm29293\Isolated_rotor_dynamic_pitch_PIV\TXT_data\BL0.08\steadyCol')
    files = dir('Z:\pm29293\Isolated_rotor_dynamic_pitch_PIV\TXT_data\BL0.08\steadyCol\BL0.08_142201_steadyCol');

    for i = 1:length(files)
    
        filenames{i} = files(i).name;
    
    end

    cd('Z:\pm29293\Isolated_rotor_dynamic_pitch_PIV\TXT_data\BL0.08\steadyCol\BL0.08_142201_steadyCol')
    for n = 3:13 % length(filenames)
    
        disp(['Loading File:  ' num2str(n)])

        data = importdata(filenames{n});

        [x,~] = unique(data.data(:,1), 'rows');
%         x = flip(x);
        [y,~] = unique(data.data(:,2), 'rows');
        y = flip(y);
        vx = reshape(data.data(:,3),[length(x),length(y)])';
        vy = reshape(data.data(:,4),[length(x),length(y)])';
                                                                
        Data(n).x = x;
        Data(n).y = y;
        Data(n).vx = vx;                                                
        Data(n).vy = -1*vy;                                                % NEED TO MULTIPLY BY -1 IF THE IMAGE HAS NOT BEEN MIRRORED FOR CAMERA 2
    
        clc
    
    end 
    
    I = 6;
    figure
    quiver(Data(I).x,Data(I).y,Data(I).vx,Data(I).vy,3)
    roi = drawrectangle;

%     Sx1 = -467.7416;
%     Sx2 = -386.6359;
%     Sy1 = 43.8776;
%     Sy2 = 141.8367;
    
    Sx1 = roi.Vertices(1,1);
    Sx2 = roi.Vertices(3,1);
    Sy1 = roi.Vertices(1,2);
    Sy2 = roi.Vertices(3,2);  
        
    close all

    for n = 3:13 % 1:length(filenames)
    
        Sx  = x(x >= Sx1 & x <= Sx2);
        Sy  = y(y >= Sy1 & y <= Sy2);

        for i = 1:length(Sx)
    
            [row_x(i),col_x(i)] = find(Data(I).x == Sx(i));
            
        end
        
        for i = 1:length(Sy)
           
            [row_y(i),col_y(i)] = find(Data(I).y == Sy(i));
        
        end
        

        Svx = vx(row_y,row_x);
        Svy = vy(row_y,row_x);

        Data(n).x  = Sx;
        Data(n).y  = Sy;
        Data(n).vx = Svx;
        Data(n).vy = -1*Svy;
    
    end
    
end

%end