const { Client } = require('pg');
const mysql = require('mysql2/promise');
const fs = require('fs');
const path = require('path');
const https = require('https');


const {
    DB_HOST = 'localhost',
    DB_PORT = 3306,
    DB_USER = 'root',
    DB_PASSWORD = '',
    DB_NAME,
    SQL_FILE = '',
    DB_Type = '',
    SQL_URL = ''
} = process.env;


if (!DB_NAME || !SQL_FILE) {
    console.error('❌ Missing required environment variables: DB_NAME and SQL_FILE');
    process.exit(1);
}

(async () => {
    const sqlPath = path.resolve(SQL_FILE);
    const dbType = DB_Type.toLowerCase();
    console.log(`🔍 Detected DB_Type: ${DB_Type} → normalized: ${dbType}`);
    console.log(`📄 SQL File to execute: ${sqlPath}`);

    if (SQL_URL) {
        const file = fs.createWriteStream(sqlPath);

        https.get(SQL_URL, response => {
            if (response.statusCode !== 200) {
                console.error(`❌ Download failed: ${response.statusCode}`);
                return;
            }

            response.pipe(file);
            file.on('finish', () => {
                file.close(() => console.log('✅ Download completed.'));
            });
        }).on('error', err => {
            fs.unlink(sqlPath, () => {}); // cleanup
            console.error('❌ Error downloading file:', err.message);
        });
    }



    if (!fs.existsSync(sqlPath)) {
        console.error(`❌ SQL file not found: ${sqlPath}`);
        process.exit(1);
    }

    const sql = fs.readFileSync(sqlPath, 'utf8');

    let connection;

    try {
        const port = Number(DB_PORT) || (DB_Type === 'PostGre' ? 5432 : 3306);

        switch (dbType) {
            case 'mysql':
                console.log("Starting Process for MySql")
                const connectionString = {
                    host: DB_HOST,
                    port,
                    user: DB_USER,
                    password: DB_PASSWORD,
                    multipleStatements: dbType === 'mysql', // only MySQL supports this
                };

                connection = await mysql.createConnection(connectionString);

                console.log(`🚀 Running SQL from: ${sqlPath}`);
                await connection.query(sql);
                break;

            case 'postgre':
                console.log("Starting Process for PostgreSQL");
                try {
                    // Connect to 'postgres' first for DB creation
                    const adminClient = new Client({
                        host: DB_HOST,
                        port,
                        user: DB_USER,
                        password: DB_PASSWORD,
                        database: 'postgres',
                    });
                    await adminClient.connect();

                    const res = await adminClient.query('SELECT 1 FROM pg_database WHERE datname = $1', [DB_NAME]);
                    if (res.rowCount === 0) {
                        await adminClient.query(`CREATE DATABASE "${DB_NAME}"`);
                        console.log(`✅ Created database ${DB_NAME}`);
                    }
                    await adminClient.end();
                } catch (err) {
                    console.log("Error during Admin connection: " + err);
                }

                try {
                    // Connect to the target DB
                    connection = new Client({
                        host: DB_HOST,
                        port,
                        user: DB_USER,
                        password: DB_PASSWORD,
                        database: DB_NAME,
                    });
                    await connection.connect();

                    console.log(`🚀 Running SQL from: ${sqlPath}`);
                    await connection.query(sql);

                    // Log all tables created
                    const result = await connection.query("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'");
                    console.log("📊 Tables in the database after SQL execution:");
                    result.rows.forEach(row => {
                        console.log(`- ${row.table_name}`);
                    });

                    await connection.end();
                } catch (err) {
                    console.log("Error during Client connection: " + err);
                }
                break;

            default:
                throw new Error(`Unsupported DB_Type: ${DB_Type}`);
        }

        console.log('✅ Database setup complete.');
    } catch (err) {
        console.error('❌ Failed to set up database:', err.message);
        process.exit(1);
    } finally {
        if (connection) await connection.end();
        process.exit(0);
    }
})();
