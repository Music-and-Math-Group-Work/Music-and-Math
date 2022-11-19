notes_file = "./input/notes2.json";
scale_file = "./input/scale2.json";
[matrix, scale_r, scale_c] = reader(notes_file, 3);
% disp(matrix)
% disp(scale_c)
% disp(scale_r)
bars_length = 50;
main_note = 60;
timeing = 120;
meter = 4;
[chain, nmat] = printer(matrix, scale_c, scale_file, bars_length, main_note, timeing, meter);
