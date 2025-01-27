const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');

const app = express();

// Add support for form data
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// MongoDB connection
mongoose.connect('mongodb://mongo:27017/inventory', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

// Define the inventory schema
const inventorySchema = new mongoose.Schema({
  _id: Number,
  name: String,
  qty: Number,
  rating: Number,
  microsieverts: Number,  // Added this field
}, { strict: false });  // Allow additional fields

const Inventory = mongoose.model('Inventory', inventorySchema);

// Ensure initial data exists in the DB
const initData = [
  { _id: 1, name: "apples", qty: 5, rating: 3 },
  { _id: 2, name: "bananas", qty: 7, rating: 1, microsieverts: 0.1 },
  { _id: 3, name: "oranges", qty: 6, rating: 2 },
  { _id: 4, name: "avocados", qty: 3, rating: 5 },
];

async function initializeData() {
  const count = await Inventory.countDocuments();
  if (count === 0) {
    await Inventory.insertMany(initData);
  }
}

// Initialize data when the app starts
initializeData();

// Route: Get the quantity of apples
app.get('/', async (req, res) => {
  const apple = await Inventory.findOne({ name: 'apples' });
  res.send(`
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Hello World</title>
        <style>
            body {
                background-color: black;
                color: white;
                text-align: center;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
                flex-direction: column;
                font-family: 'Arial', sans-serif;
            }

            h1 {
                font-size: 6rem;
                margin-bottom: 20px;
            }

            .fade-in-out {
                font-size: 1.5rem;
                color: white;
                opacity: 0;
                animation: fadeInOut 3s forwards;  /* Faster fade-in, slower fade-out */
                margin-top: 20px;
                animation-delay: 0.3s;  /* Delay before starting fade */
            }

            @keyframes fadeInOut {
                0% { opacity: 0; }
                50% { opacity: 1; }
                100% { opacity: 0; }
            }

            h2 {
                font-size: 3rem;
                margin-top: 20px;
            }

            p {
                font-size: 2rem;
                margin-top: 10px;
            }

            .add-container {
                font-size: 1.5rem;
                margin-top: 20px;
            }

            .add-container button {
                font-size: 2rem;
                background-color: black;
                color: white;
                padding: 10px 20px;
                border-radius: 5px;
                border: 2px solid white;
            }

            .add-container button:hover {
                background-color: white;
                color: black;
            }

        </style>
    </head>
    <body>
        <div>
            <h1>Hello World</h1>
            <div class="fade-in-out">To Daniel, Yaniv or King Moshe</div>
            <p>You currently have <span style="font-size: 3rem;">${apple ? apple.qty : 0}</span> little apples in the basket! :)</p>
            <p>Not enough?</p>
            <div class="add-container">
                <form method="POST" action="/add">
                    <button type="submit">Add 🍎</button>
                </form>
            </div>
        </div>
    </body>
    </html>
  `);
});

// Route: Add apple quantity
app.post('/add', async (req, res) => {
  try {
    const qtyToAdd = 1;  // We're adding 1 apple at a time
    
    const apple = await Inventory.findOne({ name: 'apples' });

    // If apples don't exist in the database, create it with the starting qty of 5
    if (!apple) {
      await Inventory.create({ name: 'apples', qty: 5, rating: 3 });
    } else {
      await Inventory.updateOne(
        { name: 'apples' },
        { $inc: { qty: qtyToAdd } }
      );
    }

    res.redirect('/');
  } catch (error) {
    res.status(400).send(`Error: ${error.message}`);
  }
});

app.listen(3000, () => {
  console.log('App running on http://localhost:3000');
});
