const express = require('express');
const router = express.Router();
const Task = require('../models/Task');
const fs = require('fs'); 

// Endpoint GET /tasks 
router.get('/', async (req, res) => {
  try {
    res.json(await Task.getAllTasks());
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Endpoint POST /tasks
router.post('/', async (req, res) => {
  try {
    const newTask = req.body;
    const response = await Task.createTask(newTask); // Đợi createTask hoàn thành

    res.status(201).json(response); // Gửi response sau khi đã ghi file
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Endpoint GET /tasks/:id
router.get('/:id', async (req, res) => {
  try {
    const taskId = parseInt(req.params.id);
    const task = await Task.getTaskById(taskId);
    res.json(task);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Endpoint PUT /tasks/:id
router.put('/:id', async (req, res) => {
  try {
    const taskId = parseInt(req.params.id); 
    const updatedTask = req.body;
    const response = await Task.updateTask(taskId, updatedTask);
    res.json(response);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Endpoint DELETE /tasks/:id
router.delete('/:id', async (req, res) => {
  try {
    const taskId = parseInt(req.params.id); 
    const response = await Task.deleteTask(taskId);

    if (response.message === 'Task deleted successfully!') { 
      res.json(response); 
    } else {
      res.status(404).json(response); 
    }
  } catch (error) {
    console.error("Error deleting task:", error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;