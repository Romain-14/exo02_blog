import mysql from 'mysql2/promise';

// import des variables d'environnements exportées depuis le fichier /lib/index.js
import { DB_HOST, DB_NAME, DB_USER, DB_PWD } from '../lib/index.js';

const pool = mysql.createPool({
    host: DB_HOST,
    database: DB_NAME,
    user: DB_USER,
    password: DB_PWD,
});

pool.getConnection().then(res=>console.log(`Connected to ${res.config.database}`));

export default pool;