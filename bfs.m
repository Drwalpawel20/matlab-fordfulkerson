function [path, flow] = bfs(graph, source, sink, ax)
    % BFS寻找从源到汇的路径并计算最小流量
    n = size(graph, 1);
    visited = false(1, n);
    parent = zeros(1, n);
    minFlow = inf(1, n); % Minimalny przepływ do każdego wierzchołka
    queue = [source];
    visited(source) = true;
    parent(source) = -1;
    minFlow(source) = inf;

    % Inicjalizacja wizualizacji
    if isvalid(ax)
        visualizeGraph(graph, ax, [], sprintf('BFS: Searching for path from %d to %d...', source, sink), false);
        pause(0.5);
    end

    % Algorytm BFS
    while ~isempty(queue)
        u = queue(1);
        queue(1) = [];
        for v = 1:n
            if ~visited(v) && graph(u, v) > 0
                flowToV = min(minFlow(u), graph(u, v));
                if flowToV > 0
                    visited(v) = true;
                    parent(v) = u;
                    minFlow(v) = flowToV;
                    queue(end+1) = v;

                    % Aktualizacja wizualizacji
                    if isvalid(ax)
                        currentPath = getPath(parent, source, v);
                        visualizeGraph(graph, ax, currentPath, ...
                                       sprintf('BFS: Exploring node %d...', v), false);
                        pause(0.3);
                    end
                end
            end
        end
    end

    % Sprawdzanie, czy istnieje ścieżka do ujścia
    if ~visited(sink)
        path = [];
        flow = 0;
        if isvalid(ax)
            visualizeGraph(graph, ax, [], 'BFS: No path found', false);
            pause(0.5);
        end
        return;
    end

    % Odtwarzanie ścieżki i przepływu
    path = getPath(parent, source, sink);
    flow = minFlow(sink);
end

function path = getPath(parent, source, sink)
    % Odtwarzanie ścieżki na podstawie tablicy parent
    path = [];
    v = sink;
    while v ~= -1
        path = [v path];
        v = parent(v);
    end
    if isempty(path) || path(1) ~= source
        path = [];
    end
end