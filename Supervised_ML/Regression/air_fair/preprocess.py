# process.py
def preprocess_flight_data(df, is_train=True, column_template=None):
    import pandas as pd
    import numpy as np

    df = df.copy()

    # 1. Date
    df['Date_of_Journey'] = pd.to_datetime(df['Date_of_Journey'], dayfirst=True)
    df['Journey_day'] = df['Date_of_Journey'].dt.day
    df['Journey_month'] = df['Date_of_Journey'].dt.month
    df['Journey_year'] = df['Date_of_Journey'].dt.year
    df.drop(columns='Date_of_Journey', inplace=True)

    # 2. Dep Time
    df['Dep_Time'] = pd.to_datetime(df['Dep_Time'])
    df['Dep_total_time'] = df['Dep_Time'].dt.hour * 60 + df['Dep_Time'].dt.minute
    df.drop(columns='Dep_Time', inplace=True)

    # 3. Arrival Time
    df['Arrival_Time'] = df['Arrival_Time'].str.extract(r'(\d{2}:\d{2})')[0]
    df['Arrival_Time'] = pd.to_datetime(df['Arrival_Time'], format='%H:%M')
    df['Arrival_total_time'] = df['Arrival_Time'].dt.hour * 60 + df['Arrival_Time'].dt.minute
    df.drop(columns='Arrival_Time', inplace=True)

    # 4. Duration
    duration_split = df['Duration'].str.extract(r'(?:(\d+)h)? ?(?:(\d+)m)?')
    hours = duration_split[0].fillna(0).astype(int)
    minutes = duration_split[1].fillna(0).astype(int)
    df['Duration_total_time'] = hours * 60 + minutes
    df.drop(columns='Duration', inplace=True)

    # 5. Total Stops
    stop_map = {'non-stop': 0, '1 stop': 1, '2 stop': 2, '3 stop': 3, '4 stop': 4}
    df['Total_Stops'] = df['Total_Stops'].map(stop_map).fillna(1).astype(int)

    # 6. Drop if exists
    for col in ['Route', 'Additional_Info']:
        if col in df.columns:
            df.drop(columns=col, inplace=True)

    # 7. One-hot encode
    df = pd.get_dummies(df, columns=['Airline', 'Source', 'Destination'],
                        prefix=['Airline', 'Source', 'Dest'], drop_first=True)

    # 8. For inference: match training columns
    if not is_train and column_template is not None:
        missing_cols = set(column_template) - set(df.columns)
        for col in missing_cols:
            df[col] = 0
        df = df[column_template]

    return df
