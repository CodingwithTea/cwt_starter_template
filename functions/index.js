const functions = require("firebase-functions");
const admin = require("firebase-admin");

// Initialize Firebase Admin SDK
admin.initializeApp();


//  --------------- Import notification functions ---------------
const { sendNotifications } = require('./notifications/order_notifications');

exports.sendNotification = sendNotifications;