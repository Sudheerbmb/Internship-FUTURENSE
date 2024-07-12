import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import OneHotEncoder, StandardScaler
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
import numpy as np

df = pd.read_csv("C:/Users/sudhe/Documents/DataSets/Loan/finalloan.csv")

X = df.drop(columns=['Customer ID', 'Name', 'Loan Sanction Amount (USD)'])
y = df['Loan Sanction Amount (USD)']

numerical_cols = X.select_dtypes(include=['int64', 'float64']).columns
categorical_cols = X.select_dtypes(include=['object']).columns

numerical_transformer = StandardScaler()
categorical_transformer = OneHotEncoder(handle_unknown='ignore')

preprocessor = ColumnTransformer(
    transformers=[
        ('num', numerical_transformer, numerical_cols),
        ('cat', categorical_transformer, categorical_cols)
    ])

model = Pipeline(steps=[
    ('preprocessor', preprocessor),
    ('regressor', RandomForestRegressor())
])

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

model.fit(X_train, y_train)

y_pred = model.predict(X_test)

# Evaluating the model
mae = mean_absolute_error(y_test, y_pred)
mse = mean_squared_error(y_test, y_pred)
rmse = mse ** 0.5
r2 = r2_score(y_test, y_pred)

print(f"MAE: {mae}")
print(f"MSE: {mse}")
print(f"RMSE: {rmse}")
print(f"R2: {r2}")

def get_user_input():
    user_data = {}
    for col in numerical_cols:
        value = float(input(f"Enter {col}: "))
        user_data[col] = value
    
    for col in categorical_cols:
        print(f"Possible values for {col}: {list(df[col].unique())}")
        value = input(f"Select a value for {col} from the above list: ")
        user_data[col] = value
    
    user_df = pd.DataFrame([user_data])
    
    return user_df

def predict_loan_amount(model, user_df):
    preprocessed_data = model.named_steps['preprocessor'].transform(user_df)
    
    loan_amount = model.named_steps['regressor'].predict(preprocessed_data)
    
    return loan_amount[0]

user_input_df = get_user_input()

predicted_loan_amount = predict_loan_amount(model, user_input_df)

print(f"The predicted loan amount is: ${predicted_loan_amount:.2f}")
