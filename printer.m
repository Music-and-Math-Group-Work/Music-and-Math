function [chain, nmat] = printer(filename1, filename2, bars_length, main_note, timeing, delta_beat, duration_beat, meter)
    %myFun - Description
    %
    % Syntax: output = myFun(input)
    %
    % Long description
    % filename1 = "matrix.json";
    P = loadjson(filename1);
    % filename2 = "scale.json";
    scale = loadjson(filename2);

    beats_in_bar = meter / duration_beat;
    notes = scale + main_note;
    beat_time = 60 / timeing;
    % delta_time = beat_time * delta_beat;
    duration_time = beat_time * duration_beat;

    target0 = find(scale == 0);
    % 第一个音，选主音比较好?
    chain = zeros(1, beats_in_bar * bars_length);
    chain(1) = target0;
    l = size(scale);
    l = l(2);
    P_i = zeros(l, 1);
    P_i(target0) = 1;

    nmat = zeros(beats_in_bar * bars_length, 7);
    nmat(1, :) = [1, duration_beat, 1, main_note, 75, 0, duration_time];
    beat_now = delta_beat + 1;

    for i = 2:bars_length * beats_in_bar

        P_i = P * P_i;
        P_i = P_i / sum(P_i);
        prob = cumsum(P_i);
        choice = rand();
        temp = find(prob >= choice);
        target = temp(1);
        chain(i) = target;

        if mod(i, beats_in_bar) == 1
            P_i = zeros(l, 1);
            P_i(target) = 1;
        end

        % 以上生成链
        note = notes(target);
        nmat(i, :) = [beat_now, duration_beat, 0, note, 75, beat_now * beat_time, duration_time];
        beat_now = beat_now + delta_beat;
        disp(P_i)

        if mod(i, beats_in_bar) == 0 && target == target0
            break
        end

    end

    disp(i)
    nmat = nmat(1:i, :);
    chain = chain(1, 1:i);
    % disp(chain)
    % disp(nmat)
    writemidi(nmat, "test.mid", timeing);

end

% bars_length = 50;
% % 最终小节最大长度
% main_note = 67;
% timeing = 98;
% delta_beat = 0.5;
% duration_beat = 0.5;
% meter = 4;
