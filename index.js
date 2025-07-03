const mysql = require('mysql2/promise');
const fs = require('fs');
const path = require('path');

const {
    DB_HOST = 'localhost',
    DB_PORT = 3306,
    DB_USER = 'root',             // ⚠️ Use root here for setup
    DB_PASSWORD = '',
    DB_NAME,
    SQL_FILE = 'init.sql',
    TARGET_DB_USER                // 👈 Add this to grant access to your app user (e.g., TMC_Admin)
} = process.env;

if (!DB_NAME || !SQL_FILE) {
    console.error('❌ Missing required environment variables: DB_NAME and SQL_FILE');
    process.exit(1);
}

(async () => {
    const sqlPath = path.resolve(SQL_FILE);

    if (!fs.existsSync(sqlPath)) {
        console.error(`❌ SQL file not found: ${sqlPath}`);
        process.exit(1);
    }

    const sql = fs.readFileSync(sqlPath, 'utf8');

    let connection;
    try {
        connection = await mysql.createConnection({
            host: DB_HOST,
            port: Number(DB_PORT),
            user: DB_USER,
            password: DB_PASSWORD,
            multipleStatements: true,
        });

        await connection.query(`CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;`);

        if (TARGET_DB_USER) {
            await connection.query(`GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${TARGET_DB_USER}'@'%';`);
            await connection.query(`FLUSH PRIVILEGES;`);
            console.log(`🔑 Granted privileges to '${TARGET_DB_USER}' on '${DB_NAME}'`);
        }

        await connection.changeUser({ database: DB_NAME });

        console.log(`🚀 Running SQL from: ${sqlPath}`);
        await connection.query(sql);

        console.log('✅ Database setup complete.');
    } catch (err) {
        console.error('❌ Failed to set up database:', err.message);
        process.exit(1);
    } finally {
        if (connection) await connection.end();
    }
})();
