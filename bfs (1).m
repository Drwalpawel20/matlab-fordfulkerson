function [path, flow] = bfs(graph, source, sink, ax)
    % BFS do znajdowania ścieżki powiększającej oraz minimalnego przepływu
    n = size(graph, 1);
    visited = false(1, n);
    parent = zeros(1, n);
    minFlow = inf(1, n);  % minimalny przepływ do każdego wierzchołka
    minFlow(source) = inf; % Inicjalizacja dla źródła
    queue = [source];
    visited(source) = true;
    parent(source) = -1;

    % Inicjalizacja wizualizacji
    if isvalid(ax)
        visualizeGraph(graph, ax, [], sprintf('BFS: Searching for path from %d to %d...', source, sink), false);
        pause(0.5);
    end

    while ~isempty(queue)
        u = queue(1);
        queue(1) = [];

        for v = 1:n
            if ~visited(v) && graph(u, v) > 0
                visited(v) = true;
                parent(v) = u;
                minFlow(v) = min(minFlow(u), graph(u, v));
                queue(end + 1) = v;

                % Aktualizacja wizualizacji
                if isvalid(ax)
                    currentPath = getPath(parent, source, v);
                    visualizeGraph(graph, ax, currentPath, ...
                        sprintf('BFS: Exploring node %d...', v), false);
                    pause(0.3);
                end

                if v == sink
                    break; % znaleziono ujście, można wyjść wcześniej
                end
            end
        end
    end

    % Odtwarzanie ścieżki
    path = getPath(parent, source, sink);
    if isempty(path)
        flow = 0;
        if isvalid(ax)
            visualizeGraph(graph, ax, [], 'BFS: No path found', false);
            pause(0.5);
        end
    else
        flow = minFlow(sink);
    end
end