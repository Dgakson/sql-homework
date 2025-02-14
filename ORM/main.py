import json
import sqlalchemy as sq
from sqlalchemy.orm import sessionmaker

import models as m


def read_data(file_path):
    """Функция чтения данных таблиц из отдельного файла"""
    with open(file_path, 'r', encoding='utf-8') as file:
        data = json.load(file)
        # Извлекаем нужные словари
        publisher_data = data.get('publisher_data', [])
        book_data = data.get('book_data', [])
        shop_data = data.get('shop_data', [])
        stock_data = data.get('stock_data', [])
        sale_data = data.get('sale_data', [])

        return publisher_data, book_data, shop_data, stock_data, sale_data

def add_objects(model_class, data_list):
    """Функция для добавления данных в таблицы"""
    objects = [model_class(**data) for data in data_list]
    session.add_all(objects)

def get_book_sales_by_author(author_name):
    """Получает информацию о продажах книг по фамилии автора."""
    if type(author_name) is str: 
        author_name = author_name.capitalize()

        result = (
            session.query(m.Book.title, m.Shop.name, m.Sale.price, m.Sale.date_sale)
            .join(m.Publisher, m.Publisher.id == m.Book.publisher_id)
            .join(m.Stock, m.Stock.book_id == m.Book.id)
            .join(m.Sale, m.Stock.id == m.Sale.id_stock)
            .join(m.Shop, m.Stock.shop_id == m.Shop.id)
            .filter(m.Publisher.name == author_name)
            .all()
        )
    if type(author_name) is int:
        result = (
            session.query(m.Book.title, m.Shop.name, m.Sale.price, m.Sale.date_sale)
            .join(m.Publisher, m.Publisher.id == m.Book.publisher_id)
            .join(m.Stock, m.Stock.book_id == m.Book.id)
            .join(m.Sale, m.Stock.id == m.Sale.id_stock)
            .join(m.Shop, m.Stock.shop_id == m.Shop.id)
            .filter(m.Publisher.id == author_name)
            .all()
        )
    
    print(f'\n\033[1mназвание книги | название магазина, в котором была куплена эта книга | стоимость покупки | дата покупки\033[0m')
    for r in result:
        print(f'{r[0]:<20} | {r[1]:<30} | {r[2]:<10} | {r[3]}')

def get_input():
    author_name = input('Введите фамилию автора или его id: ')
    # Попробуем преобразовать ввод в число
    try:
        # Проверяем, является ли ввод целым числом
        author_name = int(author_name)
        return author_name
    except ValueError:
        return author_name


if __name__ == '__main__': 

    # создание движка и подключение к базе данных
    # Можно 
    DSN = 'postgresql://postgres:postgre@localhost:5432/book_publishers_db'
    engine = sq.create_engine(DSN)

    #создание таблиц
    m.create_tables(engine)

    Session = sessionmaker(bind=engine)
    session = Session()

    # Прочитали данные из файла data.json
    publisher_data, book_data, shop_data, stock_data, sale_data = read_data("data.json")

    # Добавление данных в БД
    add_objects(m.Publisher, publisher_data)
    add_objects(m.Book, book_data)
    add_objects(m.Shop, shop_data)
    add_objects(m.Stock, stock_data)
    add_objects(m.Sale, sale_data)

    # фиксируем изменения
    session.commit()  

    # Поиск проданых книг
    author_name = get_input()
    get_book_sales_by_author(author_name)

    session.close()