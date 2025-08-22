import { readFile } from 'fs/promises';
import yargs from 'yargs/yargs';
import { hideBin } from 'yargs/helpers';
import admin from 'firebase-admin';

const argv = yargs(hideBin(process.argv))
  .option('project', { type: 'string', demandOption: true })
  .option('yes', { type: 'boolean', default: false })
  .argv;

async function initAdmin() {
  const keyPath = new URL('./serviceAccount.json', import.meta.url);
  const raw = await readFile(keyPath);
  const cred = JSON.parse(raw.toString());
  const serviceProjectId = cred.project_id;
  if (serviceProjectId && serviceProjectId !== argv.project) {
    console.warn(`Warning: serviceAccount project_id (${serviceProjectId}) differs from --project (${argv.project}). Using serviceAccount project.`);
  }
  admin.initializeApp({
    credential: admin.credential.cert(cred),
  });
  return admin.firestore();
}

async function seedNavigation(db) {
  const doc = db.collection('app_config').doc('navigation');
  await doc.set({
    bottom: [
      { title: 'Dashboard', icon: 'dashboard', route: '/farmer-dashboard', roles: ['farmer'] },
      { title: 'Search', icon: 'search', route: '/job-search-and-filtering', roles: ['farmer'] },
      { title: 'Bookings', icon: 'book', route: '/booking-management', roles: ['farmer'] },
      { title: 'Profile', icon: 'person', route: '/profile-management', roles: ['farmer'] }
    ],
  }, { merge: true });
}

async function seedFeatures(db) {
  await db.collection('features').doc('ai').set({ enabled: true, price: true, weather: true, disease: true }, { merge: true });
  await db.collection('features').doc('inventory').set({ enabled: true }, { merge: true });
}

async function seedCrops(db) {
  await db.collection('crops').doc('tomato').set({ defaultMarket: 'Guntur', aliases: ['tomato'], thresholds: { lowMoisture: 20 } }, { merge: true });
}

async function seedSuppliers(db) {
  const suppliers = [
    { name: 'Green Agro Store', category: 'seeds', phone: '+91 98999 00000', address: 'Main Rd, Guntur', website: 'https://example.com' },
    { name: 'FertiPlus Traders', category: 'fertilizers', phone: '+91 97777 11111', address: 'Market Rd, Vijayawada' },
  ];
  for (const s of suppliers) {
    await db.collection('suppliers').add(s);
  }
}

async function seedContent(db) {
  const tutorials = [
    { title: 'Pesticide Safety Basics', duration: '4:20', tags: ['safety', 'pesticide', 'worker'], videoUrl: '' },
    { title: 'Tractor Operation 101', duration: '6:05', tags: ['equipment'], videoUrl: '' },
  ];
  for (const t of tutorials) {
    await db.collection('content').add(t);
  }
}

async function main() {
  try {
    const db = await initAdmin();
    console.log(`Seeding Firestore...`);
    await seedNavigation(db);
    await seedFeatures(db);
    await seedCrops(db);
    await seedSuppliers(db);
    await seedContent(db);
    console.log('Done.');
    process.exit(0);
  } catch (e) {
    console.error('\nSeed failed. Checklist:');
    console.error('- Firestore enabled and database created (Console → Firestore Database → Create).');
    console.error('- Service account JSON belongs to the same Firebase project.');
    console.error('- Service account has Firestore permissions (Editor/Owner).');
    console.error('- Network/VPC egress not blocking googleapis.');
    console.error('\nRaw error:');
    console.error(e);
    process.exit(1);
  }
}

main();
