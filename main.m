chain_length = 50;
% 最终马尔可夫链长度
main_note = 67;
timeing = 98;
delta_beat = 1;
duration_beat = 1;

filename1 = "matrix.json";
P = loadjson(filename1);
filename2 = "scale.json";
scale = loadjson(filename2);

target0 = find(scale == 0);
% 第一个音，选主音比较好?
chain = zeros(1, chain_length);
chain(1) = target0;

notes = scale + main_note;
beat_time = 60 / timeing;
delta_time = beat_time * delta_beat;
duration_time = beat_time * duration_beat;

nmat = zeros(chain_length, 7);
nmat(1, :) = [0, duration_beat, 1, main_note, 75, 0, duration_time];
beat_now = delta_beat;

for i = 2:chain_length
    P_i = P(chain(i - 1), :);
    prob = cumsum(P_i);
    choice = rand();
    temp = find(prob >= choice);
    target = temp(1);
    chain(i) = target;
    % 以上生成链
    note = notes(target);
    nmat(i, :) = [beat_now, duration_beat, 1, note, 75, beat_now * delta_time, duration_time];
    beat_now = beat_now + delta_beat;
end

% disp(chain)
% disp(nmat)
writemidi(nmat, "test.mid", timeing);
