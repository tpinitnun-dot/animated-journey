-- สคริปต์สร้างตารางฐานข้อมูล Cloudflare D1 SQL Database สำหรับระบบคู่มือหัวหน้าทัวร์

DROP TABLE IF EXISTS contacts;
DROP TABLE IF EXISTS vouchers;
DROP TABLE IF EXISTS itinerary_events;
DROP TABLE IF EXISTS itineraries;
DROP TABLE IF EXISTS hotels;
DROP TABLE IF EXISTS tours;

-- 1. ตารางข้อมูลโปรแกรมทัวร์ภาพรวม (Tours Overview)
CREATE TABLE tours (
    id TEXT PRIMARY KEY, -- เช่น 'JP-TFK-0924'
    tour_name TEXT NOT NULL,
    tour_code TEXT NOT NULL,
    tour_dates TEXT NOT NULL,
    guide_name TEXT NOT NULL,
    guide_phone TEXT NOT NULL,
    pax_count INTEGER DEFAULT 0,
    passenger_summary TEXT, -- เก็บในรูปแบบ JSON array หรือข้อความแยกบรรทัด
    
    -- เที่ยวบินขาไป
    flight_dep_airline TEXT,
    flight_dep_no TEXT,
    flight_dep_route TEXT,
    flight_dep_time TEXT,
    flight_dep_arr_time TEXT,
    flight_dep_terminal TEXT,
    flight_dep_pnr TEXT,
    flight_dep_baggage TEXT,
    
    -- เที่ยวบินขากลับ
    flight_ret_airline TEXT,
    flight_ret_no TEXT,
    flight_ret_route TEXT,
    flight_ret_time TEXT,
    flight_ret_arr_time TEXT,
    flight_ret_terminal TEXT,
    flight_ret_pnr TEXT,
    flight_ret_baggage TEXT
);

-- 2. ตารางรายชื่อโรงแรมที่จอง (Hotels)
CREATE TABLE hotels (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    tour_id TEXT NOT NULL,
    nights TEXT NOT NULL,
    name TEXT NOT NULL,
    phone TEXT,
    address TEXT,
    booking_id TEXT,
    rooms_count TEXT,
    FOREIGN KEY (tour_id) REFERENCES tours(id) ON DELETE CASCADE
);

-- 3. ตารางแผนการเดินทางหลักในแต่ละวัน (Itineraries)
CREATE TABLE itineraries (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    tour_id TEXT NOT NULL,
    day_num INTEGER NOT NULL,
    title TEXT NOT NULL,
    date TEXT NOT NULL,
    weather_mock TEXT,
    FOREIGN KEY (tour_id) REFERENCES tours(id) ON DELETE CASCADE
);

-- 4. ตารางกิจกรรมย่อยรายชั่วโมงในแต่ละวัน (Itinerary Events)
CREATE TABLE itinerary_events (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    itinerary_id INTEGER NOT NULL,
    time TEXT NOT NULL,
    activity TEXT NOT NULL,
    location TEXT NOT NULL,
    highlight TEXT,
    guide_note TEXT,
    FOREIGN KEY (itinerary_id) REFERENCES itineraries(id) ON DELETE CASCADE
);

-- 5. ตารางเก็บเอกสารเวาเชอร์และการจองต่างๆ (Vouchers)
CREATE TABLE vouchers (
    id TEXT PRIMARY KEY, -- เช่น 'v-flight-dep'
    tour_id TEXT NOT NULL,
    category TEXT NOT NULL,
    title TEXT NOT NULL,
    subtitle TEXT,
    reference_code TEXT NOT NULL,
    valid_date TEXT,
    details_html TEXT, -- เก็บ HTML สำหรับแสดงผลข้อมูลตั๋วโดยเฉพาะ
    FOREIGN KEY (tour_id) REFERENCES tours(id) ON DELETE CASCADE
);

-- 6. ตารางสมุดโทรศัพท์คู่ค้าและเบอร์ฉุกเฉิน (Contacts)
CREATE TABLE contacts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    tour_id TEXT NOT NULL,
    category TEXT NOT NULL, -- เช่น 'Local Team', 'Partners', 'Emergency'
    name TEXT NOT NULL,
    role TEXT NOT NULL,
    phone TEXT NOT NULL,
    line_id TEXT,
    note TEXT,
    FOREIGN KEY (tour_id) REFERENCES tours(id) ON DELETE CASCADE
);
