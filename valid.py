import sys

from os import listdir

from os.path import isfile, join

import subprocess

import re









def listup_files(path):

    return  [f for f in listdir(path) if isfile(join(path, f))]



stats_ok = {}

stats_fail = {}

if __name__ == '__main__':

    args = sys.argv

    model = args[1]

    file_path = args[2]

    file_list = listup_files(file_path)

    #print(file_list)



    for img_file in file_list:

        #print(img_file)

        #cmd = "./kocr " + model + " " + file_path +  img_file

        #print(cmd)

        args = ['./kocr', model, file_path +  img_file]

        try:

            res = subprocess.check_output(args)

            result = res[-2:-1].decode('utf-8')

            #print(result)

            #print(img_file[0])

            if result == img_file[0]:

                if img_file[0] in stats_ok:

                    stats_ok[img_file[0]] += 1    

                else:

                    stats_ok.setdefault(img_file[0])

                    stats_ok[img_file[0]] = 0    

            else:

                print(img_file,' -> ',result)

                if img_file[0] in stats_fail:

                    stats_fail[img_file[0]] += 1    

                else:

                    stats_fail.setdefault(img_file[0])

                    stats_fail[img_file[0]] = 0    

        except:

            print ("Error.")

            exit()



    #print (sorted(stats_ok.items(), key=lambda x:x[0]))

    #print (sorted(stats_fail.items(), key=lambda x:x[0]))




