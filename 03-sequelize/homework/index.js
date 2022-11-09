const app = require("./server");
const { db } = require("./db");
const PORT = 3000;

async function main() {
  try {
    await db.authenticate();
    app.listen(PORT, () => {
      console.log(`Server listening on port ${PORT}`);
      db.sync({ force: true });
    });
  } catch (error) {
    console.error("Imposible conectar con la base de datos:", error);
  }
}
main();
