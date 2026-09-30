import { randomBytes } from 'node:crypto';
import { existsSync, readFileSync, writeFileSync } from 'node:fs';
const path = '.dev.vars';
const old = existsSync(path) ? readFileSync(path, 'utf8') : '';
const existing = old.match(/^ADMIN_SETUP_CODE=(.+)$/m)?.[1]?.replace(/^"|"$/g, '');
const code = existing || randomBytes(24).toString('hex');
if (!existing) writeFileSync(path, `${old.trimEnd()}${old.trim() ? '\n' : ''}ADMIN_SETUP_CODE=${code}\n`);
console.log('\nAdmin setup code (keep private): ' + code);
console.log('Register a member, then enter this code in the first-admin form.\n');
