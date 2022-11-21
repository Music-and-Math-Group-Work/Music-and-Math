function [chain, nmat, scale] = printer(matrix, type_of_chain, scale_c, scale_r, scale_file, min_bars_length, max_bars_length, main_note, timeing, meter, type_of_pi, output_file)
    % @brief printer 根据给定的转移矩阵，给出输出。
    % @param matrix 转移矩阵
    % @param type_of_chain Markov chain种类
    %               1.只含音高 一阶
    %               2.含音高和时值。(时值,音高) 一阶
    %               3.只含音高 二阶
    % @param scale_c 列格式。
    % @param scale_r 行格式。
    % @param scale_file scale.json(结构为\[pitch1,pitch2,...\],每个为与主音之半音差)相对路径。
    % @param scale_file min_bars_length 最小小节数
    % @param scale_file max_bars_length 最大小节数
    % @param main_note 主音绝对音高。60为中央C，差一代表差一半音。。
    % @param timing 速度.bars per min.
    % @param meter 拍号。一小节多少拍。
    % @param type_of_pi 生成方式
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
    beat_time = 60 / timeing;

    notes = scale_s + main_note;
    main_element = find(scale_s == 0);
    [abs_scale_c, abs_scale_r, target0] = rescale(scale_c, scale_r, notes, main_element, type_of_chain);

    chain = zeros(1, meter * max_bars_length);
    chain(1) = target0;

    nmat = zeros(meter * max_bars_length, 7);
    nmat(1, :) = [start_beat, 1, 0, main_note, 75, 0, beat_time];
    beat_now = start_beat + 1;
    end_beat = meter * max_bars_length + start_beat;

    if type_of_chain == 1 || type_of_chain == 2
        scale = abs_scale_c;
        % disp(scale)
        l = height(abs_scale_c);
        P_i = zeros(l, 1);
        P_i(target0) = 1;

        beat_last = start_beat;
        i = 2;
        j = 2;

        while beat_now <= end_beat
            [P_i, target] = cal(P, P_i);
            chain(i) = target;
            i = i + 1;

            switch type_of_chain
                case 1
                    note = scale(target);
                    duration_beat = 1;
                case 2
                    note = scale(target, 2);
                    duration_beat = scale(target, 1);
            end

            % 以上生成链
            if note ~= 0
                nmat(j, :) = [beat_now, duration_beat, 0, note, 75, beat_now * beat_time, duration_beat * beat_time];
                j = j + 1;
            end

            beat_now = beat_now + duration_beat;

            if mod(beat_now, meter) == start_beat && mod(note - main_note, 12) == 0

                if (beat_now - start_beat) / meter > min_bars_length
                    break
                end

            end

            switch type_of_pi
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

    elseif type_of_chain == 3
        P_1 = abs_scale_r(target0, 1);
        P_2 = abs_scale_r(target0, 2);
        chain(2) = P_2;
        duration_beat = 1;
        j = 2;

        if P_2 ~= 0
            nmat(2, :) = [beat_now, duration_beat, 0, P_2, 75, beat_now * beat_time, duration_beat * beat_time];
            j = j + 1;
        end

        beat_now = beat_now + 1;

        for i = 3:end_beat
            prob = cumsum(matrix(abs_scale_r(:, 1) == P_1 & abs_scale_r(:, 2) == P_2, :));
            choice = rand();
            temp = find(prob >= choice);
            target = temp(1);

            P_1 = P_2;
            P_2 = abs_scale_c(target);

            chain(i) = P_2;

            if P_2 ~= 0
                nmat(j, :) = [beat_now, duration_beat, 0, P_2, 75, beat_now * beat_time, duration_beat * beat_time];
                j = j + 1;
            end

            beat_now = beat_now + 1;

            if mod(i, meter) == 0 && mod(P_2 - main_note, 12) == 0

                if (beat_now - start_beat) / meter > min_bars_length
                    break
                end

            end

        end

        scale = abs_scale_r;

    end

    disp(i)
    disp(j)
    nmat = nmat(1:j - 1, :);
    chain = chain(1, 1:i);
    disp(chain)
    disp(nmat)
    writemidi(nmat, output_file, timeing);

end

function [abs_scale_c, abs_scale_r, target0] = rescale(scale_c, scale_r, notes, main_element, type_of_chain)
    % 将scale换成绝对音高的结果
    % target0是开始音的代表值

    if type_of_chain == 2
        w = height(scale_r);
        abs_scale = zeros(w, 2);
        target0 = 0;

        for x = 1:w
            temp = scale_r(x, 2);
            abs_scale(x, 1) = scale_r(x, 1);

            if temp == 0
                continue
            elseif temp == main_element

                if target0 == 0
                    target0 = x;
                elseif scale_r(x, 1) == 1
                    target0 = x;
                end

            end

            abs_scale(x, 2) = notes(temp);
            abs_scale_c = abs_scale;
            abs_scale_r = abs_scale;

        end

    elseif type_of_chain == 1 || type_of_chain == 3
        temp = [0, notes]';
        abs_scale_c = temp(scale_c + 1);
        abs_scale_r = temp(scale_r + 1);
        temp = find(scale_r(:, 1) == main_element);
        target0 = temp(randperm(height(temp), 1));
    else
        warning('Unexpected type_of_chain'+type_of_chain)

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
