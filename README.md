# Student Result Predictor

A Flask + scikit-learn demo app for the MLOps Practical Assessment. It accepts study hours, attendance percentage, and internal marks and predicts Pass/Fail.

## Run locally (Windows PowerShell)

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
docker build -t student-result-predictor .
docker run --rm -p 5000:5000 student-result-predictor
```

Open http://localhost:5000.

## EC2 deployment notes

- Allow inbound TCP port 80 in the EC2 security group.
- Install Docker and the CodeDeploy agent on the EC2 instance.
- Attach an IAM instance profile that permits CodeDeploy to manage deployments.
- Create a CodeDeploy application and deployment group targeting the instance.
- Create a CodePipeline source from GitHub and deployment stage to CodeDeploy (no Build stage required).
- Make sure the EC2 instance has outbound access to fetch packages/images during Docker build.

Initially, the deployment script sets `MODEL_VERSION=1.0`. After the first successful deployment, change `MODEL_VERSION=1.0` to `MODEL_VERSION=2.0` in `scripts/deploy_container.sh`, commit and push the change, and verify that the pipeline deploys the updated page without logging in to EC2.

## Important

The training data is synthetic and the prediction is for demonstration only. It is not an official academic result or a validated student assessment model.
