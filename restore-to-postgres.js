/**
 * Electricity Department Puducherry (PED)
 * Restore master SQLite data into PostgreSQL (Railway, Supabase, Neon, or local).
 *
 * Usage:
 *   DATABASE_URL="postgresql://user:pass@host:5432/dbname" npm run restore
 */

const fs = require('fs');
const path = require('path');
const zlib = require('zlib');
const { Pool } = require('pg');

let Database;
try {
  Database = require('better-sqlite3');
} catch (e) {
  console.error("Please run 'npm install' first to install required dependencies.");
  process.exit(1);
}

const dbUrl = process.env.DATABASE_URL || process.argv[2];
if (!dbUrl) {
  console.error('ERROR: DATABASE_URL environment variable or command-line argument is required.');
  console.error('Example: DATABASE_URL="postgresql://user:pass@host:5432/dbname" npm run restore');
  process.exit(1);
}

// Unpack SQLite if needed
const gzPath = path.join(__dirname, 'data', 'ped-connect.db.gz');
const sqlitePath = path.join(__dirname, 'data', 'ped-connect.db');

if (!fs.existsSync(sqlitePath) && fs.existsSync(gzPath)) {
  console.log('Uncompressing data/ped-connect.db.gz...');
  const compressed = fs.readFileSync(gzPath);
  const decompressed = zlib.gunzipSync(compressed);
  fs.writeFileSync(sqlitePath, decompressed);
  console.log('Database uncompressed successfully.');
}

if (!fs.existsSync(sqlitePath)) {
  console.error('ERROR: data/ped-connect.db not found!');
  process.exit(1);
}

const sqlite = new Database(sqlitePath, { readonly: true });

const isInternal = dbUrl.includes('railway.internal') || dbUrl.includes('localhost') || dbUrl.includes('127.0.0.1');
const pool = new Pool({
  connectionString: dbUrl,
  ssl: isInternal ? false : { rejectUnauthorized: false },
  max: 10,
});

function escapeSqlVal(v) {
  if (v === null || v === undefined) return 'NULL';
  if (typeof v === 'number') return isNaN(v) ? 'NULL' : String(v);
  if (typeof v === 'boolean') return v ? 'TRUE' : 'FALSE';
  const str = String(v).replace(/'/g, "''");
  return "'" + str + "'";
}

async function restore() {
  console.log('Connecting to PostgreSQL target database...');
  const client = await pool.connect();
  console.log('Connected successfully.\n');

  try {
    const tables = sqlite.prepare("SELECT name, sql FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' ORDER BY name").all();
    console.log(`Found ${tables.length} tables to restore.\n`);

    for (const tableInfo of tables) {
      const tableName = tableInfo.name;
      const pragmaCols = sqlite.prepare(`PRAGMA table_info("${tableName}")`).all();
      const colDefs = [];
      const primaryKeys = [];

      for (const col of pragmaCols) {
        let type = 'TEXT';
        const uType = (col.type || '').toUpperCase();
        if (col.pk === 1 && (uType.includes('INT') || (tableInfo.sql && tableInfo.sql.includes('AUTOINCREMENT')))) {
          type = 'SERIAL';
          primaryKeys.push(`"${col.name}"`);
        } else if (uType.includes('INT')) {
          type = 'BIGINT';
        } else if (uType.includes('REAL') || uType.includes('FLOA') || uType.includes('DOUB') || uType.includes('NUM')) {
          type = 'DOUBLE PRECISION';
        } else {
          type = 'TEXT';
        }
        colDefs.push(`"${col.name}" ${type}`);
      }

      console.log(`=== Table [${tableName}] ===`);
      await client.query(`DROP TABLE IF EXISTS "${tableName}" CASCADE;`);

      let createSql = `CREATE TABLE "${tableName}" (\n  ` + colDefs.join(',\n  ');
      if (primaryKeys.length > 0) {
        createSql += `,
  PRIMARY KEY (${primaryKeys.join(', ')})`;
      }
      createSql += '\n);';
      await client.query(createSql);

      const colNames = pragmaCols.map(c => `"${c.name}"`);
      const totalRows = sqlite.prepare(`SELECT count(*) as c FROM "${tableName}"`).get().c;

      if (totalRows > 0) {
        const batchSize = 500;
        let batch = [];
        let inserted = 0;
        const stmt = sqlite.prepare(`SELECT * FROM "${tableName}"`);

        await client.query('BEGIN');
        for (const row of stmt.iterate()) {
          const vals = pragmaCols.map(c => escapeSqlVal(row[c.name]));
          batch.push(`(${vals.join(', ')})`);

          if (batch.length >= batchSize) {
            const sql = `INSERT INTO "${tableName}" (${colNames.join(', ')}) VALUES ${batch.join(', ')};`;
            await client.query(sql);
            inserted += batch.length;
            batch = [];
            if (totalRows > 5000 && inserted % 25000 === 0) {
              console.log(`  ... inserted ${inserted.toLocaleString()} / ${totalRows.toLocaleString()} rows`);
            }
          }
        }

        if (batch.length > 0) {
          const sql = `INSERT INTO "${tableName}" (${colNames.join(', ')}) VALUES ${batch.join(', ')};`;
          await client.query(sql);
          inserted += batch.length;
        }

        await client.query('COMMIT');
        console.log(`  -> Inserted ${inserted.toLocaleString()} rows into ${tableName}`);

        // Reset sequence if primary key is serial
        if (primaryKeys.length === 1) {
          try {
            await client.query(`SELECT setval(pg_get_serial_sequence('"${tableName}"', 'id'), COALESCE(MAX(id), 1)) FROM "${tableName}";`);
          } catch (e) {
            // Ignore if no id sequence
          }
        }
      } else {
        console.log(`  -> Table is empty (0 rows)`);
      }
      console.log('');
    }

    console.log('Creating performance indexes...');
    await client.query(`
      CREATE INDEX IF NOT EXISTS idx_arrears_consumer_no ON arrears(consumer_no);
      CREATE INDEX IF NOT EXISTS idx_arrears_section ON arrears(section);
      CREATE INDEX IF NOT EXISTS idx_arrears_division ON arrears(division);
      CREATE INDEX IF NOT EXISTS idx_arrears_status ON arrears(status);
      CREATE INDEX IF NOT EXISTS idx_arrears_arrears_total ON arrears(arrears_total);
      CREATE INDEX IF NOT EXISTS idx_arrears_mobile ON arrears(mobile);
      CREATE INDEX IF NOT EXISTS idx_staff_employee_id ON staff(employee_id);
      CREATE INDEX IF NOT EXISTS idx_broadcast_active ON broadcast_notifications(is_active);
      CREATE INDEX IF NOT EXISTS idx_disconnection_consumer ON disconnection_events(consumer_no);
    `);

    console.log('\n======================================================');
    console.log('  ALL TABLES, DATA, AND INDEXES SUCCESSFULLY RESTORED!  ');
    console.log('======================================================\n');
  } catch (err) {
    await client.query('ROLLBACK').catch(() => {});
    console.error('RESTORE FAILED:', err);
    process.exit(1);
  } finally {
    client.release();
    await pool.end();
  }
}

restore();
