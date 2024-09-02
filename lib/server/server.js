const express = require("express");
const bodyParser = require("body-parser");
const admin = require("firebase-admin");
const { Firestore } = require("@google-cloud/firestore");
const serviceAccount = require("./../../assets/keys/key.json");

admin.initializeApp({
  projectId: admin.credential.cert(serviceAccount),
  credential: admin.credential.cert(serviceAccount),
});
const firestore = new Firestore(
  {
    projectId: serviceAccount.project_id,
    credentials:{
      client_email: serviceAccount.client_email,
      private_key: serviceAccount.private_key,
    }
  }
);
const app = express();
app.use(bodyParser.json());

app.post("/send-notification", async (req, res) => {
  const { senderToken, title, body } = req.body;
  try {
    const tokenSnapshot = await firestore.collection("tokens").get();
    const tokens = tokenSnapshot.docs
      .map((doc) => doc.data().token)
      .filter((token) => token !== senderToken);
    
    console.log("Tokens to send notifications to:", tokens); // Log tokens

    if (tokens.length === 0) {
      return res.status(200).send("No other devices registered.");
    }
    const message = {
      notification: {
        title: title,
        body: body,
      },
      tokens: tokens,
    };
    await admin.messaging().sendMulticast(message); // Use sendMulticast instead of send for multiple tokens
    res.status(200).send("Notification sent successfully");
  } catch (error) {
    console.error("Error sending notification:", error); // Log error
    res.status(500).send("Error sending notification: " + error);
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
