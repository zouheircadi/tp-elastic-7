VERSION=7.3.1
ELASTIC_BIN=elasticsearch-${VERSION}-linux-x86_64.tar.gz
ELASTIC_MACOS_BIN=elasticsearch-${VERSION}-darwin-x86_64.tar.gz
ELASTIC_MACOS_FOLDER=elasticsearch-${VERSION}-darwin-x86_64


KIBANA_MACOS_BIN=kibana-${VERSION}-darwin-x86_64.tar.gz
KIBANA_MACOS_FOLDER=kibana-${VERSION}-darwin-x86_64

KIBANA_LINUX_BIN=kibana-${VERSION}-linux-x86_64.tar.gz
KIBANA_LINUX_FOLDER=kibana-${VERSION}-linux-x86_64

LOGSTASH_BIN=logstash-${VERSION}.tar.gz

export ELK_HOME=$HOME/elastic

mkdir -p $HOME/elastic/downloads
mkdir -p $HOME/elastic/${VERSION}
cd $HOME/elastic/${VERSION}



OS="`uname`"

alias BEGINCOMMENT="if [ ]; then"
alias ENDCOMMENT="fi"


# Installation Elastic
case $OS in
  'Linux')
     # binaire already downloaded
     if [ -f "$HOME/elastic/downloads/${ELASTIC_BIN}" ]
     then
        echo "${ELASTIC_BIN} found."
        tar -xvf $HOME/elastic/downloads/${ELASTIC_BIN} -C $HOME/elastic/${VERSION}
        mv $HOME/elastic/${VERSION}/elasticsearch-$VERSION $HOME/elastic/${VERSION}/elasticsearch
     else
        echo "${ELASTIC_BIN} not found."
        echo " url = https://artifacts.elastic.co/downloads/elasticsearch/${ELASTIC_BIN}"
        wget https://artifacts.elastic.co/downloads/elasticsearch/${ELASTIC_BIN}
        tar -xvf ${ELASTIC_BIN} -C HOME/elastic/${VERSION}
        mv $HOME/elastic/${VERSION}/elasticsearch-$VERSION $HOME/elastic/${VERSION}/elasticsearch
        mv $HOME/elastic/${VERSION}/${ELASTIC_BIN} $HOME/elastic/downloads/${ELASTIC_BIN}  
     fi
    ;;
  'Darwin')
     if [ -f "$HOME/elastic/downloads/${ELASTIC_MACOS_BIN}" ]
     then
       echo "${ELASTIC_MACOS_BIN} found - download unecessary"
       tar -xvf $HOME/elastic/downloads/${ELASTIC_MACOS_BIN} -C $HOME/elastic/${VERSION}
       mv $HOME/elastic/${VERSION}/elasticsearch-$VERSION $HOME/elastic/${VERSION}/elasticsearch
     else
       echo "${ELASTIC_MACOS_BIN} not found - download it ..."
       wget https://artifacts.elastic.co/downloads/elasticsearch/${ELASTIC_MACOS_BIN}
       tar -xvf ${ELASTIC_MACOS_BIN} -C $HOME/elastic/${VERSION}
       mv $HOME/elastic/${VERSION}/elasticsearch-$VERSION $HOME/elastic/${VERSION}/elasticsearch
       mv $HOME/elastic/${VERSION}/${ELASTIC_MACOS_BIN} $HOME/elastic/downloads/${ELASTIC_MACOS_BIN}     
     fi
    ;;
  *) ;;
esac


# v: rename /Users/zouheir/elastic/search/elasticsearch-7.1.1-darwin-x86_64 to /Users/zouheir/elastic/search/7.1.1: No such file or directory


# Installation Kibana
case $OS in
  'Linux')
     if [ -f "$HOME/elastic/downloads/${KIBANA_LINUX_BIN}" ]
     then
       echo "${KIBANA_LINUX_BIN} found."
       tar -xvf $HOME/elastic/downloads/${KIBANA_LINUX_BIN} -C $HOME/elastic/${VERSION}
       mv $HOME/elastic/${VERSION}/${KIBANA_LINUX_FOLDER} $HOME/elastic/${VERSION}/kibana
     else
       echo "${KIBANA_LINUX_BIN} not found."
       wget https://artifacts.elastic.co/downloads/kibana/${KIBANA_LINUX_BIN}
       tar -xvf ${KIBANA_LINUX_BIN} -C $HOME/elastic/${VERSION}
       mv $HOME/elastic/${VERSION}/${KIBANA_LINUX_FOLDER} $HOME/elastic/${VERSION}/kibana
       mv $HOME/elastic/${VERSION}/${KIBANA_LINUX_BIN} $HOME/elastic/downloads/${KIBANA_LINUX_BIN}     
     fi
    ;;
  'Darwin')
     if [ -f "$HOME/elastic/downloads/${KIBANA_MACOS_BIN}" ]
     then
       echo "${KIBANA_MACOS_BIN} found - download unecessary"
       tar -xvf $HOME/elastic/downloads/${KIBANA_MACOS_BIN} -C $HOME/elastic/${VERSION}
       mv $HOME/elastic/${VERSION}/${KIBANA_MACOS_FOLDER} $HOME/elastic/${VERSION}/kibana
     else
       echo "${KIBANA_MACOS_BIN} not found - download it ..."
       wget https://artifacts.elastic.co/downloads/kibana/${KIBANA_MACOS_BIN}
       tar -xvf ${KIBANA_MACOS_BIN} -C $HOME/elastic/kibana
       mv $HOME/elastic/${VERSION}/${KIBANA_MACOS_FOLDER} $HOME/elastic/${VERSION}/kibana
       mv $HOME/elastic/${VERSION}/${KIBANA_MACOS_BIN} $HOME/elastic/downloads/${KIBANA_MACOS_BIN}     
     fi
    ;;
  *) ;;
esac



# Installation logstash
if [ -f "$HOME/elastic/downloads/${LOGSTASH_BIN}" ]
then
  echo "${LOGSTASH_BIN} found - download unecessary"
  tar -xvf $HOME/elastic/downloads/${LOGSTASH_BIN} -C $HOME/elastic/${VERSION}
  mv $HOME/elastic/${VERSION}/logstash-$VERSION $HOME/elastic/${VERSION}/logstash
else
  echo "${LOGSTASH_BIN} not found - download it ..."
  wget https://artifacts.elastic.co/downloads/logstash/${LOGSTASH_BIN}
  tar -xvf ${LOGSTASH_BIN} -C $HOME/elastic/${VERSION}
  mv $HOME/elastic/${VERSION}/logstash-$VERSION $HOME/elastic/${VERSION}/logstash
  mv $HOME/elastic/${VERSION}/${LOGSTASH_BIN} $HOME/elastic/downloads/${LOGSTASH_BIN}
fi
