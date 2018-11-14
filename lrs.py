import json

with open('../ports.json') as json_data:
    data = json.load(json_data)
    for entry in data:
        print(entry)