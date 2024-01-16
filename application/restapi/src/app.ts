import express, { response } from 'express';
import 'dotenv/config';
import { Client } from 'node-rest-client';

const app = express();
const port = 8080;

const dbendpoint=process.env.DBENDPOINT;
console.log(`Database endpoint: ${dbendpoint}`);

const api = new Client();


app.get('/', (req, res) => {
  res.send('The front-end is running...');
});

app.get("/:index", (req, res) => {
  api.get(`${dbendpoint}/index/${req.params.index}`,
  (data, response) => {
    const buf = Buffer.from(data);
    console.log(buf.toString());
    res.send(`Found: ${data}`);
  });
});


app.listen(port, () => {
  return console.log(`Express is listening at http://localhost:${port}`);
});

