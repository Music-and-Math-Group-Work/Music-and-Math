function [chain, nmat] = printer(P, scale_c, scale_file, bars_length, main_note, timeing, meter)
    %myFun - Description
    %
    % Syntax: output = myFun(input)
    %
    % Long description
    % filename1 = "matrix.json";
    % P = loadjson(filename1);
    % filename2 = "scale.json";
    scale_s = loadjson(scale_file);

    % beats_in_bar = meter / duration_beat;
    start_beat = 0;

    notes = scale_s + main_note;
    main_element = find(scale_s == 0);
    [scale, target0] = rescale(scale_c, notes, main_element);
    % scale 是转化为绝对音高的scale，含音长
    % 第一个音，选主音比较好并占长一拍
    beat_time = 60 / timeing;
    % delta_time = beat_time * delta_beat;

    chain = zeros(1, meter * bars_length);
    chain(1) = target0;
    l = height(scale);
    P_i = zeros(l, 1);
    P_i(target0) = 1;

    nmat = zeros(meter * bars_length, 7);
    nmat(1, :) = [1, 1, 0, main_note, 75, 0, beat_time];
    beat_now = start_beat + 1;
    i = 2;
    j = 2;
    k = 1;
    end_beat = meter * bars_length + start_beat;

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

        if mod(beat_now, meter) == start_beat && note == main_note
            break
        end

        if mod(beat_now, 2 * meter) == start_beat || k > 20
            P_i = zeros(l, 1);
            P_i(target) = 1;
            k = 1;
        else
            k = k + 1;
        end

        % disp(P_i)

    end

    disp(i)
    disp(j)
    nmat = nmat(1:j, :);
    chain = chain(1, 1:i);
    disp(chain)
    disp(nmat)
    writemidi(nmat, "./output/output.mid", timeing);

end

function [scale, target0] = rescale(scale_c, notes, main_element)
    w = height(scale_c);
    scale = zeros(w, 2);

    for i = 1:w
        temp = scale_c(i, 2);
        scale(i, 1) = scale_c(i, 1);

        if temp == 0
            continue
        elseif temp == main_element && scale_c(i, 1) == 1
            target0 = i;
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

% bars_length = 50;
% % 最终小节最大长度
% main_note = 67;
% timeing = 98;
% delta_beat = 0.5;
% duration_beat = 0.5;
% meter = 4;
