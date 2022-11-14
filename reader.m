% these below can all be changed.!!!!!!!!!!!!!

function [matrix, scale] = reader(filename, section_beat, unit_beat, main_note)
    %myFun - Description
    %
    % Syntax: output = myFun(input)
    %
    % Long description
    nmat = readmidi(filename);
    scale = sort(unique(nmat(:, 4)) - main_note)';
    num_of_notes = size(scale);
    num_of_notes = num_of_notes(2);
    l = size(nmat);
    l = l(1);
    start_beat = nmat(1, 1);
    k = (nmat(l, 1) + nmat(l, 2) - start_beat) / section_beat;
    matrix = zeros(num_of_notes, num_of_notes, k);

    for i = 1:l
        % line = nmat(i, :);
        k_i = floor((nmat(i, 1) - start_beat) / section_beat);
        note = find(scale == nmat(i, 4) - main_note);
        note = note(1);

    end

end
