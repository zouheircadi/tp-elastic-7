VERSION=7.3.1

ELASTIC_BIN=elasticsearch-${VERSION}-linux-x86_64.tar.gz
ELASTIC_FOLDER=elasticsearch-${VERSION}

ELASTIC_MACOS_BIN=elasticsearch-${VERSION}-darwin-x86_64.tar.gz
ELASTIC_MACOS_FOLDER=elasticsearch-${VERSION}-darwin-x86_64

KIBANA_LINUX_BIN=kibana-${VERSION}-linux-x86_64.tar.gz
KIBANA_LINUX_FOLDER=kibana-${VERSION}-linux-x86_64

KIBANA_MACOS_BIN=kibana-${VERSION}-darwin-x86_64.tar.gz
KIBANA_MACOS_FOLDER=kibana-${VERSION}-darwin-x86_64

LOGSTASH_BIN=logstash-${VERSION}.tar.gz
LOGSTASH_FOLDER=logstash-${VERSION}


# Installation folder
INSTAL_FOLDER=$HOME/elastic/${VERSION}

# download folder
DOWNLOAD_FOLDER=$HOME/elastic/downloads

# Elastic download root url
ES_ROOT_URL=https://artifacts.elastic.co/downloads


export ELK_HOME=$HOME/elastic

mkdir -p ${DOWNLOAD_FOLDER}
mkdir -p ${INSTAL_FOLDER}
cd ${INSTAL_FOLDER}



OS="`uname`"



# Elasticsearch installation
## Linux and MacOS
case $OS in
  'Linux')
     if [ ! -f "${DOWNLOAD_FOLDER}/${ELASTIC_BIN}" ]
     then
        echo "${ELASTIC_BIN} NOT found."
        wget ${ES_ROOT_URL}/elasticsearch/${ELASTIC_BIN} -P ${DOWNLOAD_FOLDER}
     fi
     tar -xvf ${DOWNLOAD_FOLDER}/${ELASTIC_BIN} -C ${INSTAL_FOLDER}
     mv ${INSTAL_FOLDER}/${ELASTIC_FOLDER} ${INSTAL_FOLDER}/elasticsearch

    ;;
  'Darwin')
     if [ ! -f "${DOWNLOAD_FOLDER}/${ELASTIC_MACOS_BIN}" ]
     then
       echo "${ELASTIC_MACOS_BIN} NOT found"
       wget ${ES_ROOT_URL}/elasticsearch/${ELASTIC_MACOS_BIN} -P ${DOWNLOAD_FOLDER}
     fi
     tar -xvf ${DOWNLOAD_FOLDER}/${ELASTIC_MACOS_BIN} -C ${INSTAL_FOLDER}
     mv ${INSTAL_FOLDER}/elasticsearch-${VERSION} ${INSTAL_FOLDER}/elasticsearch
    ;;
  *) ;;
esac



# Kibana installation
# Linux and MacOS
case $OS in
  'Linux')
     if [ ! -f "${DOWNLOAD_FOLDER}/${KIBANA_LINUX_BIN}" ]
     then
       echo "${KIBANA_LINUX_BIN} NOT found."
       wget ${ES_ROOT_URL}/kibana/${KIBANA_LINUX_BIN} -P ${DOWNLOAD_FOLDER}
     fi
     tar -xvf ${DOWNLOAD_FOLDER}/${KIBANA_LINUX_BIN} -C ${INSTAL_FOLDER}
     mv ${INSTAL_FOLDER}/${KIBANA_LINUX_FOLDER} ${INSTAL_FOLDER}/kibana
    ;;
  'Darwin')
     if [ ! -f "${DOWNLOAD_FOLDER}/${KIBANA_MACOS_BIN}" ]
     then
       echo "${KIBANA_MACOS_BIN} NOT found"
       wget ${ES_ROOT_URL}/kibana/${KIBANA_MACOS_BIN} -P ${DOWNLOAD_FOLDER}
     fi
     tar -xvf ${DOWNLOAD_FOLDER}/${KIBANA_MACOS_BIN} -C ${INSTAL_FOLDER}
     mv ${INSTAL_FOLDER}/${KIBANA_MACOS_FOLDER} ${INSTAL_FOLDER}/kibana
    ;;
  *) ;;
esac



# Logstash installation
# Linux and MacOS
if [ ! -f "${DOWNLOAD_FOLDER}/${LOGSTASH_BIN}" ]
then
  echo "${LOGSTASH_BIN} NOT found"
  wget ${ES_ROOT_URL}/logstash/${LOGSTASH_BIN} -P ${DOWNLOAD_FOLDER}
fi
tar -xvf ${DOWNLOAD_FOLDER}/${LOGSTASH_BIN} -C ${INSTAL_FOLDER}
mv ${INSTAL_FOLDER}/${LOGSTASH_FOLDER} ${INSTAL_FOLDER}/logstash
