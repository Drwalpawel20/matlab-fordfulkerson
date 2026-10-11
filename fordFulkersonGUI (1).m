function fordFulkersonGUI()
    % Inicjalizacja GUI
    clc;
    close all;

    % Tworzenie okna GUI
    f = figure('Name', 'Ford-Fulkerson Visualizer', ...
               'Position', [100 100 1200 700], ...
               'NumberTitle', 'off', ...
               'MenuBar', 'none', ...
               'Color', [0.95 0.95 0.95]);

    % Panel na wykres
    axPanel = uipanel('Title', 'Graph Visualization', 'Position', [0.02 0.15 0.65 0.83], ...
                      'BackgroundColor', [1 1 1], 'FontSize', 12);
    ax = axes('Parent', axPanel, 'Position', [0.05 0.05 0.9 0.9], ...
              'Box', 'on', 'FontSize', 12);

    % Panel sterowania
    controlPanel = uipanel('Title', 'Control Panel', 'Position', [0.68 0.15 0.3 0.83], ...
                           'BackgroundColor', [0.98 0.98 0.98], 'FontSize', 12);

    % Instrukcja
    uicontrol('Parent', controlPanel, 'Style', 'text', 'Position', [20 460 220 50], ...
              'String', sprintf('Enter the adjacency matrix:\n(e.g., [0 4 0; 0 0 2; 0 0 0])'), ...
              'HorizontalAlignment', 'left', 'FontSize', 10, 'BackgroundColor', [0.98 0.98 0.98]);

    % Pole tekstowe do macierzy
    matrixBox = uicontrol('Parent', controlPanel, 'Style', 'edit', 'Position', [20 320 220 140], ...
                          'Max', 10, 'FontName', 'Courier', 'FontSize', 10, ...
                          'String', '[0 8 3 0 0 0 0 0; 0 0 0 4 6 0 0 0; 0 0 0 0 0 2 0 0; 0 0 0 0 0 0 0 9; 0 0 0 0 0 0 0 5; 0 0 0 0 0 0 4 0; 0 0 0 0 0 0 0 6; 0 0 0 0 0 0 0 0]');

    % Pola na źródło i ujście
    uicontrol('Parent', controlPanel, 'Style', 'text', 'Position', [20 280 100 20], ...
              'String', 'Source Node:', 'HorizontalAlignment', 'left', 'FontSize', 10, ...
              'BackgroundColor', [0.98 0.98 0.98]);
    sourceBox = uicontrol('Parent', controlPanel, 'Style', 'edit', 'Position', [120 280 50 25], ...
                          'String', '1', 'FontSize', 10);

    uicontrol('Parent', controlPanel, 'Style', 'text', 'Position', [20 250 100 20], ...
              'String', 'Sink Node:', 'HorizontalAlignment', 'left', 'FontSize', 10, ...
              'BackgroundColor', [0.98 0.98 0.98]);
    sinkBox = uicontrol('Parent', controlPanel, 'Style', 'edit', 'Position', [120 250 50 25], ...
                        'String', '8', 'FontSize', 10);

    % Przycisk start
    uicontrol('Parent', controlPanel, 'Style', 'pushbutton', 'String', 'Start Visualization', ...
              'Position', [20 200 220 35], 'Callback', @startAlgorithm, ...
              'FontSize', 12, 'BackgroundColor', [0.8 0.9 0.8]);

    % Pole na wyniki
    resultText = uicontrol('Parent', controlPanel, 'Style', 'text', 'Position', [20 20 220 170], ...
                           'String', 'Max Flow: Not calculated yet', ...
                           'HorizontalAlignment', 'left', 'FontSize', 11, ...
                           'BackgroundColor', [1 1 1], 'FontName', 'Arial');

    % Zapisywanie danych
    data.ax = ax;
    data.resultText = resultText;
    guidata(f, data);

    % Callback dla przycisku Start
    function startAlgorithm(~, ~)
        data = guidata(f);
        try
            % Pobieranie i walidacja danych
            matrixStr = get(matrixBox, 'String');
            graph = str2num(matrixStr); %#ok<ST2NM>
            if isempty(graph) || size(graph, 1) ~= size(graph, 2)
                error('Adjacency matrix must be square and properly formatted.');
            end

            n = size(graph, 1);
            source = str2double(get(sourceBox, 'String'));
            sink = str2double(get(sinkBox, 'String'));

            % Walidacja source i sink
            if isnan(source) || isnan(sink) || source < 1 || source > n || sink < 1 || sink > n || source == sink
                error('Source and sink must be valid nodes in the graph (1 to %d) and cannot be the same.', n);
            end

            % Uruchomienie algorytmu
            [maxFlow, allPaths] = runFordFulkerson(graph, source, sink, data.ax);

            % Wyświetlanie wyników
            resultStr = sprintf('Max Flow: %d\n\nPaths Used:\n', maxFlow);
            for i = 1:length(allPaths)
                resultStr = sprintf('%sPath %d: %s (Flow: %d)\n', resultStr, i, ...
                                    mat2str(allPaths(i).path), allPaths(i).flow);
            end
            set(data.resultText, 'String', resultStr);

        catch e
            errordlg(sprintf('Error: %s', e.message), 'Input Error');
        end
    end
end