function [chain, nmat, scale] = printer(matrix, scale_c, scale_file, min_bars_length, max_bars_length, main_note, timeing, meter, type, output_file)
    % @brief printer 根据给定的转移矩阵，给出输出。
    % @param P 转移矩阵
    % @param scale_c 行格式。(时值,音高)
    % @param scale_file scale.json(结构为\[pitch1,pitch2,...\],每个为与主音之半音差)相对路径。
    % @param scale_file min_bars_length 最小小节数
    % @param scale_file max_bars_length 最大小节数
    % @param main_note 主音绝对音高。60为中央C，差一代表差一半音。。
    % @param timing 速度.bars per min.
    % @param meter 拍号。一小节多少拍。
    % @param type 生成方式
    %               1: 两小节固定一次P
    %               2: 每次生成都固定P
    % @param output_file 输出格式。midi文件

    % @return chain Markov chain
    % @return nmat midi文件的内容
    % @return scale 列索引，绝对音高
    % 索引说明
    % (时值,音高) 绝对音高

    scale_s = loadjson(scale_file);
    P = matrix';

    % beats_in_bar = meter / duration_beat;
    start_beat = 0;

    notes = scale_s + main_note;
    main_element = find(scale_s == 0);
    [scale, target0] = rescale(scale_c, notes, main_element);
    beat_time = 60 / timeing;
    % delta_time = beat_time * delta_beat;

    chain = zeros(1, meter * max_bars_length);
    chain(1) = target0;
    l = height(scale);
    P_i = zeros(l, 1);
    P_i(target0) = 1;

    nmat = zeros(meter * max_bars_length, 7);
    nmat(1, :) = [1, 1, 0, main_note, 75, 0, beat_time];
    beat_now = start_beat + 1;
    beat_last = start_beat;
    i = 2;
    j = 2;
    end_beat = meter * max_bars_length + start_beat;

    while beat_now <= end_beat
        [P_i, target] = cal(P, P_i);
        chain(i) = target;
        i = i + 1;
        note = scale(target, 2);
        duration_beat = scale(target, 1);

        % 以上生成链
        if note ~= 0
            nmat(j, :) = [beat_now, duration_beat, 0, note, 75, beat_now * beat_time, duration_beat * beat_time];
            j = j + 1;
        end

        beat_now = beat_now + scale(target, 1);

        if mod(beat_now, meter) == start_beat && mod(note - main_note, 12) == 0

            if (beat_now - start_beat) / meter > min_bars_length
                break
            end

        end

        switch type
            case 1

                if beat_now - beat_last >= 2 * meter
                    P_i = zeros(l, 1);
                    P_i(target) = 1;
                    beat_last = meter * floor(beat_now / meter);
                end

            case 2
                P_i = zeros(l, 1);
                P_i(target) = 1;

        end

    end

    disp(i)
    disp(j)
    nmat = nmat(1:j - 1, :);
    chain = chain(1, 1:i - 1);
    disp(chain)
    disp(nmat)
    writemidi(nmat, output_file, timeing);

end

function [scale, target0] = rescale(scale_c, notes, main_element)
    w = height(scale_c);
    scale = zeros(w, 2);
    target0 = 0;

    for i = 1:w
        temp = scale_c(i, 2);
        scale(i, 1) = scale_c(i, 1);

        if temp == 0
            continue
        elseif temp == main_element

            if target0 == 0
                target0 = i;
            elseif scale_c(i, 1) == 1
                target0 = i;
            end

        end

        scale(i, 2) = notes(temp);

    end

end

function [P_i, target] = cal(P, P_0)
    P_i = P * P_0;
    P_i = P_i / sum(P_i);
    prob = cumsum(P_i);
    choice = rand();
    temp = find(prob >= choice);
    target = temp(1);
end
