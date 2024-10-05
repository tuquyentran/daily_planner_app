const express = require('express');
const app = express();
const cors = require('cors');
const port = 3000;

app.use(cors());
app.use(express.json());

// Use the router for the tasks API
const tasksRouter = require('./routes/tasks');
app.use('/api/tasks', tasksRouter);

// Use the router for the users API
const usersRouter = require('./routes/users');
app.use('/api/users', usersRouter);

app.listen(port, () => console.log(`Server listening on port ${port}`));