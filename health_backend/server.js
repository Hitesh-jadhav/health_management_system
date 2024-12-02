const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
const User = require("./models/User");
const HealthData = require("./models/HealthData");
const bcrypt = require("bcrypt");
const mongoose = require("mongoose");
const jwt = require("jsonwebtoken");
const { PythonShell } = require("python-shell");
const { spawn } = require("child_process");
require("dotenv").config();

const app = express();
app.use(express.json());
app.use(cors());

// Connect to MongoDB
mongoose
  .connect("mongodb://localhost:27017/health_management")
  .then(() => console.log("Connected to MongoDB"))
  .catch((err) => console.error("Could not connect to MongoDB", err));

// Simple GET route to test the server
app.get("/", (req, res) => {
  res.send("Health Management API");
});

app.post("/register", async (req, res) => {
  const { username, password, email } = req.body; // Now including email
  try {
    const hashedPassword = await bcrypt.hash(password, 10);
    const newUser = new User({ username, password: hashedPassword, email }); // Including email in User creation
    await newUser.save();
    res.status(201).json({ message: "User registered" });
  } catch (error) {
    console.error("Error in registration:", error);
    res.status(400).json({ error: "Error registering user" });
  }  
});

// predict Endpoint
app.post("/predict", (req, res) => {
  const inputData = req.body;

  // Start the Python process and pass the input data as an argument
  const process = spawn("python", ["predict.py", JSON.stringify(inputData)]);

  let predictionOutput = ""; // Buffer to collect the output

  // Collect output data from the Python script
  process.stdout.on("data", (data) => {
    predictionOutput += data.toString();
  });

  // Handle error output from the Python script
  process.stderr.on("data", (data) => {
    console.error(`Error output: ${data}`);
  });

  // After the process closes, send the response
  process.on("close", (code) => {
    console.log(`Python process exited with code ${code}`);
    try {
      const prediction = JSON.parse(predictionOutput.trim()); // Parse JSON output if needed
      res.status(200).json(prediction);
    } catch (error) {
      console.error("Error parsing prediction output:", error);
      res.status(500).json({ error: "Failed to parse prediction output" });
    }
  });
});

app.post("/login", async (req, res) => {
    try {
      const { username, password } = req.body;
  
      // Use await to get the user from MongoDB
      const user = await User.findOne({ username });
      if (!user) {
        return res.status(401).json({ error: "Invalid username" });
      }
  
      // Check if the password matches (assuming plain-text password comparison)
      const isPasswordMatch = await bcrypt.compare(password, user.password);
      if (!isPasswordMatch) {
        return res.status(401).json({ error: "Invalid password" });
      }
  
      // Create JWT token
      const token = jwt.sign(
        { id: user._id, username: user.username },
        process.env.JWT_SECRET,
        { expiresIn: "1h" }
      );
  
      // Send token to client
      res.json({ token });
    } catch (error) {
      console.error("Login error:", error);
      res.status(500).json({ error: "Internal server error" });
    }
  });
  


// Middleware to verify JWT token
function authenticateToken(req, res, next) {
  const token = req.headers["authorization"];
  if (!token) return res.status(401).json({ error: "Access token missing" });

  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) return res.status(403).json({ error: "Invalid token" });
    req.user = user; // Add user info to request object
    next();
  });
}

app.get("/health_data", async (req, res) => {
    const authHeader = req.headers["authorization"];
    const token = authHeader && authHeader.split(" ")[1];
  
    if (!token) return res.status(401).json({ error: "Token missing" });
  
    try {
      // Verify the token
      const user = jwt.verify(token, process.env.JWT_SECRET);
  
      // Fetch the health data for the authenticated user
      const data = await HealthData.findOne({ userId: user.id });
      
      if (!data) {
        return res.status(404).json({ error: "Health data not found" });
      }
      
      res.status(200).json(data);
  
    } catch (error) {
      if (error.name === "JsonWebTokenError") {
        return res.status(403).json({ error: "Invalid token" });
      }
      console.error("Error fetching health data:", error);
      res.status(500).json({ error: "Internal server error" });
    }
  });
  

// Define health data endpoint
app.get("/health_data/:userId", async (req, res) => {
  const { userId } = req.params;

  try {
    // Find the user or health data record by userId
    const healthData = await User.findById(userId).select("healthData"); // Adjust field as needed

    if (!healthData) {
      return res.status(404).json({ error: "User health data not found" });
    }

    res.status(200).json(healthData);
  } catch (error) {
    console.error("Error retrieving health data:", error);
    res.status(500).json({ error: "Server error" });
  }
});

// Get all users endpoint (requires admin access or authentication if needed)
app.get("/users", async (req, res) => {
  try {
    const users = await User.find({});
    res.status(200).json(users);
  } catch (error) {
    console.error("Error fetching users:", error);
    res.status(500).json({ error: "Failed to retrieve users" });
  }
});

// Define delete user endpoint
app.delete("/user/:userId", async (req, res) => {
  const { userId } = req.params;

  try {
    // Find and delete the user by userId
    const deletedUser = await User.findByIdAndDelete(userId);

    if (!deletedUser) {
      return res.status(404).json({ error: "User not found" });
    }

    res.status(200).json({ message: "User deleted successfully" });
  } catch (error) {
    console.error("Error deleting user:", error);
    res.status(500).json({ error: "Server error" });
  }
});

// Define endpoint to add health data
app.post("/health_data", async (req, res) => {
  const { userId, age, bmi, bloodPressure, cholesterol, glucose } = req.body;

  try {
    // Create a new health data entry
    const newHealthData = new HealthData({
      userId,
      age,
      bmi,
      bloodPressure,
      cholesterol,
      glucose,
    });

    // Save the health data to the database
    await newHealthData.save();
    res
      .status(201)
      .json({ message: "Health data added successfully", data: newHealthData });
  } catch (error) {
    console.error("Error adding health data:", error);
    res.status(400).json({ error: "Error adding health data" });
  }
});



const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
