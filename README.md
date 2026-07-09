# Billing App (Flutter)

3-section billing app with PDF bill generation:
1. Customer Details
2. Item Entry (Cut No, Qty, Rate, Dori, Cit Total)
3. Preview & Generate/Share PDF

## Run locally
```bash
flutter pub get
flutter run
```

## Push to GitHub

```bash
cd billing_app
git init
git add .
git commit -m "Initial commit: billing app scaffold"
git branch -M main
git remote add origin https://github.com/shabnam777/billing_app.git
git push -u origin main
```

(Create the empty repo `billing_app` on GitHub first, then run above.)

## CI/CD

GitHub Actions workflow at `.github/workflows/flutter_ci.yml` runs on every push/PR to `main`:
- `flutter pub get`
- `flutter analyze`
- `flutter test`
- `flutter build apk --release`
- Uploads the release APK as a downloadable artifact (Actions tab → workflow run → Artifacts)

No secrets needed for this basic pipeline. For signed release builds (Play Store), add keystore secrets later and update the build step.
