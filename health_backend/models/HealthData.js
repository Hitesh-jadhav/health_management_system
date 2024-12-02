// models/HealthData.js
const mongoose = require('mongoose');

const healthDataSchema = new mongoose.Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        required: true,
        ref: 'User' // Reference to the User model
    },
    age: {
        type: Number,
        required: true
    },
    bmi: {
        type: Number,
        required: true
    },
    bloodPressure: {
        type: Number,
        required: true
    },
    cholesterol: {
        type: Number,
        required: true
    },
    glucose: {
        type: Number,
        required: true
    },
    date: {
        type: Date,
        default: Date.now
    }
});

module.exports = mongoose.model('HealthData', healthDataSchema);
