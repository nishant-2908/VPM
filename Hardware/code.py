# Importing the required libraries
from machine import ADC, Pin, I2C
from network import WLAN, STA_IF
from time import sleep
import utime
from urequests import request
import json
from lcd_i2c import LCD
from random import randint
from gc import collect

DEVICE_ADDRESS = 'BAV'

# Defining the SSID and password
SSID = 'OnePlus7'
PASSWORD = 'nishantpanchal2908'

# Declaring the API_KEY
api_key = 'r6ceRUK4eE7Iez5heqJyDalib5e3CJcCuVJxY8jnq9vqwW5gGZJQLAN6HMFkQVbs'

# Initializing the LCD
i2c = I2C(0, scl=Pin(22), sda=Pin(21), freq=800000) # SCL 13 and SDA 12
lcd = LCD(addr=0x27, cols=16, rows=2, i2c=i2c)
lcd.begin()
lcd.backlight()
lcd.no_cursor()

# Connecting to the network
def connect_to_wifi(ssid, password):
    lcd.home()
    lcd.clear()
    wlan = WLAN(STA_IF) # Defining the WLAN stations
    if wlan.isconnected(): # If already connected to any Wi-Fi network
        lcd.print("Already")
        lcd.set_cursor(col=0, row=1)
        lcd.print("Connected")
        print("Wi-Fi already connected")
        return
    else:
        wlan.active(True) # Turning the STA_IF station ON
        ssids = [str(station[0])[2:-1] for station in wlan.scan()] # Getting the list of available network around
        if ssid in ssids: # If the SSID in the nearby stations
            try:
                lcd.home()
                lcd.clear()
                wlan.connect(ssid, password) # Connecting to the network
                print("Successfully connected")
                lcd.print("Successfully")
                lcd.set_cursor(col=0, row=1)
                lcd.print("Connected")
                print("Wi-Fi successfully connected")
            except:
                lcd.home()
                lcd.clear()
                lcd.print("Please check")
                lcd.set_cursor(col=0, row=1)
                lcd.print("the credentials")
                print("Please check the credentials") # Otherwise print wrong credentials
        else:
            lcd.home()
            lcd.clear()
            lcd.print("Consider turning")
            lcd.set_cursor(col=0, row=1)
            lcd.print("your hotspot on")
            sleep(3)
            lcd.clear()
            lcd.home()
            lcd.print("Retrying after")
            lcd.set_cursor(row=1, col=0)
            lcd.print("3 seconds")
            print("Retrying after 5 seconds") # Trying after 5 seconds
            collect() # Collecting the cache
            sleep(3)
            lcd.clear()
            lcd.home()
            lcd.print("Retrying..")
            print("Retrying")
            connect_to_wifi(ssid, password)
            
# Reading if the device needs to be turned on
def read_data():
    # Defining the URL
    url = "https://ap-south-1.aws.data.mongodb-api.com/app/data-egfvn/endpoint/data/v1/action/findOne"
    # Defining the payload in JSON
    payload = json.dumps({
        "collection": "VP_Collection",
        "database": "VP_Data",
        "dataSource": "AtlasCluster",
        "filter": {
            "ID": "MainSwitch",
            "Device Address":  DEVICE_ADDRESS,
        }
    })
    headers = {
      'Content-Type': 'application/json',
      'Access-Control-Request-Headers': '*',
      'api-key': api_key,
    }
    # POST the request with the header and the payload
    try:
        response = request("POST", url, headers=headers, data=payload)
        # If object needs to be turned on
        if str(response.json()['document']['Switch']) == 'ON':
            lcd.clear()
            lcd.home()
            lcd.print("Turning the")
            lcd.set_cursor(col=0, row=1)
            lcd.print("Device ON")
            return
        else:
            collect() # Collect the cache
            read_data()
    except:
        sleep(1)
        read_data()

def device_address():
    lcd.clear()
    lcd.home()
    lcd.print("Device Address: ")
    lcd.set_cursor(col=6, row=1)
    lcd.print(DEVICE_ADDRESS)

def analog_readings(pin1: int, pin2: int):
    reading1 = [] # CO2
    reading2 = [] # CO
    adc1 = ADC(Pin(pin1))
    adc2 = ADC(Pin(pin2))
    
    start_time = utime.time()
    while utime.time() - start_time < 5:  # Collect readings for 10 seconds
        reading1.append(adc1.read()) # Reading the ADC and append to the list
        reading2.append(adc2.read()) # Reading the ADC and append to the list
        sleep(1)  # Delay for 1 second between readings
    
    average1 = sum(reading1) / len(reading1) # Calculating the average
    average2 = sum(reading2) / len(reading2)
    reading1.clear()
    reading2.clear()
    average1/=1000
    average2/=1000
    lcd.clear()
    lcd.home()
    lcd.print("CO2: ")
    lcd.set_cursor(col=6, row=0)
    lcd.print(str(average1))
    lcd.set_cursor(col=0, row=1)
    lcd.print("CO: ")
    lcd.set_cursor(col=6, row=1)
    lcd.print(str(average2))
    
    return average1, average2

# Inserting the data into database
def insert_data(value1: int, value2: int):
    # Defining the payload in JSON object
    url = "https://ap-south-1.aws.data.mongodb-api.com/app/data-egfvn/endpoint/data/v1/action/insertOne"
    payload = json.dumps({
        "collection": "VP_Collection",
        "database": "VP_Data",
        "dataSource": "AtlasCluster",
        "document": {
            "Carbon Dioxide Value": value1,
            "Carbon Monoxide Value": value2,
            "Device Address": DEVICE_ADDRESS,
            "Object-Type": "Vehicle-Details",
            "Vehicle Number": "",
            "Engine Capacity": "",
            "Engine Stage": "",
            "Fuel": "",
        }
    })
    # Defining the headers
    headers = {
      'Content-Type': 'application/json',
      'Access-Control-Request-Headers': '*',
      'api-key': api_key,
      'Accept': 'application/json'
    }
    # POST the requrst with the payload and header
    response = request("POST", url, headers=headers, data=payload)

    print(response.status_code)
    print(response.json())
    # Checking if the request made was successful
    if response.status_code == 201:
        print("Data successfully posted")
    else:
        print("Retrying")
        collect()

# Disconnecting the WIFI
def disconnect_wifi():
    wifi = WLAN(STA_IF)
    wifi.disconnect()
    sleep(2)
    return

# Checking if the process gets completed
def update_the_Switch():
    url = "https://ap-south-1.aws.data.mongodb-api.com/app/data-egfvn/endpoint/data/v1/action/updateOne"
    # Defining the payload in JSON
    payload = json.dumps({
        "collection": "VP_Collection",
        "database": "VP_Data",
        "dataSource": "AtlasCluster",
        "filter": {
            "ID": "MainSwitch",
            "Device Address": DEVICE_ADDRESS,
        },
        "update": {
        "$set": {
            "Switch": "OFF"
        }
    }
    })
    # Defining the headers
    headers = {
      'Content-Type': 'application/json',
      'Access-Control-Request-Headers': '*',
      'api-key': api_key,
    }
    # POST the request with the payload and header
    response = request("POST", url, headers=headers, data=payload)
    # Checking if the user has submitted the other details

lcd.home()
lcd.clear()
lcd.print("Welcome to")
lcd.set_cursor(col=0, row=1)
lcd.print("Pollution Meter")
sleep(2)
lcd.clear()
lcd.home()
lcd.print("Device Address: ")
lcd.set_cursor(col=0, row=1)
lcd.print(DEVICE_ADDRESS)
sleep(3)
connect_to_wifi(SSID, PASSWORD)
read_data()
co2, co = analog_readings(34, 35)
print(co2, co)
insert_data(co2, co)
update_the_Switch()
lcd.clear()
lcd.home()
lcd.print("Enter the ")
lcd.set_cursor(col=0, row=1)
lcd.print("number in APP")
sleep(5)
lcd.home()
lcd.clear()
lcd.print("Turn the")
lcd.set_cursor(col=0, row=1)
lcd.print("Device OFF")
disconnect_wifi()
lcd.no_display()

