clear;
input_name = ["夜半小夜曲", "雪绒花", "四季歌"];
types = ["仅一阶音高", "音高和时值", "二阶音高"];

max_bars_length = 100;
min_bars_length = 20;
main_note = 60;
timeing = 120;
meter = 4;

l = width(input_name);

for i = 1:l
    notes_file = "./input/notes"+i + ".json";
    scale_file = "./input/scale"+i + ".json";

    for type_of_chain = 1:3

        if type_of_chain ~= 1
            temp = type_of_chain + 1;
        else
            temp = type_of_chain;
        end

        [matrix, scale_r, scale_c] = reader(notes_file, temp);

        if type_of_chain == 3
            output_file = "./output/"+input_name(i) +types(type_of_chain) + ".mid";
            [chain, nmat, scale] = printer(matrix, type_of_chain, scale_c, scale_r, scale_file, min_bars_length, max_bars_length, main_note, timeing, meter, 1, output_file);
        else

            for type_of_pi = 1:2

                switch type_of_pi
                    case 1
                        output_file = "./output/"+input_name(i) + types(type_of_chain) + "(改).mid";
                    case 2
                        output_file = "./output/"+input_name(i) + types(type_of_chain) + "(一阶).mid";
                end

                [chain, nmat, scale] = printer(matrix, type_of_chain, scale_c, scale_r, scale_file, min_bars_length, max_bars_length, main_note, timeing, meter, type_of_pi, output_file);
            end

        end

    end

end
