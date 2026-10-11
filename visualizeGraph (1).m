function visualizeGraph(graph, ax, path, graphTitle, isFinal, flowGraph)
    % Wizualizacja grafu z opcjonalną ścieżką i przepływem
    if nargin < 5
        isFinal = false;
    end
    if nargin < 6
        flowGraph = zeros(size(graph));
    end

    % Inicjalizacja grafu
    G = digraph(graph);
    axes(ax);
    cla(ax);

    % Ustawienie układu grafu
    p = plot(G, 'Layout', 'force', ...
             'ArrowSize', 15, 'LineWidth', 2, ...
             'NodeFontSize', 12, 'NodeColor', [0.7 0.7 0.7], ...
             'EdgeColor', [0.5 0.5 0.5], 'EdgeFontSize', 10);

    % Ustawienie globalnego koloru etykiet krawędzi
    try
        p.EdgeLabelColor = [0 0 0]; % Czarny kolor etykiet
    catch
        warning('EdgeLabelColor not supported in this MATLAB version. Using default color.');
    end

    % Tworzenie tablicy etykiet
    n = size(graph, 1);
    edgeLabels = cell(1, height(G.Edges));
    edgeCount = 0;
    for u = 1:n
        for v = 1:n
            if graph(u, v) > 0 % Aktualizujemy tylko istniejące krawędzie
                edgeIdx = findedge(G, u, v);
                if edgeIdx > 0
                    edgeCount = edgeCount + 1;
                    if flowGraph(u, v) > 0
                        edgeLabels{edgeCount} = sprintf('%d/%d', flowGraph(u, v), graph(u, v));
                    else
                        edgeLabels{edgeCount} = sprintf('%d', graph(u, v));
                    end
                end
            end
        end
    end

    % Przypisanie etykiet do krawędzi
    if edgeCount == height(G.Edges)
        p.EdgeLabel = edgeLabels;
    else
        warning('Mismatch in number of edge labels. Skipping label update.');
    end

    % Podświetlanie ścieżki
    if ~isempty(path)
        if isFinal && isstruct(path)
            % Wiele ścieżek (wynik końcowy)
            hold on;
            for i = 1:length(path)
                currentPath = path(i).path;
                for j = 1:length(currentPath)-1
                    u = currentPath(j);
                    v = currentPath(j+1);
                    if graph(u, v) > 0
                        highlight(p, u, v, 'EdgeColor', [0 0.8 0], 'LineWidth', 4); % Zielony
                    end
                end
                highlight(p, currentPath(1), 'NodeColor', [0 1 0]); % Zielony dla źródła
                highlight(p, currentPath(end), 'NodeColor', [1 0 0]); % Czerwony dla ujścia
            end
            hold off;
        else
            % Pojedyncza ścieżka (krok po kroku)
            for i = 1:length(path)-1
                u = path(i);
                v = path(i+1);
                if graph(u, v) > 0
                    highlight(p, u, v, 'EdgeColor', [1 0 1], 'LineWidth', 4); % Magenta
                end
            end
            highlight(p, path(1), 'NodeColor', [0 1 0]); % Zielony dla źródła
            highlight(p, path(end), 'NodeColor', [1 0 0]); % Czerwony dla ujścia
        end
    end

    % Ustawienie tytułu
    title(ax, graphTitle, 'FontSize', 14, 'Interpreter', 'none');
    drawnow;
end