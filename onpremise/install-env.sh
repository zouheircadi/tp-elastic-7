VERSION=7.4.1
ELASTIC_BIN=elasticsearch-${VERSION}-linux-x86_64.tar.gz
ELASTIC_MACOS_BIN=elasticsearch-${VERSION}-darwin-x86_64.tar.gz
ELASTIC_MACOS_FOLDER=elasticsearch-${VERSION}-darwin-x86_64


KIBANA_MACOS_BIN=kibana-${VERSION}-darwin-x86_64.tar.gz
KIBANA_MACOS_FOLDER=kibana-${VERSION}-darwin-x86_64

KIBANA_LINUX_BIN=kibana-${VERSION}-linux-x86_64.tar.gz
KIBANA_LINUX_FOLDER=kibana-${VERSION}-linux-x86_64

LOGSTASH_BIN=logstash-${VERSION}.tar.gz

export ELK_HOME=$HOME/elastic

mkdir -p $HOME/elastic/downloads ; cd $HOME/elastic



OS="`uname`"

alias BEGINCOMMENT="if [ ]; then"
alias ENDCOMMENT="fi"


# Installation Elastic
case $OS in
  'Linux')
     if [ -f "$HOME/elastic/downloads/${ELASTIC_BIN}" ]
     then
        echo "${ELASTIC_BIN} found."
        mkdir -p $HOME/elastic/search ; tar -xvf $HOME/elastic/downloads/${ELASTIC_BIN} -C $HOME/elastic/search
        mv $HOME/elastic/search/elasticsearch-$VERSION $HOME/elastic/search/$VERSION
     else
        echo "${ELASTIC_BIN} not found."
        echo " url = https://artifacts.elastic.co/downloads/elasticsearch/${ELASTIC_BIN}"
        wget https://artifacts.elastic.co/downloads/elasticsearch/${ELASTIC_BIN}
        mkdir -p $HOME/elastic/search ; tar -xvf ${ELASTIC_BIN} -C $HOME/elastic/search
        mv $HOME/elastic/search/elasticsearch-$VERSION $HOME/elastic/search/$VERSION
        mv $HOME/elastic/${ELASTIC_BIN} $HOME/elastic/downloads/${ELASTIC_BIN}  
     fi
    ;;
  'Darwin')
     if [ -f "$HOME/elastic/downloads/${ELASTIC_MACOS_BIN}" ]
     then
       echo "${ELASTIC_MACOS_BIN} found - download unecessary"
       mkdir -p $HOME/elastic/search ; tar -xvf $HOME/elastic/downloads/${ELASTIC_MACOS_BIN} -C $HOME/elastic/search
       mv $HOME/elastic/search/elasticsearch-$VERSION $HOME/elastic/search/$VERSION
     else
       echo "${ELASTIC_MACOS_BIN} not found - download it ..."
       wget https://artifacts.elastic.co/downloads/elasticsearch/${ELASTIC_MACOS_BIN}
       mkdir -p $HOME/elastic/search ; tar -xvf ${ELASTIC_MACOS_BIN} -C $HOME/elastic/search
       mv $HOME/elastic/search/elasticsearch-$VERSION $HOME/elastic/search/$VERSION
       mv $HOME/elastic/${ELASTIC_MACOS_BIN} $HOME/elastic/downloads/${ELASTIC_MACOS_BIN}     
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
       mkdir -p $HOME/elastic/kibana ; tar -xvf $HOME/elastic/downloads/${KIBANA_LINUX_BIN} -C $HOME/elastic/kibana
       mv $HOME/elastic/kibana/${KIBANA_LINUX_FOLDER} $HOME/elastic/kibana/$VERSION
     else
       echo "${KIBANA_LINUX_BIN} not found."
       wget https://artifacts.elastic.co/downloads/kibana/${KIBANA_LINUX_BIN}
       mkdir -p $HOME/elastic/kibana ; tar -xvf ${KIBANA_LINUX_BIN} -C $HOME/elastic/kibana
       mv $HOME/elastic/kibana/${KIBANA_LINUX_FOLDER} $HOME/elastic/kibana/$VERSION
       mv $HOME/elastic/${KIBANA_LINUX_BIN} $HOME/elastic/downloads/${KIBANA_LINUX_BIN}     
     fi
    ;;
  'Darwin')
     if [ -f "$HOME/elastic/downloads/${KIBANA_MACOS_BIN}" ]
     then
       echo "${KIBANA_MACOS_BIN} found - download unecessary"
       mkdir -p $HOME/elastic/kibana ; tar -xvf $HOME/elastic/downloads/${KIBANA_MACOS_BIN} -C $HOME/elastic/kibana
       mv $HOME/elastic/kibana/${KIBANA_MACOS_FOLDER} $HOME/elastic/kibana/$VERSION
     else
       echo "${KIBANA_MACOS_BIN} not found - download it ..."
       wget https://artifacts.elastic.co/downloads/kibana/${KIBANA_MACOS_BIN}
       mkdir -p $HOME/elastic/kibana ; tar -xvf ${KIBANA_MACOS_BIN} -C $HOME/elastic/kibana
       mv $HOME/elastic/kibana/${KIBANA_MACOS_FOLDER} $HOME/elastic/kibana/$VERSION
       mv $HOME/elastic/${KIBANA_MACOS_BIN} $HOME/elastic/downloads/${KIBANA_MACOS_BIN}     
     fi
    ;;
  *) ;;
esac



# Installation logstash
if [ -f "$HOME/elastic/downloads/${LOGSTASH_BIN}" ]
then
  echo "${LOGSTASH_BIN} found - download unecessary"
  mkdir $HOME/elastic/logstash ; tar -xvf $HOME/elastic/downloads/${LOGSTASH_BIN} -C $HOME/elastic/logstash
  mv $HOME/elastic/logstash/logstash-$VERSION $HOME/elastic/logstash/$VERSION
else
  echo "${LOGSTASH_BIN} not found - download it ..."
  wget https://artifacts.elastic.co/downloads/logstash/${LOGSTASH_BIN}
  mkdir -p $HOME/elastic/logstash ; tar -xvf ${LOGSTASH_BIN} -C $HOME/elastic/logstash
  mv $HOME/elastic/logstash/logstash-$VERSION $HOME/elastic/logstash/$VERSION
  mv $HOME/elastic/${LOGSTASH_BIN} $HOME/elastic/downloads/${LOGSTASH_BIN}
fi
