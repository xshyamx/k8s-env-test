#!/bin/sh

kubectl create -f base.yml

for i in 1 2 3; do
  kubectl create -f job-0$i.yml
done

printf "Waiting for job to complete"

expected='1 1 1'
actual=''
while [ "$expected" != "$actual" ]; do
  actual=$(kubectl get jobs -o jsonpath={.items[*].status.succeeded})
  sleep 1
  printf '.'
done
echo done

#kubectl get pods -l app=env-test -o jsonpath={.items[*].status.containerStatuses[*]}

for i in 1 2 3; do
  pod=$(kubectl get pod -l job-name=job-0$i -o jsonpath={.items[*].metadata.name})
  printf "job-%02d: " $i
  kubectl logs $pod | grep 'key='
done

#kubectl delete -f .
