# OLD : https://qiita.com/namakemono/items/c963e75e0af3f7eed732
#FILE_ID=1dukLrTzZQEuhzitGkHaGjphlmRJOjVnP
#FILE_NAME=yolact_darknet53_54_800000.pth
#curl -sc /tmp/cookie "https://drive.google.com/uc?export=download&id=${FILE_ID}" > /dev/null
#CODE="$(awk '/_warning_/ {print $NF}' /tmp/cookie)"  
#curl -Lb /tmp/cookie "https://drive.google.com/uc?export=download&confirm=${CODE}&id=${FILE_ID}" -o ${FILE_NAME}

# NEW : https://qiita.com/tanaike/items/f609a29ccb8d764d74b3
fileid="1dukLrTzZQEuhzitGkHaGjphlmRJOjVnP"
filename="yolact_darknet53_54_800000.pth"
html=`curl -s -L "https://drive.google.com/uc?export=download&id=${fileid}"`
curl -Lb ./cookie "https://drive.google.com/uc?export=download&`echo ${html}|grep -Po '(confirm=[a-zA-Z0-9\-_]+)'`&id=${fileid}" -o ${filename}