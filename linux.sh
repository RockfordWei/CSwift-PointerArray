tar czvf /tmp/cswift.tgz Sources Tests Package.swift module.modulemap build.lib.sh
scp /tmp/cswift.tgz 192.168.56.11:/tmp
ssh 192.168.56.11 "cd /tmp;rm -rf cswift;mkdir cswift;cd cswift;tar xzvf ../cswift.tgz;swift build;./build.lib.sh;swift test"
