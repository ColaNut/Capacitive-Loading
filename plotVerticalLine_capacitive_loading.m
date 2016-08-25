function plotVerticalLine_capacitive_loading( figure, layer_num, AccuDepth, Max, Min, lengthX )

figure;

hold on
for idx = 1: 1: layer_num - 1
    x_tmp = AccuDepth(idx) * ones(1, lengthX);
    y_tmp = Min: ( Max - Min ) / (lengthX - 1) : Max;
    plot(x_tmp, y_tmp, 'Color', [0.8, 0.8, 0.8], 'LineWidth', 2.5 );
end
hold off

end

