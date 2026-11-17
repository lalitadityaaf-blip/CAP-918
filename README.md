# PG Manager

A free Ionic + Angular + Capacitor app for shared PGs.
- **Owners** track rent and mess dues, the complaint box, renter IDs, rooms and notices.
- **Renters** see their dues, pay via UPI, manage their mess plan, raise complaints and see their roommates.

It works offline and syncs when the network is back.

Docs: [architecture](../docs/architecture.md) · [syllabus mapping (CAP918)](../docs/syllabus-mapping.md) · [store listing](../docs/store-listing.md) · [analytics & crash reporting](../docs/analytics-and-crash-reporting.md) · [backend setup](supabase/README.md)

## Requirements
- **Node 24.15+** (or 22.22.3+). Angular 22 refuses older versions.
- Android Studio for Android builds; a Mac with Xcode for iOS builds.

## Start (from the project root `e:\Lalit_project`)
| What | Double-click / terminal | VS Code (Terminal → Run Task…) |
|---|---|---|
| Frontend + backend, in two windows | `start-all.cmd` | **Start all** |
| Frontend only (demo mode if no backend) | `start-frontend.cmd` → http://localhost:4200 | **Frontend** |
| Backend only (local Supabase, needs Docker Desktop) | `start-backend.cmd` (`-Reset` wipes the DB) | **Backend** |
| Stop backend, back to demo mode | `stop-backend.cmd` | **Stop backend** |

The backend script writes the local API URL and key into `src/environments/environment.ts`, so the frontend switches from demo to live by itself.
The local backend comes with a ready-made demo PG ([supabase/seed.sql](supabase/seed.sql)). The OTP is `123456` for all of these:

| Phone | Account |
|---|---|
| `9000000001` | Owner of "Sunshine PG (Boys)" |
| `9000000002` | Renter: Rahul Verma, Room 101 (rent overdue) |
| `9000000003` | Renter: Aman Gupta, Room 101 (paid; Rahul's roommate) |
| `9000000004` | New user, not in any PG yet: log in, then join with invite code `KARTIK` |

`start-backend.cmd -Reset` restores this demo data.

To test the backend rules without Docker, run `npm run test:backend`. It runs the real migration and seed in an in-memory Postgres and checks privacy, permissions, merging, invites and account deletion.

## Run manually
```bash
npm install
npm start                 # http://localhost:4200, demo mode with sample data
npm run test:unit         # unit tests (sync merge, clocks, dues, deep links)
```
In demo mode, pick **I'm a PG owner** or **I'm a renter**. To switch roles, use Settings → Log out.

## Native builds
```bash
npm run build
npx cap sync
npx cap open android      # build / run from Android Studio
npx cap open ios          # macOS only
```
Live reload on a phone: `ionic cap run android -l --external`.

## Enabling the real backend, analytics and crash reports
Fill in `src/environments/environment.prod.ts` (see [supabase/README.md](supabase/README.md) and [analytics doc](../docs/analytics-and-crash-reporting.md)).
Leaving `supabaseUrl` empty keeps the app in demo mode.
