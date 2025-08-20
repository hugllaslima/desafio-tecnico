import http from 'http';
import PG from 'pg';

// Configurações do servidor
const port = Number(process.env.PORT) || 3000;

// Configurações do banco de dados
const dbConfig = {
  user: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASS || 'password123',
  host: process.env.DB_HOST || 'localhost',
  port: process.env.DB_PORT || 5432,
  database: process.env.DB_NAME || 'desafio_db',
};

const client = new PG.Client(dbConfig);

let successfulConnection = false;

// Conectar ao banco na inicialização
async function initializeDatabase() {
  try {
    await client.connect();
    successfulConnection = true;
    console.log('Connected to database successfully');
  } catch (err) {
    console.error('Database connection failed:', err.message);
    successfulConnection = false;
  }
}

// Inicializar conexão
initializeDatabase();

http.createServer(async (req, res) => {
  console.log(`Request: ${req.url}`);

  if (req.url === "/api") {
    res.setHeader("Content-Type", "application/json");
    res.setHeader("Access-Control-Allow-Origin", "*");
    res.writeHead(200);

    let result = null;

    if (successfulConnection) {
      try {
        const queryResult = await client.query("SELECT * FROM users LIMIT 1");
        result = queryResult.rows[0];
      } catch (error) {
        console.error('Database query error:', error.message);
      }
    }

    const data = {
      database: successfulConnection,
      userAdmin: result?.role === "admin" || false
    };

    res.end(JSON.stringify(data));
  } else {
    res.writeHead(404);
    res.end(JSON.stringify({ error: "Not Found" }));
  }

}).listen(port, () => {
  console.log(`Server is listening on port ${port}`);
  console.log(`Environment: ${process.env.NODE_ENV || 'development'}`);
});
