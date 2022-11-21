input_name = ["夜半小夜曲", "雪绒花", "四季歌"];

l = width(input_name);

for i = 1:l
    notes_file = "./input/notes"+i + ".json";
    scale_file = "./input/scale"+i + ".json";
    disp(notes_file)
    [matrix, scale_r, scale_c] = reader(notes_file, 3);
    % disp(matrix)
    % disp(scale_c)
    % disp(scale_r)
    max_bars_length = 100;
    min_bars_length = 20;
    main_note = 60;
    timeing = 120;
    meter = 4;

    for type = 1:2

        switch type
            case 1
                output_file = "./output/"+input_name(i) + "(改).mid";
            case 2
                output_file = "./output/"+input_name(i) + "(一阶).mid";
        end

        [chain, nmat, scale] = printer(matrix', scale_c, scale_file, min_bars_length, max_bars_length, main_note, timeing, meter, type, output_file);
    end

end
