import os

path = '/home/thanhlv/workspace/projects/vlsp/Data'
en_path = path + '/en.txt'
vi_path = path + '/vi.txt'

with open(en_path, 'r') as file:
    data_line = file.readlines()
    lines_number = len(data_line)
    with open(path + '/train.en', 'w') as train_f:
        with open(path + '/test.en', 'w') as test_f:
            with open(path + '/val.en', 'w' ) as val_f:
                for i, value in enumerate(data_line):
                    if i < int(lines_number*0.7):
                            train_f.write(value)

                    elif i < int(lines_number*0.85):
                        train_f.close()
                        test_f.write(value)

                    else:
                        test_f.close()
                        val_f.write(value)
                val_f.close()


