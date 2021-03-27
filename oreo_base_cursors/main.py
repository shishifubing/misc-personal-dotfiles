import os

for file_name in os.listdir():
    if (file_name != 'main.py' and file_name != 'svg'):
        with open(file_name, 'r') as file_object:
            file_string = file_object.read()
        file_name_new = './svg/'+file_name[:-4]
        with open(file_name_new, 'w') as file_object:
            file_object.write(
                file_string.replace('{{ shadowopacity }}', '1').
                replace('{{ opacity }}', '1').
                replace('{{ background }}', '#9932cc').
                replace('{{ label }}', '#ffffff').
                replace('{{ shadow }}', '#000000'))
