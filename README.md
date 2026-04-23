# Civictrail
A unified app developed to integrate state and federal government projects, enhancing transparency and citizen awareness and engagement in Nigeria

CivicTrail is a multi-application repository containing a Django backend and a Flutter mobile/web application, managed under a single codebase with unified CI/CD using GitHub Actions and deployment to Azure Web Apps.

## Repository Structure

- **civic/** – Django project configuration  
  - settings.py  
  - urls.py  
  - asgi.py  
  - wsgi.py  

- **civictrail/** – Django app (frontend/API components)  
  - migrations/  
  - static/  
  - templates/  
  - models.py  
  - views.py  
  - urls.py  

- **civic_flutter/** – Flutter mobile + web application  
  - lib/  
  - android/  
  - ios/  
  - web/  
  - pubspec.yaml  
  - analysis_options.yaml  

- manage.py – Django entry point  
- requirements.txt – Django dependencies  
- db.sqlite3 – Local development database  
- .github/workflows/ – CI/CD workflows  
  - ci-cd.yml  
- README.md

---

## Technology Stack

- **Backend:** Django (Python)
- **Mobile/Web Client:** Flutter (Dart)
- **CI/CD:** GitHub Actions
- **Project Management:** Azure DevOps (Scrum, Boards, Pipelines)

---

## Local Development

This repository contains **two applications**.  
Commands must be run from the correct directory.

---

### Django Web Application

Run from the **project root** (`civictrail-app/`):

```bash
python3 -m venv venv
source venv/bin/activate
pip3 install -r requirements.txt
python3 manage.py migrate
python3 manage.py runserver
```
Access at:
(http://127.0.0.1:8000)

### Flutter Mobile

>Flutter commands must be run inside civic_flutter/:

```bash
cd civic_flutter
flutter pub get
flutter run
```
---
## Testing
### Django
```bash
python3 manage.py test
```
### Flutter

```bash
cd civic_flutter
flutter test
```
---

## CI/CD

This project uses GitHub Actions for continuous integration:

- Builds and tests Django and Flutter apps

- Runs on pushes to main

- Documentation-only changes can be excluded from CI

---

## Project Management

Development is managed using Azure DevOps Scrum with structured Epics, Features, and PBIs, covering:

- Research & data collection

- Requirements analysis

- UI/UX design

- Mobile application development

- Testing, evaluation, and deployment

### Project duration:
September 2025 – January 2026

## Author

*Rebecca Uwah*


