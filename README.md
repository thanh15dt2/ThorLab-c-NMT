## VLSP-2020
## Thorlab-C
Members:
** Tuyen(L)
** Tranh
** Thanh

This to save my work at home about NPL
Try to using VN in spacy lab
## Build
Docker image 
```
docker build -t ThorLab-C-NMT .
```

## Setup for develop
* Setup an enviroment
* vi_spacy model 
```
bash build.sh
```
* Reprocessing data
This step without reprocessed_data folder
```
python3 ./vlsp_data/collect_full.py
```

* Training 
: Run Transfomer.ipynb file

## Todo:
* Check dictionary
* Evaluation  
* Testing 
