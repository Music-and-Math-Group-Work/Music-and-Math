function [matrix, scale_r, scale_c] = reader(filename, type)
    % @brief 给定json和需要的转移矩阵类型，输出转移矩阵和行列的索引
    % @param filename 二元组json文件路径
    % @param type 需要的转移矩阵类型
    %               1: 音高
    %               2: 时值
    %               3: (时值,音高)
    %               4: 音高-二阶
    % @return matrix 转移概率矩阵
    % @return scale_r 行索引
    % @return scale_c 列索引
    % 索引说明
    % 所有音高未按音差文件转义
    % (时值,音高) 格式同输入
    % 音高-二阶 行索引为音高二元组，列索引为单一音高

    seq_in = loadjson(filename);

    switch type
        case 1
            [matrix, scale_r] = get_transfer(seq_in(:, 2));
            scale_c = scale_r;
        case 2
            [matrix, scale_r] = get_transfer(seq_in(:, 1));
            scale_c = scale_r;
        case 3
            seq_tmp = zeros(height(seq_in), 1);

            for i = 1:height(seq_in)
                seq_tmp(i) = seq_in(i, 2) * 100 + seq_in(i, 1);
            end

            [matrix, scale_tmp] = get_transfer(seq_tmp);
            scale_r = zeros(height(scale_tmp), 2);

            for i = 1:height(scale_tmp)
                scale_r(i, 2) = floor(scale_tmp(i) / 100);
                scale_r(i, 1) = scale_tmp(i) - scale_r(i, 2) * 100;
            end

            scale_c = scale_r;
        case 4
            arr = seq_in(:, 2);
            scale_c = unique(arr);
            scale_r = zeros(height(arr) - 1, 2);

            for i = 1:height(arr) - 1
                scale_r(i, 1) = arr(i);
                scale_r(i, 2) = arr(i + 1);
            end

            scale_r = unique(scale_r, "rows");

            matrix = zeros(height(scale_r), height(scale_c));

            for k = 3:height(arr)
                [~, i] = ismember([arr(k - 2), arr(k - 1)], scale_r, "rows");
                j = find(scale_c == arr(k));
                matrix(i, j) = matrix(i, j) + 1;
            end

            matrix = normalize_line(matrix);

        otherwise
            warning('Unexpected type');
    end

end

function [transfer, state] = get_transfer(arr)
    state = unique(arr);

    len = height(arr);
    num = height(state);

    transfer = zeros(num);

    for k = 2:len
        i = find(state == arr(k - 1));
        j = find(state == arr(k));
        transfer(i, j) = transfer(i, j) + 1;
    end

    transfer = normalize_line(transfer);
end

function mat_out = normalize_line(mat_in)
    h = height(mat_in);
    w = width(mat_in);
    mat_out = zeros(h, w);

    for i = 1:h
        sumi = 0;

        for j = 1:w
            sumi = sumi + mat_in(i, j);
        end

        if sumi ~= 0

            for j = 1:w
                mat_out(i, j) = mat_in(i, j) / sumi;
            end

        else
            mat_out(i, 1) = 1;
            warning(['Sum of row ', num2str(i), ' is 0.']);
        end

    end

end
