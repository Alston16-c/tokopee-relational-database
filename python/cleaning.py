#  pip install faker pandas

import pandas as pd
import numpy as np
from faker import Faker
import random
import os
import time

fake = Faker()
print("=== SCRIPT GENERATOR DATABASE TOKOPEE ===")
print("Inisialisasi selesai...")

# 1. LOAD & CLEAN DATA
filename = 'online_retail_data.csv'

if not os.path.exists(filename):
    print(f"ERROR: File {filename} tidak ditemukan!")
    exit()

print(f"\n[1/7] Membaca file {filename} (ini mungkin memakan waktu 10-20 detik)...")
start_time = time.time()

dtype_dict = {
    'Invoice': 'object',
    'StockCode': 'object',
    'Description': 'object',
    'Quantity': 'int32',
    'Price': 'float32',
    'Customer ID': 'float32',
    'Country': 'object'
}

df = pd.read_csv(filename, dtype=dtype_dict)

print(f"-> Total baris mentah: {len(df):,}")

# Rename Columns
df = df.rename(columns={
    'Invoice': 'invoice_no',
    'StockCode': 'stock_code',
    'Description': 'product_name',
    'Quantity': 'quantity',
    'InvoiceDate': 'invoice_date',
    'Price': 'unit_price',
    'Customer ID': 'customer_id',
    'Country': 'country_name'
})

# Hapus baris tanpa CustomerID
print("-> Membersihkan data (menghapus Customer ID kosong)...")
df = df.dropna(subset=['customer_id', 'product_name'])
df['customer_id'] = df['customer_id'].astype(int)
df['invoice_date'] = pd.to_datetime(df['invoice_date'])
df['country_name'] = df['country_name'].str.strip().str.title()

print(f"-> Sisa baris bersih: {len(df):,} (Data Valid)")

# 2. GENERATE TABLES WILAYAH
print("\n[2/7] Membuat Data Wilayah (Country, Province, City)...")
countries = df['country_name'].unique()
country_rows = []
province_rows = []
city_rows = []

c_id_counter = 1
p_id_counter = 1
ct_id_counter = 1
city_ids = []

for country in countries:
    c_id = c_id_counter
    country_rows.append({'CountryID': c_id, 'CountryName': country})

    # Generate Provinsi Random
    for _ in range(2):
        p_id = p_id_counter
        p_name = fake.state()
        province_rows.append({'ProvinceID': p_id, 'ProvinceName': p_name, 'CountryID': c_id})

        # Generate Kota Random
        for _ in range(2):
            ct_id = ct_id_counter
            city_rows.append({
                'CityID': ct_id,
                'CityName': fake.city(),
                'Type': random.choice(['Kabupaten', 'Kota']),
                'ProvinceID': p_id
            })
            city_ids.append(ct_id)
            ct_id_counter += 1
        p_id_counter += 1
    c_id_counter += 1

# 3. GENERATE TABLES CUSTOMER
print("\n[3/7] Membuat Data Customer & Alamat (Faker)...")
unique_cust = df['customer_id'].unique()
print(f"-> Ditemukan {len(unique_cust):,} customer unik. Sedang generate nama palsu...")

customer_rows = []
address_rows = []
addr_id_counter = 1
cust_addr_map = {}

for i, cust_id in enumerate(unique_cust):
    full_name = fake.name()

    customer_rows.append({
        'CustomerID': cust_id,
        'CustomerName': full_name,
        'CustomerEmail': fake.free_email(),
        'CustomerPhone': fake.phone_number(),
        'RegisteredDate': fake.date_between(start_date='-3y', end_date='today')
    })

    addr_id = addr_id_counter
    address_rows.append({
        'AddressID': addr_id,
        'LabelAddress': 'Home',
        'ReceiverName': full_name,
        'ReceiverPhone': fake.phone_number(),
        'StreetDetail': fake.street_address(),
        'PostalCode': fake.postcode(),
        'IsActive': True,
        'CustomerID': cust_id,
        'CityID': random.choice(city_ids)
    })
    cust_addr_map[cust_id] = addr_id
    addr_id_counter += 1

# 4. GENERATE TABLE PRODUCT
print("\n[4/7] Membuat Data Produk Master...")
products = df.sort_values('invoice_date').groupby('stock_code').tail(1)[['stock_code', 'product_name', 'unit_price']]
products = products.rename(columns={'stock_code': 'StockCode', 'product_name': 'ProductName', 'unit_price': 'CurrentPrice'})
products['Description'] = products['ProductName']
products['CurrentStock'] = 10000

# 5. GENERATE TABLE INVOICE HEADER
print("\n[5/7] Menghitung Total Invoice (High Performance Mode)...")

df['line_total'] = df['quantity'] * df['unit_price']

invoice_header = df.groupby('invoice_no').agg({
    'invoice_date': 'first',
    'customer_id': 'first'
}).reset_index()

invoice_sums = df.groupby('invoice_no')['line_total'].sum().reset_index(name='TotalAmount')

invoices = pd.merge(invoice_header, invoice_sums, on='invoice_no')

invoices['Status'] = 'Completed'
invoices['AddressID'] = invoices['customer_id'].map(cust_addr_map)

tbl_invoice = invoices.rename(columns={'invoice_no': 'InvoiceID', 'invoice_date': 'InvoiceDate', 'customer_id': 'CustomerID'})

# 6. SAVE MASTER FILES
print("\n[6/7] Menyimpan File Master (CSV)...")
pd.DataFrame(country_rows).to_csv('Tbl_Country.csv', index=False)
pd.DataFrame(province_rows).to_csv('Tbl_Province.csv', index=False)
pd.DataFrame(city_rows).to_csv('Tbl_City.csv', index=False)
pd.DataFrame(customer_rows).to_csv('Tbl_Customer.csv', index=False)
pd.DataFrame(address_rows).to_csv('Tbl_CustomerAddress.csv', index=False)
products.to_csv('Tbl_Product.csv', index=False)
tbl_invoice.to_csv('Tbl_Invoice.csv', index=False)

# 7. GENERATE TABLE INVOICE DETAIL
print("\n[7/7] Memuat Table Invoice Detail...")
tbl_detail = df[['invoice_no', 'stock_code', 'quantity', 'unit_price']].copy()
tbl_detail = tbl_detail.rename(columns={'invoice_no': 'InvoiceID', 'stock_code': 'StockCode', 'quantity': 'Quantity', 'unit_price': 'UnitPrice'})

tbl_detail = (
    tbl_detail
    .groupby(['InvoiceID', 'StockCode'], as_index=False)
    .agg({
        'Quantity': 'sum',
        'UnitPrice': 'first'
    })
)

tbl_detail = tbl_detail[tbl_detail['Quantity'] != 0]
tbl_detail = tbl_detail[['InvoiceID', 'StockCode', 'Quantity', 'UnitPrice']]

tbl_detail.to_csv('Tbl_InvoiceDetail.csv', index=False)

print("\n=== SELESAI SEMPURNA! ===")
print(f"Waktu eksekusi: {round(time.time() - start_time, 2)} detik.")