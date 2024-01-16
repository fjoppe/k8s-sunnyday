import express from 'express';
import csv from "csv-parser";
import fs from "fs";

const app = express();
const port = 3000;

const data = [];

fs.createReadStream("./people-100.csv")
  .pipe(csv())
  .on('data', (row) => data.push(row))
  .on('end', () => {
    console.log(data);
  })


app.get('/index/:index', (req, res) => {
  const row = data.find(row => row.Index === req.params.index);
  if(row !== null){
    res.send(JSON.stringify(row));
  } else {
    res.send('{"error": "Index not found"}');
  }
});

app.listen(port, () => {
  return console.log(`Express is listening at http://localhost:${port}`);
});
