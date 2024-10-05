const fs = require('fs').promises;
const { DateTime } = require('luxon');
let tasks = [];

// Load tasks from the file when the app starts
(async () => {
  try {
    const tasksData = await fs.readFile('./data/tasks.json', 'utf-8');
    tasks = JSON.parse(tasksData); // Now allowed because `tasks` is mutable
  } catch (error) {
    console.error("Error loading tasks from file:", error);
    // Xử lý lỗi khi không thể đọc file, ví dụ: tạo file mới với tasks = []
    try {
      await fs.writeFile('./data/tasks.json', JSON.stringify([], null, 2));
      console.log("Created new tasks.json file.");
    } catch (createError) {
      console.error("Error creating tasks.json file:", createError);
    }
  }
})();

// get all tasks
function getAllTasks() {
  return tasks; 
}

//get task by ID
function getTaskById(taskId) {
  const task = tasks.find(task => task.id === taskId); 
  if (task) {
    return task;
  } else {
    return { message: 'Task not found' };
  }
}

// create task
async function createTask(newTask) {
  try {
    console.log("New task received:", newTask);

    const id = tasks.length + 1;
    console.log("Generated ID:", id);

    const formattedDate = DateTime.fromFormat(newTask.date, 'yyyy-MM-dd');
    newTask.date = formattedDate.toFormat('EEEE, dd/MM/yyyy');

    tasks.push({ id, ...newTask }); 

    await fs.writeFile('./data/tasks.json', JSON.stringify(tasks, null, 2));
    console.log("Tasks array after adding:", tasks);

    return { message: 'Task created successfully!', taskId: id };
  } catch (error) {
    console.error("Error creating task:", error);
    throw error; 
  }
}

// update task
async function updateTask(taskId, updatedTask) {
  try {
    const taskIndex = tasks.findIndex(task => task.id === taskId);

    if (taskIndex !== -1) {
      const formattedDate = DateTime.fromISO(updatedTask.date).toFormat('EEEE, dd/MM/yyyy');
      tasks[taskIndex] = { ...tasks[taskIndex], ...updatedTask, date: formattedDate };

      await fs.writeFile('./data/tasks.json', JSON.stringify(tasks, null, 2));

      return { message: 'Task updated successfully!' };
    } else {
      return { message: 'Task not found' };
    }
  } catch (error) {
    console.error("Error updating task:", error);
    throw error;
  }
}

// delete task
async function deleteTask(taskId) {
  try {
    const taskIndex = tasks.findIndex(task => task.id === taskId);

    if (taskIndex !== -1) {
      tasks.splice(taskIndex, 1);

      // Ghi lại dữ liệu vào tasks.json sau khi xóa task
      await fs.writeFile('./data/tasks.json', JSON.stringify(tasks, null, 2)); 

      return { message: 'Task deleted successfully!' };
    } else {
      return { message: 'Task not found' };
    }
  } catch (error) {
    console.error("Error deleting task:", error);
    throw error;
  }
}

module.exports = { getAllTasks, createTask, getTaskById, updateTask, deleteTask};