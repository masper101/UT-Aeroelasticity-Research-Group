function plot_areaerrorbar(x_axis,y_mean,y_err,color)

    % Default options        
    if color == [0,0.447,0.741]
        options.color_area = [128 193 219]./255;    % Blue theme
    elseif color == [0.850,0.325,0.098]
        options.color_area = [243 169 114]./255;    % Orange theme
    end
    options.alpha      = 0.5;
    options.line_width = 2;

    x_vector = [x_axis', fliplr(x_axis')];
    patch = fill(x_vector, [y_mean+y_err,fliplr(y_mean-y_err)], options.color_area);
    set(patch, 'edgecolor', 'none');
    set(patch, 'FaceAlpha', options.alpha);
    plot(x_axis, y_mean, '-','color', color, ...
        'LineWidth', options.line_width);
    
end