import os
import linecache
t = os.path.relpath(__file__)
print(t)
path = os.path.join(os.path.realpath(__file__), '/MT-EV-VLSP2020')
print(path)
en_path = './en.txt'
vi_path = './vi.txt'
en = []
# print(os.path.dirname(os.path.realpath(__file__)))

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
