# Environment Variable Test #

Check the override behavior of `envFrom` in the pod template spec

1. Create config-maps & secrets

   ``` sh
   kubectl create cm base --from-literal=key=configmap
   kubectl create cm override --from-literal=key=configmap-override
   kubectl create secret generic base --from-literal=key=secret
   kubectl create secret generic base --from-literal=key=secret-override
   ```
   
   or 
   
   ``` sh
   kubectl create -f base.yml
   ```

2. Deploy 3 jobs each successively overriding the env from config-map/secret

   ``` sh
   for i in 1 2 3 4 5 6; do
     kubectl create -f job-0$i.yml
   done
   ```

3. Check the value from each of the jobs

   ``` sh
   for i in 1 2 3 4 5 6; do
     pod=$(kubectl get pod -l job-name=job-0$i -o jsonpath={.items[*].metadata.name})
     printf "job-%02d: " $i
     kubectl logs $pod | grep 'key='
   done
   ```

	Expect output like
	<details>
	  <summary>Output</summary>

	``` text
	job-01: key=configmap
	job-02: key=configmap-override
	job-03: key=secret
	job-04: key=secret-override
	job-05: key=inline
	job-06: key=command	
	```

	</details>

4. Cleanup 
   
   ``` sh
   kubectl delete -k .
   ```
