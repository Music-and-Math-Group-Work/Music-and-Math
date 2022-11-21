clear;
notes_file = "./input/notes1.json";
scale_file = "./input/scale1.json";
[matrix, scale_r, scale_c] = reader(notes_file, 4);
type_of_chain = 3;
max_bars_length = 100;
min_bars_length = 20;
main_note = 60;
timeing = 120;
meter = 4;
type_of_pi = 1;
output_file = "./output/test.mid";
[chain, nmat, scale] = printer(matrix, type_of_chain, scale_c, scale_r, scale_file, min_bars_length, max_bars_length, main_note, timeing, meter, type_of_pi, output_file);
