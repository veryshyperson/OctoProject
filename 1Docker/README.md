# 1Docker

<img width="1000" alt="Image" src="https://github.com/user-attachments/assets/e62e900c-e520-4b7a-a2fb-df9a4237b851" />

Before getting started, it all begins from the actual build of the application's images. In our case, we need a unique single image for our **NodeJS App**.

The application is super simple – **Apple Basket**.  <br>
We were requested to use **NodeJS** as the Machine's Engine and **MongoDB** as the "basket" database. <br>
The task required us to return the number of apples.

We were requested to pre-configure the database with a few "fruits".  <br>
```json
[
  { "_id": 1, "name": "apples", "qty": 5, "rating": 3 },
  { "_id": 2, "name": "bananas", "qty": 7, "rating": 1, "microsieverts": 0.1 },
  { "_id": 3, "name": "oranges", "qty": 6, "rating": 2 },
  { "_id": 4, "name": "avocados", "qty": 3, "rating": 5 }
]
```

<img width="1000" alt="Image" src="https://github.com/user-attachments/assets/953582d4-c3bd-4559-a240-9538d06d1dd3"> <br>

Our Application pulls the amount of Apples we have in the basket (db) and we are able to add apples by pressing "add 🍎" which adds and aggregates the amount of apples.
the NodeJS initiallizes the database and creates a MongoDB collection and Pulls/Updates the Database with simple code functions.<br>
<br>
After building the NodeJS image, iv'e established a docker compose<br>
the docker compose builds the custom NodeJS image and the MongoDB container and through the docker-network allows communication between the containers.<br>
<br>
smaller title: easy to make it happen!<br>
in order to build simply, and locally the architecure (considering you have pulled the git repository and you stand in the 1Docker directory)<br><br>

to create:<br>
```docker compose up --build```<br>
access the application via<br>
 ```localhost:3000``` <br>