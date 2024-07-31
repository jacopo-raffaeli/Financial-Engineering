function PlotVega(S0,vega)
%plotting Vega

figure;
plot(S0, vega,LineWidth=2);
xlabel('Underlying Price');
ylabel('Vega');
title('Vega of European Call Option with Barrier at €1.3');
grid on;

end