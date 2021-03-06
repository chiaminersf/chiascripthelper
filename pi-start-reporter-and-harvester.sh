cd

echo "Check1: check upnp setup"
cat ~/.chia/mainnet/config/config.yaml | grep upnp


echo "Step1: (re)start reporter"
sleep 1
ps aux | grep chiaminersf_reporter.py | grep -v grep |  awk '{print $2}'  |  xargs sudo kill -9
cd ~/metricreporter

. ./venv/bin/activate
python chiaminersf_reporter.py > /dev/null 2>&1 &

sleep 2

report_pid=$(ps aux | grep chiaminersf_reporter.py | grep -v grep | awk '{print $2}')
if [ -z "$report_pid" ]
then
	echo "Failed: not started chia metric reporter"
else
	echo "Succeeded: started chia metric reporter" 
fi

echo "Step2: (re)start harvester"
sleep 1

cd
cd chia-blockchain
. ./activate
chia start harvester -r


report_pid=$(ps aux | grep chia_harvester | grep -v grep | awk '{print $2}')
if [ -z "$report_pid" ]
then
	echo "Failed: not started chia harvester"
else
	echo "Succeeded: started chia harvester" 
fi
