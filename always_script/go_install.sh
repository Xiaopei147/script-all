go_install.sh



cd /data/software/
ls
  344  tar -xf go1.19.3.linux-amd64.tar.gz 
  345  ls
  346  mv go /usr/local/
  347  cd /usr/local/go/
  348  ls
  349  vim /etc/profile
  350  source /etc/profile
  351  go version
  352  go env -w GOPROXY=https://goproxy.cn,direct
  353  go env
  354  export GO111MODULE=on
  355  ls
  356  pwd
  357  cd /data/wwwroot/
  358  ls
  359  cd tally-api/
  360  ls
  361  go mod tidy
  362  ls
  363  go  build -o ddjz  main.go
  364  ls
  365  ps -ef |grep ddjz
  366  nohup ./ddjz >> api.log 2>&1 &
  367  ps -ef |grep ddjz
  368  ls
  369  cat api.log 
  370  ls
  371  nohup ./ddjz server >> api.log 2>&1 &
  372  ps -ef |grep ddjz
  373  ls
  374  cat api.log 
  375  cat main.go 
  376  ls
  377  cd config/
  378  ls
  379  rz -E
  380  ls
  381  cd ..
  382  ls
  383  nohup ./ddjz server >> api.log 2>&1




