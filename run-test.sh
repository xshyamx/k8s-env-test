#!/bin/sh

kubectl create -k .

printf "Waiting for job to complete"

expected=''
for i in `seq 1 6`; do
  expected="$expected 1"
done
expected=$(echo $expected | sed -e 's/^ //')
actual=''
while [ "$expected" != "$actual" ]; do
  actual=$(kubectl get jobs -o jsonpath={.items[*].status.succeeded})
  sleep 1
  printf '.'
done
echo done

#kubectl get pods -l app=env-test -o jsonpath={.items[*].status.containerStatuses[*]}

for i in `seq 1 6`; do
  pod=$(kubectl get pod -l job-name=job-0$i -o jsonpath={.items[*].metadata.name})
  printf "job-%02d: " $i
  kubectl logs $pod | grep 'key='
done

kubectl delete -k .
