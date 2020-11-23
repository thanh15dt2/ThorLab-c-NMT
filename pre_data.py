import os
import linecache
path = '/home/thanhlv/workspace/projects/vlsp/Data/MT-EV-VLSP2020/'
en_path = '/home/thanhlv/workspace/projects/vlsp/Data/en.txt'
vi_path = '/home/thanhlv/workspace/projects/vlsp/Data/vi.txt'
en = []
for i in os.listdir(path):
    if os.path.isdir(path + str(i)):
        pass
    for j in os.listdir(path + str(i)):
        if j == 'data.en':
            continue
        with open(path + str(i) + '/' + str(j), 'r') as file:
            data_en = file.read()
            print(type(data_en))
            data = file.read()
            print(type(data))
            line_number = len(data_en)
            print(path + str(i) + '/' + str(j))
            with open(vi_path, "w") as f:
                f.write(str(data_en))
