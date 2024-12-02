const express = require("express");
const healthRecordContract = require("./contract"); // Import the contract instance

const app = express();
app.use(express.json());

// API endpoint to add a record
app.post('/addRecord', async (req, res) => {
    const { data } = req.body;

    try {
        const tx = await healthRecordContract.addRecord(data);
        const receipt = await tx.wait();

        // Log the transaction receipt to understand its structure
        console.log("Transaction Receipt:", receipt);

        if (receipt.status !== 1) {
            console.error("Transaction failed:", receipt);
            return res.status(500).json({ error: "Transaction failed" });
        }

        // Check for the event
        const event = receipt.events?.find(event => event.event === "RecordAdded");

        if (!event) {
            console.error("No RecordAdded event found in receipt:", receipt);
            return res.status(500).json({ error: "No RecordAdded event found" });
        }

        const newRecordId = event.args[0].toString();
        res.json({ message: "Record added successfully", recordId: newRecordId });
    } catch (error) {
        console.error("Error adding record:", error);
        res.status(500).json({ error: "Failed to add record" });
    }
});
  

// Assuming you have a function to fetch a record
app.get("/getRecord/:id", async (req, res) => {
    try {
      const id = req.params.id; // Get the ID from the request parameters
      const record = await healthRecordContract.getRecord(id); // Call the contract function
      
      // Convert the BigInt to a string or number before sending it in the response
      const response = {
        id: record.id.toString(), // Convert BigInt to string
        user: record.user,
        data: record.data,
      };
  
      res.status(200).json(response); // Send the response
    } catch (error) {
      console.error("Error fetching record:", error);
      res.status(500).send({ message: "Error fetching record", error });
    }
  });  

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
   console.log(`Server running on port ${PORT}`);
});
