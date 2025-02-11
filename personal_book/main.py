import psycopg2
from pprint import pprint


def create_db(conn):
    with conn.cursor() as cur:
        # удаление таблиц
        cur.execute("""
        DROP TABLE phones;
        DROP TABLE clients;
        """)
        cur.execute("""
        CREATE TABLE IF NOT EXISTS clients(
            client_id SERIAL PRIMARY KEY,
            first_name VARCHAR(40) NOT NULL,
            last_name VARCHAR(40) NOT NULL,
            email VARCHAR(60) UNIQUE NOT NULL
        );
        """)
        cur.execute("""
        CREATE TABLE IF NOT EXISTS phones(
            phone_id SERIAL PRIMARY KEY,
            phone_number VARCHAR(15),
            client_id INTEGER,
            FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE
        );
        """)
        conn.commit()  # фиксируем в БД        

def add_client(conn, first_name, last_name, email, phones=None):
    with conn.cursor() as cur:
        # Вставляем клиента в таблицу clients
        cur.execute("""INSERT INTO clients (first_name, last_name, email) VALUES (%s, %s, %s) RETURNING client_id;""",
                    (first_name, last_name, email))

        # Получаем идентификатор добавленного клиента
        client_id = cur.fetchone()[0]
        # Если телефоны указаны, добавляем их в таблицу phones
        if phones:
            for phone in phones:
                cur.execute("""INSERT INTO phones (client_id, phone_number) VALUES (%s, %s);""",
                            (client_id, phone))

        conn.commit()  # фиксируем изменения в БД

def add_phone(conn, client_id, phone):
    with conn.cursor() as cur:
        # Добавляем номер клиенту
        cur.execute("""INSERT INTO phones(client_id, phone_number) VALUES(%s, %s);""",(client_id, phone))

        conn.commit()  # фиксируем изменения в БД

def change_client(conn, client_id, first_name=None, last_name=None, email=None, phones=None):
    with conn.cursor() as cur:
        # Обновляем информацию о клиенте
        if first_name is not None:
            cur.execute("""UPDATE clients SET first_name = %s WHERE client_id = %s;""", (first_name, client_id))
        
        if last_name is not None:
            cur.execute("""UPDATE clients SET last_name = %s WHERE client_id = %s;""", (last_name, client_id))
        
        if email is not None:
            cur.execute("""UPDATE clients SET email = %s WHERE client_id = %s;""", (email, client_id))

        # Обновляем телефоны
        if phones is not None:
            # Удаляем старые телефоны
            cur.execute("""DELETE FROM phones WHERE client_id = %s;""", (client_id,))
            # Добавляем новые телефоны
            for phone in phones:
                cur.execute("""INSERT INTO phones (client_id, phone_number) VALUES (%s, %s);""", (client_id, phone))

        conn.commit()  # фиксируем изменения в БД

def delete_phone(conn, client_id, phone):
    with conn.cursor() as cur:
        cur.execute("""DELETE FROM phones WHERE client_id = %s AND phone_number = %s;""", (client_id, phone))
        
        conn.commit()  # фиксируем изменения в БД

def delete_client(conn, client_id):
    with conn.cursor() as cur:
        # Удаляем все телефоны клиента
        cur.execute("""DELETE FROM phones WHERE client_id = %s;""", (client_id,))
        # Удаляем клиента
        cur.execute("""DELETE FROM clients WHERE client_id = %s;""", (client_id,))
        
        conn.commit()  # фиксируем изменения в БД

def find_client(conn, first_name=None, last_name=None, email=None, phone=None):
    query = """
        SELECT clients.client_id, clients.first_name, clients.last_name, clients.email, phones.phone_number
        FROM clients
        LEFT JOIN phones ON clients.client_id = phones.client_id
        WHERE 1=1 
    """
    params = []

    if first_name is not None:
        query += " AND clients.first_name ILIKE %s"
        params.append(f'%{first_name}%')
    if last_name is not None:
        query += " AND clients.last_name ILIKE %s"
        params.append(f'%{last_name}%')
    if email is not None:
        query += " AND clients.email ILIKE %s"
        params.append(f'%{email}%')
    if phone is not None:
        query += " AND phones.phone_number ILIKE %s"
        params.append(f'%{phone}%')

    with conn.cursor() as cur:
        cur.execute(query, params)
        result = cur.fetchall()

    return result  # Возвращает список найденных клиентов


with psycopg2.connect(database="clients_db", user="postgres", password="postgre") as conn:    
    create_db(conn)

    add_client(conn, 'Иван', 'Иванов', 'ivan@example.com', ['12345', '56789'])
    add_client(conn, 'Петр', 'Петров', 'petr@example.com')
    add_client(conn, 'Дмитрий', 'Дмитров', 'dmitrov@example.com')

    add_phone(conn, 3, '11111111')
    change_client(conn, 3, 'DIMA', 'Dimov', 'domestos@example.com', ['222222', '3333333'])
    delete_phone(conn, 3, '3333333')
    delete_client(conn, 3)
    pprint(find_client(conn, first_name='Иван'))

conn.close()