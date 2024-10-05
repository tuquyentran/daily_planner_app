const fs = require('fs').promises;

let users = [];

(async () => {
  try {
    const usersData = await fs.readFile('./data/users.json', 'utf-8');
    users = JSON.parse(usersData);
  } catch (error) {
    console.error("Error loading users from file:", error);
    try {
      await fs.writeFile('./data/users.json', JSON.stringify([], null, 2));
      console.log("Created new users.json file.");
    } catch (createError) {
      console.error("Error creating users.json file:", createError);
    }
  }
})();

// Lấy tất cả users
function getAllUsers() {
  return users;
}

// Lấy user theo email (thêm hàm này)
function getUserByEmail(email) {
  const user = users.find(user => user.email === email);
  return user;
}

module.exports = { getAllUsers, getUserByEmail };