function path = getPath(parent, source, sink)
    % Odtwarzanie ścieżki z tablicy parent
    if parent(sink) == 0
        path = [];
        return;
    end

    path = [];
    current = sink;
    while current ~= -1
        path = [current path];
        current = parent(current);
    end

    if path(1) ~= source
        path = [];
    end
end