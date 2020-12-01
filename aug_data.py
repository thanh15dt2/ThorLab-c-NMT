import os 
data_path = './reprocessed_data'
train_path = os.path.join(data_path, 'val.vi')

with open(train_path, 'r') as file:
    data = file.readlines()
    line_number = len(data)
    t = 0
    with open('val.vn', 'w') as f:
        for i in range(len(data)):
            if i % 2 and i < len(data)-1:
                text = data[i].rstrip('\n') + data[i+1]
                f.write(text)
            
