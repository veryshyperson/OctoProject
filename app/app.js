const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');

const app = express();

// Add support for form data
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// MongoDB connection details from environment variables
const MONGODB_SERVICE = process.env.MONGODB_SERVICE || 'mongodb-service';
const MONGODB_PORT = process.env.MONGODB_PORT || '27017';
const MONGODB_DATABASE = process.env.MONGODB_DATABASE || 'inventory';
const MONGODB_USERNAME = process.env.MONGODB_USERNAME;
const MONGODB_PASSWORD = process.env.MONGODB_PASSWORD;

// Construct MongoDB URI based on authentication requirements
const mongoUri = MONGODB_USERNAME && MONGODB_PASSWORD
  ? `mongodb://${MONGODB_USERNAME}:${MONGODB_PASSWORD}@${MONGODB_SERVICE}:${MONGODB_PORT}/${MONGODB_DATABASE}`
  : `mongodb://${MONGODB_SERVICE}:${MONGODB_PORT}/${MONGODB_DATABASE}`;

console.log('Attempting to connect to MongoDB at:', MONGODB_SERVICE); // Debug log

// MongoDB connection with retry logic
const connectWithRetry = async () => {
  const connectOptions = {
    useNewUrlParser: true,
    useUnifiedTopology: true,
    serverSelectionTimeoutMS: 5000,
    retryWrites: true
  };

  console.log('Attempting to connect to MongoDB...');
  
  try {
    await mongoose.connect(mongoUri, connectOptions);
    console.log('Successfully connected to MongoDB');
  } catch (err) {
    console.error('Failed to connect to MongoDB, retrying in 5 seconds...', err);
    setTimeout(connectWithRetry, 5000);
  }
};

// Initial connection attempt
connectWithRetry();

// Handle MongoDB connection events
mongoose.connection.on('connected', () => {
  console.log('Mongoose connected to MongoDB');
});

mongoose.connection.on('error', (err) => {
  console.error('Mongoose connection error:', err);
});

mongoose.connection.on('disconnected', () => {
  console.log('Mongoose disconnected, attempting to reconnect...');
  connectWithRetry();
});

const inventorySchema = new mongoose.Schema({
  _id: Number,
  name: String,
  qty: Number,
  rating: Number,
  microsieverts: Number,
}, { strict: false });

const Inventory = mongoose.model('Inventory', inventorySchema);

// Modified initialization function with retry logic
async function initializeData() {
  try {
    const count = await Inventory.countDocuments();
    if (count === 0) {
      const initData = [
        { _id: 1, name: "apples", qty: 5, rating: 3 },
        { _id: 2, name: "bananas", qty: 7, rating: 1, microsieverts: 0.1 },
        { _id: 3, name: "oranges", qty: 6, rating: 2 },
        { _id: 4, name: "avocados", qty: 3, rating: 5 },
      ];
      await Inventory.insertMany(initData);
      console.log('Initial data inserted successfully');
    }
  } catch (err) {
    console.error('Error initializing data:', err);
    setTimeout(initializeData, 5000);
  }
}

// Initialize data once connected
mongoose.connection.once('connected', () => {
  initializeData();
});

// Route: Get the quantity of apples
app.get('/', async (req, res) => {
  try {
    const apple = await Inventory.findOne({ name: 'apples' });
    const basketCount = apple ? apple.qty : 0;
    const friendlyMessage = basketCount === 0 ? "Oh no! No apples left! 🍏 Please add more." : '';

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
              h1 { font-size: 6rem; margin-bottom: 20px; }
              .fade-in-out {
                  font-size: 1.5rem;
                  color: white;
                  opacity: 0;
                  animation: fadeInOut 3s forwards;
                  margin-top: 20px;
                  animation-delay: 0.3s;
              }
              @keyframes fadeInOut {
                  0% { opacity: 0; }
                  50% { opacity: 1; }
                  100% { opacity: 0; }
              }
              h2 { font-size: 3rem; margin-top: 20px; }
              p { font-size: 2rem; margin-top: 10px; }
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
              <div class="fade-in-out">To Daniel, Yaniv, or King Moshe</div>
              <p>You currently have <span style="font-size: 3rem;">${basketCount}</span> little apples in the basket! :)</p>
              ${friendlyMessage ? `<h2>${friendlyMessage}</h2>` : ''}
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
  } catch (error) {
    console.error('Error in root route:', error);
    res.status(500).send('Error loading the page');
  }
});

// Route: Add apple quantity
app.post('/add', async (req, res) => {
  try {
    const qtyToAdd = 1;
    
    const apple = await Inventory.findOne({ name: 'apples' });

    if (!apple) {
      await Inventory.create({ _id: 1, name: 'apples', qty: 5, rating: 3 });
    } else {
      await Inventory.updateOne(
        { name: 'apples' },
        { $inc: { qty: qtyToAdd } }
      );
    }

    res.redirect('/');
  } catch (error) {
    console.error('Error in add route:', error);
    res.status(400).send(`Error: ${error.message}`);
  }
});

// Add health check endpoint
app.get('/health', (req, res) => {
  const isHealthy = mongoose.connection.readyState === 1;
  res.status(isHealthy ? 200 : 500)
     .json({ 
       status: isHealthy ? 'healthy' : 'unhealthy',
       mongoConnection: mongoose.connection.readyState
     });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`App running on http://localhost:${PORT}`);
});