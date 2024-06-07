JAVA_TO_SET="/home/t21/Downloads/jdk/graalvm-ce-java11-20.2.0"

sudo ln -sfn ${JAVA_TO_SET}/jre/bin/java /etc/alternatives/java
sudo ln -sfn ${JAVA_TO_SET}/bin/java /etc/alternatives/java
sudo ln -sfn ${JAVA_TO_SET}/bin/jjs /etc/alternatives/jjs
sudo ln -sfn ${JAVA_TO_SET}/bin/keytool /etc/alternatives/keytool
sudo ln -sfn ${JAVA_TO_SET}/bin/pack200 /etc/alternatives/pack200
sudo ln -sfn ${JAVA_TO_SET}/bin/rmid /etc/alternatives/rmid
sudo ln -sfn ${JAVA_TO_SET}/bin/rmiregistry /etc/alternatives/rmiregistry
sudo ln -sfn ${JAVA_TO_SET}/bin/unpack200 /etc/alternatives/unpack200
