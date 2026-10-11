function [maxFlow, allPaths] = runFordFulkerson(graph, source, sink, ax)
    % Implementacja algorytmu Forda-Fulkersona z wizualizacją
    n = size(graph, 1);
    flowGraph = zeros(n, n); % Graf przepływowy do śledzenia przepływów
    maxFlow = 0;
    allPaths = struct('path', {}, 'flow', {});
    step = 0;
    maxIterations = 100;

    % Inicjalna wizualizacja grafu
    if isvalid(ax)
        visualizeGraph(graph, ax, [], 'Initial Graph', false);
        pause(1);
    end

    while step < maxIterations
        % Tworzenie grafu resztkowego
        residualGraph = zeros(n, n);
        for u = 1:n
            for v = 1:n
                % Forward edge: remaining capacity
                if graph(u, v) > 0
                    residualGraph(u, v) = graph(u, v) - flowGraph(u, v);
                end
                % Backward edge: flow that can be pushed back
                if flowGraph(u, v) > 0
                    residualGraph(v, u) = flowGraph(u, v);
                end
            end
        end

        % Znajdowanie ścieżki powiększającej
        [path, pathFlow] = bfs(residualGraph, source, sink, ax);
        if isempty(path)
            break; % Brak ścieżki, kończymy algorytm
        end

        step = step + 1;

        % Zapis ścieżki
        allPaths(end+1).path = path; %#ok<AGROW>
        allPaths(end).flow = pathFlow;

        % Aktualizacja grafu przepływowego
        for i = 2:length(path)
            u = path(i-1);
            v = path(i);
            % Jeśli to krawędź do przodu, zwiększamy przepływ
            if graph(u, v) > 0
                flowGraph(u, v) = flowGraph(u, v) + pathFlow;
            else
                % Jeśli to krawędź wsteczna, zmniejszamy przepływ w przeciwnym kierunku
                flowGraph(v, u) = flowGraph(v, u) - pathFlow;
            end
        end

        % Aktualizacja maksymalnego przepływu
        maxFlow = maxFlow + pathFlow;

        % Wizualizacja kroku
        if isvalid(ax)
            visualizeGraph(graph, ax, path, ...
                           sprintf('Step %d: Path %s, Flow = %d', step, mat2str(path), pathFlow), false, flowGraph);
            pause(1);
        end
    end

    % Końcowa wizualizacja
    if isvalid(ax)
        visualizeGraph(graph, ax, allPaths, ...
                       sprintf('Final Result: Max Flow = %d', maxFlow), true, flowGraph);
    end
end