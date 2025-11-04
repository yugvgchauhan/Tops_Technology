# app.py
import streamlit as st
import pandas as pd
import numpy as np
import pickle
import feedparser
from datetime import datetime
from preprocess import preprocess_flight_data  # Your function from process.py

# Load your saved model
with open("final_rf_model.pkl", "rb") as f:
    model = pickle.load(f)

# Load saved training columns
with open("X_columns.pkl", "rb") as f:
    X_columns = pickle.load(f)

# Title
st.title("✈️ Smart Flight Price Predictor")

# Tabs
tabs = st.tabs(["Price Prediction", "Airline News"])

# ----------------------------
# Tab 1: Price Prediction
# ----------------------------
with tabs[0]:
    st.subheader("Enter Flight Details")

    col1, col2 = st.columns(2)
    with col1:
        date = st.date_input("Date of Journey", value=datetime(2025, 8, 1))
        Date_of_Journey = date.strftime("%d/%m/%Y")

        Airline = st.selectbox("Airline", ["Air India", "GoAir", "IndiGo", "Jet Airways",
                                           "Jet Airways Business", "Multiple carriers",
                                           "Multiple carriers Premium economy", "SpiceJet",
                                           "Trujet", "Vistara", "Vistara Premium economy"])
        Source = st.selectbox("Source", ["Delhi", "Kolkata", "Mumbai", "Chennai", "Bangalore"])
        Destination = st.selectbox("Destination", ["Cochin", "Delhi", "Hyderabad", "Kolkata", "New Delhi", "Banglore"])

    with col2:
        Total_Stops = st.selectbox("Total Stops", ["non-stop", "1 stop", "2 stop", "3 stop", "4 stop"])
        dep_time = st.time_input("Departure Time")
        arr_time = st.time_input("Arrival Time")
        Duration = st.text_input("Duration (e.g. 2h 45m)", "2h 45m")

    input_data = {
        'Date_of_Journey': Date_of_Journey,
        'Airline': Airline,
        'Source': Source,
        'Destination': Destination,
        'Total_Stops': Total_Stops,
        'Dep_Time': dep_time.strftime("%H:%M"),
        'Arrival_Time': arr_time.strftime("%H:%M"),
        'Duration': Duration
    }

    if st.button("Predict Price"):
        input_df = pd.DataFrame([input_data])
        try:
            processed_input = preprocess_flight_data(input_df, is_train=False, column_template=X_columns)
            price = model.predict(processed_input)[0]
            st.success(f"💰 Estimated Flight Price: ₹{round(price, 2)}")

        except Exception as e:
            st.error(f"❌ Error during prediction: {e}")

# ----------------------------
# Tab 2: Airline News
# ----------------------------
with tabs[1]:
    st.header("📰 Latest Airline News")

    def fetch_airline_news():
        feed_url = "https://simpleflying.com/feed/category/aviation-news/airlines/"
        try:
            feed = feedparser.parse(feed_url)
            news = []
            for entry in feed.entries[:5]:
                news.append({
                    "title": entry.title,
                    "link": entry.link,
                    "published": entry.published
                })
            return news
        except:
            return []

    news_items = fetch_airline_news()
    if news_items:
        for item in news_items:
            st.markdown(f"### [{item['title']}]({item['link']})")
            st.caption(f"Published on: {item['published']}")
            st.write("---")
    else:
        st.write("No news available at this time.")
