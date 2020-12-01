import os
data_path = './reprocessed_data'
pre_data_path = os.path.join(data_path, 'test.en')
aug_data_path = 'test.en'
with open('./aug_data/test.en', 'w') as f:
    with open(pre_data_path, 'r') as f1:
        data1 = f1.readlines()
        for i in range(len(data1)):
            f.write(data1[i])  
    with open(aug_data_path, 'r') as f2:
        data2 = f2.readlines()
        for i in range(len(data2)):
            f.write(data2[i])

