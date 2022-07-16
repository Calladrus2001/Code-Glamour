const { credential } = require('firebase-admin');
const admin = require('firebase-admin');
const serviceAccount = require('./codeglamour-81570-firebase-adminsdk-irt1k-745819e173.json');
const bodyParser = require('body-parser');
const express = require('express');
const app = express();

app.use(bodyParser.urlencoded({
    extended: true
}));
app.use(bodyParser.json());

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
});
const db = admin.firestore();


//! function for querying users START
async function getSnapshot(query) {
    var result = [];
    const snapshot = await db.collection("Users").get();
    snapshot.forEach((doc)=>{
        if (doc.data()["Designer"] != false){
            doc.data()["tags"].forEach((tag)=>{
                if (tag == query){
                    console.log(doc.id);
                    result.push(doc.id);
                }
            });
        }
    });
    return result;
};
//! function for querying users END


app.post("/webhook", (req,res) => {
    if (!req.body) res.sendStatus(400);
    else {
        const response = req.body.queryResult.parameters['clothes'][0];
        var result = getSnapshot(response).then((name)=>{
            res.send(JSON.stringify({
            "fulfillmentMessages":[{
            "text" : {
                "text" : [`Designer email for ${response} outfits: ${name}`]
                    }
                }]
            }));
        });
    }
});

app.listen(3000, ()=>{
    console.log("Started Listening on port 3000");
});