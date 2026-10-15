# MLOps Student Predictor

## Project structure

```text
mlops-student-predictor/
├── app.py
├── train.py
├── requirements.txt
├── Dockerfile
├── templates/
│   └── index.html
├── static/
│   └── style.css
└── deploy-scripts/
    └── deploy.sh
```

`appspec.yml` is intentionally omitted for the no-CodeDeploy approach.

## Run locally on Windows

```powershell
py -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install -r requirements.txt
python train.py
python app.py
```

Open http://127.0.0.1:5000.

## Run with Docker

```bash
docker build -t mlops-student-predictor .
docker run --rm -p 5000:5000 -e MODEL_VERSION=1.0 mlops-student-predictor
```

Open http://localhost:5000.

## EC2 deployment script

The script expects the project files to already be present on EC2 in `/opt/mlops-student-predictor`. It builds the image, replaces the running container, and publishes the app on port 80.

```bash
sudo mkdir -p /opt/mlops-student-predictor
# Copy/checkout the repository into that directory, then:
cd /opt/mlops-student-predictor
chmod +x deploy-scripts/deploy.sh
MODEL_VERSION=1.0 ./deploy-scripts/deploy.sh
```

After the first deployment, set `MODEL_VERSION=2.0` to demonstrate the version change:

```bash
MODEL_VERSION=2.0 ./deploy-scripts/deploy.sh
```

## Important: automatic deployment without appspec.yml

Removing `appspec.yml` means this is not an AWS CodeDeploy deployment. A pipeline still needs a mechanism to run the script on EC2 (for example, AWS Systems Manager Run Command invoked by a pipeline stage, with the EC2 instance configured as a Systems Manager managed node and the required IAM permissions). A GitHub push alone will not execute this script automatically unless that trigger and remote execution stage are configured.

The model is trained on synthetic demonstration data. Its predictions are not official academic results.
