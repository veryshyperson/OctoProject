# 2Minikube

<img width="1000" alt="Image" src="https://github.com/user-attachments/assets/d548c26a-5675-45e6-bf51-9a7979350f89" />

With Minikube we had the possibilty to get a bit "wilder". <br>
I had to make adjustments to docker image in order to connect the "Pod-App" to "Pod-DB" via services and not the docker network.<br>
## NodeJS App Pulls docker image ransperber/octoapp
we pushed the adjusted image to docker hub.<br> 
i went straight into creating a Kuberentes Helm chart manifests so we could easily watch over the entire orchestration with ArgoCD.<br>
### With ArgoCD and a Helm Chart we are able to remain organized and have a clearer view of the Application's on-abouts in our cluster.
Here is a little graph of what the App currently builds:
<br><br>

<img width="1000" alt="Image" src="https://github.com/user-attachments/assets/4b99cf2e-6191-4e00-8109-8673b51ebabc"> <br><br>

### Lets make it simple:

<img width="1000" alt="Image" src="https://github.com/user-attachments/assets/57b188a7-f0aa-485a-b8e0-aafc140a308a"> <br>

### One by one
1. configmap - makes the intiallzation of the DB now as requested:

```json
[
  { "_id": 1, "name": "apples", "qty": 5, "rating": 3 },
  { "_id": 2, "name": "bananas", "qty": 7, "rating": 1, "microsieverts": 0.1 },
  { "_id": 3, "name": "oranges", "qty": 6, "rating": 2 },
  { "_id": 4, "name": "avocados", "qty": 3, "rating": 5 }
]
```
2. db-statefulset -  a stateful set with a hostPath provisioner for minikube.<br>
makes a volume in the minkube container as practice - when pod fails data saves and you could easily continiue making requests when stateful MongoDB pod gets back to life<br>
3. app-deployment deployment for the app, in case the app pod crashes it could comeback to life aswell.
4. db-service - how __NodeJS__ Pod communicates makes the requests to __MongoDB__ StatefulSet.
<br>
<br>

## Make it happen!<br>

### Considering you have Docker.
In order to run the minikube run ``` ./start.sh__ ``` in 2Minikube directory. <br>
it also sets you up with argocd.
<br><br>
``` kubectl create -f application.yaml ``` to release __apple-basket__ into the cluster.<br>
<br>
``` kubectl port-forward pods/nodejs-app-6db6c659b9-2dgbp 3000:3000 & kubectl port-forward -n argocd svc/argocd-server 8080:443 ```<br>
<br>
``` localhost:8080``` __for ArgoCD__
<br><br>
``` localhost:3000``` for __apple-basket__ UI