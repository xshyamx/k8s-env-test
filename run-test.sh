#!/bin/sh

kubectl create -f base.yml

for i in 1 2 3; do
  kubectl create -f job-0$i.yml
done

printf "Waiting for 5 seconds..."
sleep 5
echo done

for i in 1 2 3; do
  pod=$(kubectl get pod -l job-name=job-0$i -o jsonpath={.items[*].metadata.name})
  printf "job-%02d: " $i
  kubectl logs $pod | grep 'key='
done

#kubectl delete -f .
