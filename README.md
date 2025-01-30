# 🍎🍎🍎🍎🍎🍎🍎🍎🍎🍎🍎Welcome🍎🍎🍎🍎🍎🍎🍎🍎🍎🍎🍎🍎🍎

## Octopus gave me a task.

# Each Directory in the repo has a visual demonstartion of the architecure
__There are 3 playgrounds for our app "apple-basket".__


<img width="1000" alt="Image" src="https://github.com/user-attachments/assets/0a18022e-7979-4710-b3bc-4f942b1d4a97" />

1. Simple Docker Compose
2. Minikube Cluster
3. Real Deal - Terraform to Cloud Provider (AWS)

## Managed to provision Hello World little Apples
The app is called apple-basket<br>
2 componets - NodeJS and MongoDB.
the NodeJS image also includes Alpine as Linux distro<br>

## Every Application starts with the entire fruit basket

```json
  [ { "_id": 1, "name": "apples", "qty": 5, "rating": 3 }, { "_id": 2, "name": "bananas", "qty": 7, "rating": 1, "microsieverts": 0.1 }, { "_id": 3, "name": "oranges", "qty": 6, "rating": 2 }, { "_id": 4, "name": "avocados", "qty": 3, "rating": 5 }, ]
  ```

<br>

that means that each playground returns 5 apple at start, but you can add more and aggregate apples if you'd like.
<br>

### This is the a git repo that sets you up with various "playgrounds" to inspect the application.

### Provision from scratch, no images
With Docker-Compose, Minikube bash Script and Terraform 

## CI-CD

<img width="1000" alt="Image" src="https://github.com/user-attachments/assets/b8f7fef0-1c2c-4265-9e36-78853413b505" />
<br><br>

I included an extra ci-cd with Github Actions - Updates an outside [ArgoCD Repo](https://github.com/veryshyperson/OctoProject-GitOps) for the OctoProject<br>
The CI Searches for updates in the App (base Cluster image) directory and re-builds it in case any changes were made and commited<br>
It sends the image under the last commit sha to my docker hub repo __ransperber/octopapp__ and updates values.yaml files in the ArgoCD-OctoProject repo<br>
That the pods will pull the newer image and cluster will preform a rolling update for the newer image.

## My AI uses - for those who wonder.
AI didn't provide much help, rather than coding and assiting the avoidance of long yamls writing and bash scripts. <br>
in the README's I gave my own explenations. For that part I dedicated and self-wrote it.

## Where should we be going with this ?

### I have a plan for higher availabilty.

In this project, I didnt set up a real database as for not wanting to start a subscription with MongoDB. <br>
Our PVS in our stateful sets acted as the whole database.<br>
__in the future__ i would like to get rid of the statefulsets, and use ReplicaSets, that way, the apple's aggregation (requests)<br>
will be "Loadbalanced" through the pods and that way we could easily create higher requests rates and let the MongoDB do its autoscaling work in case needed.

<img width="1000" alt="Image" src="https://github.com/user-attachments/assets/43d594d6-26a4-4141-8dc0-5a2f48cb3c3d" />



