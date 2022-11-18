% these below can all be changed.!!!!!!!!!!!!!

function [matrix, scale] = reader(filename1, filename2, type)
    % myFun - Description
    %
    % Syntax: output = myFun(input)
    %
    % @param filename1 二元组json文件路径
    % @param filename2 音差json文件路径
    % @param type 需要的转移矩阵类型
    %               1: 音高
    %               2: 时值
    %               3: (时值,音高)
    %               4: 二阶音高 (unfinished)

    seq_in = loadjson(filename1);
    pitch_diff = loadjson(filename2);

    switch type
        case 1
            matrix = get_transfer(seq_in(:,2), 1);
        case 2
            matrix = get_transfer(seq_in(:,1), 1);
        case 3
            seq_tmp = zeros(height(seq_in), 1);
            for i = 1:height(seq_in)
                seq_tmp(i) = seq_in(i, 2) * 100 + seq_in(i, 1);
            end
            matrix = get_transfer(seq_tmp, 1);
        case 4
            seq_tmp = zeros(height(seq_in) - 1, 1);
            for i = 1:height(seq_in)
                seq_tmp(i) = seq_in(i - 1, 2) * 100 + seq_in(i, 2);
            end
            matrix = get_transfer(seq_in(:,2), 2);
        otherwise
            warning('Unexpected type');
    end

    scale = 0; % unfinished

end

function transfer = get_transfer(arr, order)
    arr_unique = unique(arr);

    len = height(arr);
    num = height(arr_unique);

    if order == 1
        transfer = zeros(num);
        for k = 2:len
            i = find(arr_unique == arr(k - 1));
            j = find(arr_unique == arr(k));
            transfer(i, j) = transfer(i, j) + 1;
        end
    elseif order == 2 % unfinished
        transfer = zeros(num * num, num);
        for k = 3:len
            i = (find(arr_unique == arr(k - 2)) - 1) * num + find(arr_unique == arr(k - 1));
            j = find(arr_unique == arr(k));
            transfer(i, j) = transfer(i, j) + 1;
        end
    else 
        transfer = 1;
    end

    % size(transfer)
    transfer = normalize_line(transfer);
    % size(transfer)
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
        end
    end
end