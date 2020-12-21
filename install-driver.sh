#!/bin/bash

OUTPUT_CURL_DIR="./drivers"
rm -rf  $OUTPUT_CURL_DIR

#check req. package
packageCheckJq=$( dpkg-query -l jq)
packageCheckUnzip=$( dpkg-query -l jq)

if [[ $packageCheckJq != "dpkg-query: no packages found matching jq" ]]; then
  echo
    echo -e "JQ package has been installed        [  \e[32mOK\e[0m  ]"
else
  echo
    echo -e "JQ package not found       [  \e[31mFAIL\e[0m  ]"

    read -r -p "jq package will be installed do you want to continue (y/n)? " response
case "$response" in

[yY])

  sudo apt install jq -y

    ;;
*)
    echo "exit"
    exit
esac
fi

if [[ $packageCheckUnzip != "dpkg-query: no packages found matching unzip" ]]; then
  echo
    echo -e "unzip package has been installed     [  \e[32mOK\e[0m  ]"
  else
  echo
    echo -e "unzip package not found      [  \e[31mFAIL\e[0m  ]"

    read -r -p "unzip package will be installed do you want to continue (y/n)? " response1
case "$response1" in

[yY])

  sudo apt install unzip -y

    ;;
*)
    echo "exit"
    exit
esac
fi

#Chrome latest driver
CHORME_DRIVER_VERSION="$(curl -sS https://chromedriver.storage.googleapis.com/LATEST_RELEASE)"
CHORME_DRIVER_API="https://chromedriver.storage.googleapis.com/"
CHORME_DRIVER_FILE="/chromedriver_linux64.zip"
CHROME_PREFIX="/chromedriver/"

echo
echo -e "Chrome Latest driver version :" $CHORME_DRIVER_VERSION
echo

curl -o $OUTPUT_CURL_DIR$CHROME_PREFIX$CHORME_DRIVER_VERSION/$CHORME_DRIVER_VERSION.zip $CHORME_DRIVER_API$CHORME_DRIVER_VERSION$CHORME_DRIVER_FILE --create-dirs
cd $OUTPUT_CURL_DIR$CHROME_PREFIX$CHORME_DRIVER_VERSION || exit
sleep .5
unzip $CHORME_DRIVER_VERSION.zip
sleep 1
rm -rf $CHORME_DRIVER_VERSION.zip
cd ~/test-automation-tools || exit

FIREFOX_DRIVER_VERSION="$(curl -s https://api.github.com/repos/mozilla/geckodriver/releases/latest | jq -r '.tag_name')"
FIREFOX_PREFIX="/firefox-geckodriver/"
FIREFOX_DRIVER_FILE="geckodriver-$FIREFOX_DRIVER_VERSION-linux64.tar.gz"

echo
echo -e "Firefox Latest driver version : " $FIREFOX_DRIVER_VERSION
echo

DOWNLOAD_FFDRIVER="$(curl -L -o $OUTPUT_CURL_DIR$FIREFOX_PREFIX$FIREFOX_DRIVER_VERSION/$FIREFOX_DRIVER_VERSION.tar.gz https://github.com/mozilla/geckodriver/releases/download/$FIREFOX_DRIVER_VERSION/$FIREFOX_DRIVER_FILE --create-dirs)"

if [[ $FIREFOX_DRIVER_VERSION == *"https"* ]];
then
  echo "Firefox Driver cannot found. Please try again later."
else
$DOWNLOAD_FFDRIVER
cd $OUTPUT_CURL_DIR$FIREFOX_PREFIX$FIREFOX_DRIVER_VERSION || exit
sleep .5
tar xf $FIREFOX_DRIVER_VERSION.tar.gz
sleep 1
rm -rf $FIREFOX_DRIVER_VERSION.tar.gz
fi