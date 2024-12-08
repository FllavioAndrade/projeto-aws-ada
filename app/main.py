import csv
import random
from datetime import datetime, timedelta

def generate_random_data(num_rows):
    data = []
    current_date = datetime.now()
    
    for _ in range(num_rows):
        row = {
            'id': random.randint(1000, 9999),
            'value': round(random.uniform(10.0, 1000.0), 2),
            'date': (current_date - timedelta(days=random.randint(0, 365))).strftime('%Y-%m-%d'),
            'category': random.choice(['A', 'B', 'C', 'D'])
        }
        data.append(row)
    
    return data

def create_csv_file():
    num_rows = random.randint(0, 100)
    data = generate_random_data(num_rows)
    
    filename = f'data_{datetime.now().strftime("%Y%m%d_%H%M%S")}.csv'
    
    with open(filename, 'w', newline='') as csvfile:
        fieldnames = ['id', 'value', 'date', 'category']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        
        writer.writeheader()
        writer.writerows(data)
    
    print(f"Created CSV file '{filename}' with {num_rows} rows")
    return filename

if __name__ == "__main__":
    create_csv_file()