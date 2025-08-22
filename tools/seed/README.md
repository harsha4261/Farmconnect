# Firestore seed

This folder contains a small Node script using `firebase-admin` to populate initial configuration.

Steps:
1. In Firebase Console → Project Settings → Service Accounts → Generate new private key. Download the JSON and save it here as `serviceAccount.json` (do not commit).
2. Install deps and run the seeder:
```
cd tools/seed
npm install
node seed.js --project farmconnect-9826b
```
3. The script will create/overwrite:
- app_config/navigation
- features/*
- crops/*
- suppliers/* (sample)
- content/tutorials/* (sample)

You can pass `--yes` to suppress prompts.
