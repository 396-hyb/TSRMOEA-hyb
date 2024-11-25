function MyFigure(Population)
 
    Population1 = Population;

    Population = Problem.Perturb(Population1.decs,1).best;
    data = Population.objs;  
    plot(data(:,1), data(:,2), 'o');
    title('我的算法-1');
    xlabel('目标 1');
    ylabel('目标 2');
    saveas(gcf, ['Plot_' num2str(1) '.png']);  % 保存为 PNG 文件
    
    Population = Problem.Perturb(Population1.decs,1).best;
    data2 = Population.objs;  
    plot(data2(:,1), data2(:,2), 'o');
    title('我的算法-2');
    xlabel('目标 1');
    ylabel('目标 2');
    saveas(gcf, ['Plot_' num2str(2) '.png']);  % 保存为 PNG 文件
    
    Population = Problem.Perturb(Population1.decs,1).best;
    data3 = Population.objs;  
    plot(data3(:,1), data3(:,2), 'o');
    title('我的算法-3');
    xlabel('目标 1');
    ylabel('目标 2');
    saveas(gcf, ['Plot_' num2str(3) '.png']);  % 保存为 PNG 文件
    
    Population = Problem.Perturb(Population1.decs,1).best;
    data4 = Population.objs;  
    plot(data4(:,1), data4(:,2), 'o');
    title('我的算法-4');
    xlabel('目标 1');
    ylabel('目标 2');
    saveas(gcf, ['Plot_' num2str(4) '.png']);  % 保存为 PNG 文件
    
    Population = Problem.Perturb(Population1.decs,1).best;
    data5 = Population.objs;  
    plot(data5(:,1), data5(:,2), 'o');
    title('我的算法-5');
    xlabel('目标 1');
    ylabel('目标 2');
    saveas(gcf, ['Plot_' num2str(5) '.png']);  % 保存为 PNG 文件
end
             