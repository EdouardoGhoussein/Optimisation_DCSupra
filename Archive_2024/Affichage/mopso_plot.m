function mopso_plot(plt_options)
    %format de plt_options:
    % plt_options.filename : fichier contenant les données d'optimisation
    % MOPSO
    % plt_options.var_labels : liste des noms des variables à afficher
    % (attention à utiliser " " et non ' ')
    % plt_options.obj_labels : liste des noms des objectifs (idem) (2)
    % plt_options.title : titre du graphique principal
    % plt_options.bounds : table des bornes des variables, avec une rangée
    % par variable (on peut utiliser la table qui sert au MOPSO)

    nbvar = length(plt_options.var_labels);
    rows = ceil(nbvar/1);

    simout = load(plt_options.filename);

    figure(1)
    hold on
    plot(simout.Front_Pareto_Objectifs(1,:),simout.Front_Pareto_Objectifs(2,:),'or','Markersize',4); %pareto
    plot(simout.Memoires_Objectifs(1,:),simout.Memoires_Objectifs(2,:),'.r','Markersize',4); %memory
    yl = ylim;
    yl = [max([-1.2*abs(min(simout.Front_Pareto_Objectifs(2,:))) yl(1)]) min([1.2*abs(max(simout.Front_Pareto_Objectifs(2,:))) yl(2)])];
    xl = xlim;
    xl = [max([-1.2*abs(min(simout.Front_Pareto_Objectifs(1,:))) xl(1)]) min([1.2*abs(max(simout.Front_Pareto_Objectifs(1,:))) xl(2)])];
    xlim(xl);
    ylim(yl);

    
    xlabel(plt_options.obj_labels(1))
    ylabel(plt_options.obj_labels(2))
    title(plt_options.title)
    grid on
    
    figure(2)
    hold on
    for k = 1:nbvar
        subplot(rows,1,k)
        plot(simout.Front_Pareto_Objectifs(1,:),simout.Front_Pareto_Parametres(k,:),'o','Markersize',4)
        xlabel(plt_options.obj_labels(1))
        ylabel(plt_options.var_labels(k))
        yline(plt_options.bounds(k,1), 'g')
        yline(plt_options.bounds(k,2), 'g')
        legend('hide')
    end
    hold off
end