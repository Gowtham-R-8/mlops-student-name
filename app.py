import os
import pickle
from flask import Flask, render_template, request

app = Flask(__name__)
MODEL_PATH = os.path.join("model", "student_result_model.pkl")
MODEL_VERSION = os.getenv("MODEL_VERSION", "1.0")

with open(MODEL_PATH, "rb") as model_file:
    model = pickle.load(model_file)

@app.route("/", methods=["GET", "POST"])
def index():
    prediction = None
    probability = None
    error = None
    values = {"study_hours": "3", "attendance": "80", "internal_marks": "35"}

    if request.method == "POST":
        values = {
            "study_hours": request.form.get("study_hours", "").strip(),
            "attendance": request.form.get("attendance", "").strip(),
            "internal_marks": request.form.get("internal_marks", "").strip(),
        }
        try:
            study_hours = float(values["study_hours"])
            attendance = float(values["attendance"])
            internal_marks = float(values["internal_marks"])

            if not 0 <= study_hours <= 24:
                raise ValueError("Study hours must be between 0 and 24.")
            if not 0 <= attendance <= 100:
                raise ValueError("Attendance must be between 0 and 100.")
            if not 0 <= internal_marks <= 50:
                raise ValueError("Internal marks must be between 0 and 50.")

            result = int(model.predict([[study_hours, attendance, internal_marks]])[0])
            prediction = "Pass" if result == 1 else "Fail"
            if hasattr(model, "predict_proba"):
                probability = round(float(max(model.predict_proba(
                    [[study_hours, attendance, internal_marks]]
                )[0])) * 100, 1)
        except ValueError as exc:
            error = str(exc) or "Please enter valid numeric values."

    return render_template(
        "index.html", prediction=prediction, probability=probability,
        error=error, values=values, model_version=MODEL_VERSION
    )

@app.route("/health")
def health():
    return {"status": "ok", "model_version": MODEL_VERSION}, 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
