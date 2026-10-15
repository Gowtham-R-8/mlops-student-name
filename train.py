import os
import pickle
import numpy as np
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score

MODEL_PATH = os.path.join("model", "student_result_model.pkl")

def main():
    os.makedirs("model", exist_ok=True)
    rng = np.random.default_rng(42)
    n = 800
    study_hours = rng.uniform(0, 10, n)
    attendance = rng.uniform(30, 100, n)
    internal_marks = rng.uniform(0, 50, n)

    # Synthetic teaching data: this is a demonstration model, not an official grading rule.
    score = (study_hours * 4.0) + (attendance * 0.18) + (internal_marks * 0.75)
    probability = 1 / (1 + np.exp(-(score - 48) / 7))
    passed = (rng.random(n) < probability).astype(int)

    X = np.column_stack([study_hours, attendance, internal_marks])
    X_train, X_test, y_train, y_test = train_test_split(
        X, passed, test_size=0.2, random_state=42, stratify=passed
    )
    model = RandomForestClassifier(n_estimators=150, random_state=42, class_weight="balanced")
    model.fit(X_train, y_train)
    accuracy = accuracy_score(y_test, model.predict(X_test))

    with open(MODEL_PATH, "wb") as f:
        pickle.dump(model, f)
    print(f"Model saved to {MODEL_PATH}; validation accuracy: {accuracy:.3f}")

if __name__ == "__main__":
    main()
