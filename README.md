# 🏃‍♂️ Sleep & Activity Analysis using Amazfit Watch Data

## 📌 Overview

As an endurance athlete, I’ve always been curious about how my sleep and physical activity patterns interact. Using data from my **Amazfit smartwatch**, I built a personal data analytics project spanning **6 months (Nov–Jun)** to explore how training and recovery influence my sleep.

This project covers:
- Data extraction from Gmail
- Data cleaning and analysis using **MySQL**
- Python-based data pipelines
- Dashboard visualizations
- Correlation exploration
- A preliminary attempt at modeling sleep patterns

---

## 📦 Dataset

- **Source**: Exported personal data from my Amazfit Watch via Gmail.
- **Duration**: 6 months (November to June)
- **Features include**:  
  - Sleep durations (Total, Deep, REM)  
  - Daily activity & steps  
  - Heart rate metrics  
  - Long run days & recovery periods

---

## 🛠️ Tools & Technologies

- **SQL**: Data cleaning and querying pipeline
- **MySQL in Python**: Integrated the SQL logic using Python's `mysql.connector`
- **Python**: Data analysis, visualization, and correlation mapping
- **Pandas & Matplotlib**: For analysis and plotting
- **Dashboard**: Custom Python dashboard for trend discovery

---

## 📊 Key Findings

- **Sleep behavior trends**:
  - **Pre-run**: I consistently sleep **less before a long run**.
  - **Post-run**: Sleep duration increases the next day, but **deep sleep drops significantly**.
  - **High activity = Poor sleep quality**: Notably, **deep and REM sleep dip after intense activity**, reducing sleep efficiency.
  - **Low activity days**: Tend to result in **late bedtime and longer sleep**.
  - My **average sleep** hovered around **7 hours**, with average deep sleep at **~55 mins** and REM at **~62 mins**.

---

## 🔍 Modeling Attempt

I tried building a **predictive model** using Python to estimate sleep quality based on activity and past patterns, but:

- **Accuracy was low (~40%)**
- **Very few usable samples** due to:
  - High presence of outliers
  - Short dataset timeframe
  - Sleep pattern was largely constant (less variance)
- Deep learning approaches were considered, but more data was needed.

Thus, I decided to conclude the project as a **personal analytical deep dive**, rather than a deployable ML solution.

---

## 💡 Lessons & Takeaways

- Smartwatch data can reveal **fascinating insights**, especially when visualized properly.
- My sleep is **heavily influenced** by training intensity and scheduling.
- Cleaning pipelines in **SQL and Python** are crucial to extract usable trends from noisy personal data.
- **Data quantity and variance** are critical when training models for human behavior.

---

## 🧠 Future Scope

If I continue to log data for a longer period:
- I could train a more accurate ML/DL model.
- Explore **causal relationships** (e.g., does more REM sleep lead to better performance?)
- Build a **real-time recommendation system** for sleep & training optimization.

---

## 🙌 Final Thoughts

While the predictive part didn’t meet expectations due to data limitations, the **journey of self-discovery through data** was worth it. The dashboards and correlations gave me a better understanding of how training affects my recovery and overall well-being.
