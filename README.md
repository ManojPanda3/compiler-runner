# compiler-runner
A Bash script that automates the process of compiling and running codes, with features like automatic formatting, error fixing, and performance measurement. on a loop(if detect any change in code its formate &amp; compile &amp; run the code)

| ## NOTE : Currently support only cpp 

| ## WARNING : Make sure to turnOff autosave on your ide. Bcz this script run program if its detact any changes.

# How to instll and run
```bash
apt install build-essential clang-tidy g++ clang-format
git clone --depth 1 https://github.com/ManojPanda3/compiler-runner/ .
rm -rf .git
# the command to run script
# -af == --autofix this will autofix any error  
bash run.sh -f main.cpp -af 
```
