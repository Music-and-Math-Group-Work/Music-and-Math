function [out_mat, out_scale] = merge(mat1, scale1, scale_file1, mat2, scale2, scale_file2, main_note1, main_note2, lambda)
    % @brief
    % @param mat1/2        转移矩阵1/2
    % @param scale1/2      转义前索引1/2
    % @param scale_file1/2 音差文件路径1/2
    % @param main_note1/2  乐曲主音1/2
    % @param lambda        概率叠加比例 out = lambda * (1) + (1 - lambda) * (2)
    scale1 = rescale0(scale1, scale_file1, main_note1);
    scale2 = rescale0(scale2, scale_file2, main_note2);

    out_scale = unique([scale1; scale2]);
    out_mat = zeros(height(out_scale));

    for i = 1:height(out_scale)
        in1 = ismember(out_scale(i), scale1);
        in2 = ismember(out_scale(i), scale2);

        scale1 = unique(scale1);
        scale2 = unique(scale2);

        if in1 && in2
            i1 = find(scale1 == out_scale(i), 1);

            for j1 = 1:height(scale1)
                j = find(out_scale == scale1(j1));
                out_mat(i, j) = out_mat(i, j) + lambda * mat1(i1, j1);
            end

            i2 = find(scale2 == out_scale(i));

            for j2 = 1:height(scale2)
                j = find(out_scale == scale2(j2));
                out_mat(i, j) = out_mat(i, j) + (1 - lambda) * mat2(i2, j2);
            end

            % ["Both in, ", i, out_scale(i)]

        elseif in1

            i1 = find(scale1 == out_scale(i), 1);
            % disp(scale1)

            for j1 = 1:height(scale1)
                j = find(out_scale == scale1(j1));
                % disp(j1)
                out_mat(i, j) = out_mat(i, j) + mat1(i1, j1);
            end

            % ["In 1, ", out_scale(i)]

        elseif in2

            i2 = find(scale2 == out_scale(i));

            for j2 = 1:height(scale2)
                j = find(out_scale == scale2(j2));
                out_mat(i, j) = out_mat(i, j) + mat2(i2, j2);
            end

            % ["In 2, ", out_scale(i)]

        else
            warning('Error data in out_scale');
        end

    end

end

function [scale] = rescale0(scale_c, filename, main_note)
    notes = loadjson(filename);
    w = height(scale_c);
    scale = zeros(w, 1);

    for i = 1:w

        if scale_c(i) ~= 0
            scale(i) = notes(scale_c(i)) + main_note;
        end

    end

end
